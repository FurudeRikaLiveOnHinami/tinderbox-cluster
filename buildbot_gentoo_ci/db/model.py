# This file has parts from Buildbot and is modifyed by Gentoo Authors. 
# Buildbot is free software: you can redistribute it and/or modify it 
# under the terms of the GNU General Public License as published by the 
# Free Software Foundation, version 2.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, write to the Free Software Foundation, Inc., 51
# Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#
# Copyright Buildbot Team Members
# Origins: buildbot.db.model.py
# Modifyed by Gentoo Authors.
# Copyright 2020 Gentoo Authors

import uuid
import alembic
import alembic.config
import sqlalchemy as sa

from twisted.internet import defer
from twisted.python import log
from twisted.python import util

from buildbot.db import base
from buildbot.db.migrate_utils import test_unicode
from buildbot.util import sautils


class Model(base.DBConnectorComponent):
    #
    # schema
    #

    metadata = sa.MetaData()

    # NOTES

    # * server_defaults here are included to match those added by the migration
    #   scripts, but they should not be depended on - all code accessing these
    #   tables should supply default values as necessary.  The defaults are
    #   required during migration when adding non-nullable columns to existing
    #   tables.
    #
    # * dates are stored as unix timestamps (UTC-ish epoch time)
    #
    # * sqlalchemy does not handle sa.Boolean very well on MySQL or Postgres;
    #   use sa.SmallInteger instead

    # Tables related to gentoo-ci-cloud
    # -------------------------

    repositorys = sautils.Table(
        "repositorys", metadata,
        # unique id per repository
        sa.Column('uuid', sa.String(36), primary_key=True,
                  default=lambda: str(uuid.uuid4()),
                  ),
        # repository's name
        sa.Column('name', sa.String(255), nullable=False),
        # description of the repository
        sa.Column('description', sa.Text, nullable=True),
        sa.Column('url', sa.String(255), nullable=True),
        sa.Column('type', sa.Enum('gitpuller'), nullable=False, default='gitpuller'),
        sa.Column('auto', sa.Boolean, default=False),
        sa.Column('enabled', sa.Boolean, default=False),
        sa.Column('ebuild', sa.Boolean, default=False),
    )

    # Use by GitPoller
    repositorys_gitpullers = sautils.Table(
        "repositorys_gitpullers", metadata,
        # unique id per repository
        sa.Column('id', sa.Integer, primary_key=True),
        sa.Column('repository_uuid', sa.String(36),
                  sa.ForeignKey('repositorys.uuid', ondelete='CASCADE'),
                  nullable=False),
        sa.Column('project', sa.String(255), nullable=False, default='gentoo'),
        sa.Column('url', sa.String(255), nullable=False),
        sa.Column('branches', sa.String(255), nullable=False, default='all'),
        sa.Column('poll_interval', sa.Integer, nullable=False, default=600),
        sa.Column('poll_random_delay_min', sa.Integer, nullable=False, default=600),
        sa.Column('poll_random_delay_max', sa.Integer, nullable=False, default=600),
        sa.Column('updated_at', sa.Integer, nullable=True),
    )

    projects = sautils.Table(
        "projects", metadata,
        # unique id per project
        sa.Column('uuid', sa.String(36), primary_key=True,
                  default=lambda: str(uuid.uuid4())),
        # project's name
        sa.Column('name', sa.String(255), nullable=False),
        # description of the project
        sa.Column('description', sa.Text, nullable=True),
        sa.Column('profile', sa.String(255), nullable=False),
        sa.Column('profile_repository_uuid', sa.String(36),
                  sa.ForeignKey('repositorys.uuid', ondelete='CASCADE'),
                  nullable=False),
        sa.Column('keyword_id', sa.Integer,
                  sa.ForeignKey('keywords.id', ondelete='CASCADE'),
                  nullable=False),
        # sa.Column('image', sa.String(255), nullable=False),
        sa.Column('status', sa.Enum('stable','unstable','all'), nullable=False),
        sa.Column('auto', sa.Boolean, default=False),
        sa.Column('enabled', sa.Boolean, default=False),
        sa.Column('use_default', sa.Boolean, default=True),
        sa.Column('created_by', sa.Integer,
                  sa.ForeignKey('users.uid', ondelete='CASCADE'),
                  nullable=False),
    )

    # What repository's use by projects
    projects_repositorys = sautils.Table(
        "projects_repositorys", metadata,
        sa.Column('id', sa.Integer, primary_key=True),
        sa.Column('project_uuid', sa.String(36),
                  sa.ForeignKey('projects.uuid', ondelete='CASCADE'),
                  nullable=False),
        sa.Column('repository_uuid', sa.String(36),
                  sa.ForeignKey('repositorys.uuid', ondelete='CASCADE'),
                  nullable=False),
        sa.Column('auto', sa.Boolean, default=False),
        sa.Column('pkgcheck', sa.Enum('package','full','none'), default='none'),
        sa.Column('build', sa.Boolean, default=False),
        sa.Column('test', sa.Boolean, default=False),
    )

    # projects etc/portage settings
    projects_portage = sautils.Table(
        "projects_portage", metadata,
        sa.Column('id', sa.Integer, primary_key=True),
        sa.Column('project_uuid', sa.String(36),
                  sa.ForeignKey('projects.uuid', ondelete='CASCADE'),
                  nullable=False),
        sa.Column('directorys', sa.Enum('make.profile', 'repos.conf'), nullable=False),
        sa.Column('value', sa.String(255), nullable=False),
    )

    portages_makeconf = sautils.Table(
        "portages_makeconf", metadata,
        sa.Column('id', sa.Integer, primary_key=True),
        sa.Column('variable', sa.String(255), nullable=False),
    )

    projects_portages_makeconf = sautils.Table(
        "projects_portages_makeconf", metadata,
        sa.Column('id', sa.Integer, primary_key=True),
        sa.Column('project_uuid', sa.String(36),
                  sa.ForeignKey('projects.uuid', ondelete='CASCADE'),
                  nullable=False),
        sa.Column('makeconf_id', sa.String(255),
                  sa.ForeignKey('portages_makeconf.id', ondelete='CASCADE'),
                  nullable=False),
        sa.Column('value', sa.String(255), nullable=False),
    )

    # projects etc/portage/env settings
    projects_portages_env = sautils.Table(
        "projects_portages_env", metadata,
        sa.Column('id', sa.Integer, primary_key=True),
        sa.Column('project_uuid', sa.String(36),
                  sa.ForeignKey('projects.uuid', ondelete='CASCADE'),
                  nullable=False),
        sa.Column('makeconf_id', sa.String(255),
                  sa.ForeignKey('portages_makeconf.id', ondelete='CASCADE'),
                  nullable=False),
        sa.Column('name', sa.String(255), nullable=False),
        sa.Column('value', sa.String(255), nullable=False),
    )

    # projects etc/portage/package.* settings
    projects_portages_package = sautils.Table(
        "projects_portages_package", metadata,
        sa.Column('id', sa.Integer, primary_key=True),
        sa.Column('project_uuid', sa.String(36),
                  sa.ForeignKey('projects.uuid', ondelete='CASCADE'),
                  nullable=False),
        sa.Column('directory', sa.Enum('use', 'accept_keywords', 'env', 'exclude'), nullable=False),
        sa.Column('package', sa.String(255), nullable=False),
        sa.Column('value', sa.String(255), nullable=True),
    )

    projects_emerge_options = sautils.Table(
        "projects_emerge_options", metadata,
        sa.Column('id', sa.Integer, primary_key=True),
        sa.Column('project_uuid', sa.String(36),
                  sa.ForeignKey('projects.uuid', ondelete='CASCADE'),
                  nullable=False),
        sa.Column('oneshot', sa.Boolean, default=True),
        sa.Column('depclean', sa.Boolean, default=True),
        sa.Column('preserved_libs', sa.Boolean, default=True),
    )

    projects_builds = sautils.Table(
        "projects_builds", metadata,
        sa.Column('id', sa.Integer, primary_key=True),
        sa.Column('build_id', sa.Integer),
        sa.Column('project_uuid', sa.String(36),
                  sa.ForeignKey('projects.uuid', ondelete='CASCADE'),
                  nullable=False),
        sa.Column('version_uuid', sa.String(36),
                  sa.ForeignKey('versions.uuid', ondelete='CASCADE'),
                  nullable=False),
        sa.Column('buildbot_build_id', sa.Integer),
        sa.Column('status', sa.Enum('failed','completed','in-progress','waiting', 'warning'), nullable=False),
        sa.Column('requested', sa.Boolean, default=False),
        sa.Column('created_at', sa.Integer, nullable=True),
        sa.Column('updated_at', sa.Integer, nullable=True),
        sa.Column('deleted', sa.Boolean, default=False),
        sa.Column('deleted_at', sa.Integer, nullable=True),
    )

    projects_pattern = sautils.Table(
        "projects_pattern", metadata,
        sa.Column('id', sa.Integer, primary_key=True),
        sa.Column('project_uuid', sa.String(36),
                  sa.ForeignKey('projects.uuid', ondelete='CASCADE'),
                  nullable=False),
        sa.Column('search', sa.String(50), nullable=False),
        sa.Column('start', sa.Integer, default=0),
        sa.Column('end', sa.Integer, default=0),
        sa.Column('status', sa.Enum('info', 'warning', 'ignore', 'error'), default='info'),
        sa.Column('type', sa.Enum('info', 'qa', 'compile', 'configure', 'install', 'postinst', 'prepare', 'pretend', 'setup', 'test', 'unpack', 'ignore', 'issues', 'misc', 'elog'), default='info'),
        sa.Column('search_type', sa.Enum('in', 'startswith', 'endswith', 'search'), default='in'),
    )

    projects_workers = sautils.Table(
        "projects_workers", metadata,
        sa.Column('id', sa.Integer, primary_key=True),
        sa.Column('project_uuid', sa.String(36),
                  sa.ForeignKey('projects.uuid', ondelete='CASCADE'),
                  nullable=False),
        sa.Column('worker_uuid', sa.String(36),
                  sa.ForeignKey('workers.uuid', ondelete='CASCADE'),
                  nullable=False),
    )

    keywords = sautils.Table(
        "keywords", metadata,
        # unique uuid per keyword
        sa.Column('id', sa.Integer, primary_key=True),
        # project's name
        sa.Column('name', sa.String(255), nullable=False),
    )

    categorys = sautils.Table(
        "categorys", metadata,
        sa.Column('uuid', sa.String(36), primary_key=True,
                  default=lambda: str(uuid.uuid4())),
        sa.Column('name', sa.String(255), nullable=False),
    )

    packages = sautils.Table(
        "packages", metadata,
        sa.Column('uuid', sa.String(36), primary_key=True,
                  default=lambda: str(uuid.uuid4())),
        sa.Column('name', sa.String(255), nullable=False),
        sa.Column('category_uuid', sa.String(36),
                  sa.ForeignKey('categorys.uuid', ondelete='CASCADE'),
                  nullable=False),
        sa.Column('repository_uuid', sa.String(36),
                  sa.ForeignKey('repositorys.uuid', ondelete='CASCADE'),
                  nullable=False),
        sa.Column('deleted', sa.Boolean, default=False),
        sa.Column('deleted_at', sa.Integer, nullable=True),
    )

    versions = sautils.Table(
        "versions", metadata,
        sa.Column('uuid', sa.String(36), primary_key=True,
                  default=lambda: str(uuid.uuid4())),
        sa.Column('name', sa.String(255), nullable=False),
        sa.Column('package_uuid', sa.String(36),
                  sa.ForeignKey('packages.uuid', ondelete='CASCADE'),
                  nullable=False),
        sa.Column('file_hash', sa.String(255), nullable=False),
        sa.Column('commit_id', sa.String(255), nullable=False),
        sa.Column('deleted', sa.Boolean, default=False),
        sa.Column('deleted_at', sa.Integer, nullable=True),
    )

    versions_keywords = sautils.Table(
        "versions_keywords", metadata,
        # unique id per project
        sa.Column('uuid', sa.String(36), primary_key=True,
                  default=lambda: str(uuid.uuid4())),
        # project's name
        sa.Column('keyword_id', sa.Integer,
                  sa.ForeignKey('keywords.id', ondelete='CASCADE')),
        sa.Column('version_uuid', sa.String(36),
                  sa.ForeignKey('versions.uuid', ondelete='CASCADE')),
        sa.Column('status', sa.Enum('stable','unstable','negative','all'), nullable=False),
    )

    versions_metadata = sautils.Table(
        "versions_metadata", metadata,
        # unique id per project
        sa.Column('id', sa.Integer, primary_key=True),
        sa.Column('version_uuid', sa.String(36),
                  sa.ForeignKey('versions.uuid', ondelete='CASCADE')),
        sa.Column('metadata', sa.Enum('restrict', 'properties', 'iuse', 'required use', 'keyword'), nullable=False),
        sa.Column('value', sa.String(255), nullable=False),
    )

    workers = sautils.Table(
        "workers", metadata,
        # unique id per project
        sa.Column('uuid', sa.String(36), primary_key=True,
                  default=lambda: str(uuid.uuid4())),
        sa.Column('type', sa.Enum('local','default','latent'), nullable=False),
        sa.Column('enabled', sa.Boolean, default=False),
    )

    # Tables related to users
    # -----------------------

    # This table identifies individual users, and contains buildbot-specific
    # information about those users.
    users = sautils.Table(
        "users", metadata,
        # unique user id number
        sa.Column("uid", sa.Integer, primary_key=True),

        # identifier (nickname) for this user; used for display
        sa.Column("email", sa.String(255), nullable=False),

        # username portion of user credentials for authentication
        sa.Column("bb_username", sa.String(128)),

        # password portion of user credentials for authentication
        sa.Column("bb_password", sa.String(128)),
    )

    # Indexes
    # -------

   

    # MySQL creates indexes for foreign keys, and these appear in the
    # reflection.  This is a list of (table, index) names that should be
    # expected on this platform

    implied_indexes = [
    ]

    # Migration support
    # -----------------

    # Buildbot has historically used 3 database migration systems:
    # - homegrown system that used "version" table to track versions
    # - SQLAlchemy-migrate that used "migrate_version" table to track versions
    # - alembic that uses "alembic_version" table to track versions (current)
    # We need to detect each case and tell the user how to upgrade.

    config_path = util.sibpath(__file__, "migrations/alembic.ini")

    def table_exists(self, conn, table):
        try:
            r = conn.execute(f"select * from {table} limit 1")
            r.close()
            return True
        except Exception:
            return False

    def migrate_get_version(self, conn):
        r = conn.execute("select version from migrate_version limit 1")
        version = r.scalar()
        r.close()
        return version

    def alembic_get_scripts(self):
        alembic_config = alembic.config.Config(self.config_path)
        return alembic.script.ScriptDirectory.from_config(alembic_config)

    def alembic_stamp(self, conn, alembic_scripts, revision):
        context = alembic.runtime.migration.MigrationContext.configure(conn)
        context.stamp(alembic_scripts, revision)

    @defer.inlineCallbacks
    def is_current(self):
        def thd(conn):
            if not self.table_exists(conn, 'alembic_version'):
                return False

            alembic_scripts = self.alembic_get_scripts()
            current_script_rev_head = alembic_scripts.get_current_head()

            context = alembic.runtime.migration.MigrationContext.configure(conn)
            current_rev = context.get_current_revision()

            return current_rev == current_script_rev_head

        ret = yield self.db.pool.do(thd)
        return ret

    # returns a Deferred that returns None
    def create(self):
        # this is nice and simple, but used only for tests
        def thd(engine):
            self.metadata.create_all(bind=engine)
        return self.db.pool.do_with_engine(thd)

    @defer.inlineCallbacks
    def upgrade(self):
        
        # the upgrade process must run in a db thread
        def thd(conn):
            alembic_scripts = self.alembic_get_scripts()
            current_script_rev_head = alembic_scripts.get_current_head()

            if self.table_exists(conn, 'version'):
                raise UpgradeFromBefore0p9Error()

            if self.table_exists(conn, 'migrate_version'):
                version = self.migrate_get_version(conn)

                if version < 40:
                    raise UpgradeFromBefore0p9Error()

                last_sqlalchemy_migrate_version = 58
                if version != last_sqlalchemy_migrate_version:
                    raise UpgradeFromBefore3p0Error()

                self.alembic_stamp(conn, alembic_scripts, alembic_scripts.get_base())
                conn.execute('drop table migrate_version')

            if not self.table_exists(conn, 'alembic_version'):
                log.msg("Initializing empty database")

                # Do some tests first
                test_unicode(conn)

                Model.metadata.create_all(conn)
                self.alembic_stamp(conn, alembic_scripts, current_script_rev_head)
                return

            context = alembic.runtime.migration.MigrationContext.configure(conn)
            current_rev = context.get_current_revision()

            if current_rev == current_script_rev_head:
                log.msg('Upgrading database: the current database schema is already the newest')
                return

            log.msg('Upgrading database')
            with sautils.withoutSqliteForeignKeys(conn):
                with context.begin_transaction():
                    context.run_migrations()

            log.msg('Upgrading database: done')

        yield self.db.pool.do(thd)

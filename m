Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018Ab2G3KDA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 06:03:00 -0400
Received: from nat.scz.novell.com ([213.151.88.252]:1557 "EHLO linux.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752177Ab2G3KC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 06:02:59 -0400
Date: Mon, 30 Jul 2012 12:02:57 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: bpoirier@suse.de, cody@linux.vnet.ibm.com, mmarek@suse.cz,
        pebolle@tiscali.nl, rostedt@goodmis.org, yann.morin.1998@free.fr,
        yselkowitz@users.sourceforge.net, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] kconfig changes for 3.6-rc1
Message-ID: <20120730100257.GA65112@noe.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull following kconfig changes for v3.6-rc1:
* kconfig Makefile portability fixes
* menuconfig/nconfig help pager usability fix
* .gitignore cleanup
* quoting fix in scripts/config
* Makefile prints errors to stderr
* support for arbitrarily log lines in .config
* fix oldnoconfig description in 'make help'

Thanks,
Michal

The following changes since commit f8f5701bdaf9134b1f90e5044a82c66324d2073f:

  Linux 3.5-rc1 (2012-06-02 18:29:26 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git kconfig

Benjamin Poirier (2):
      menuconfig: add u, d, q command keys in text boxes
      nconf: add u, d command keys in scroll windows

Cody Schafer (1):
      kconfig: allow long lines in config file

Michal Marek (1):
      kconfig: Print errors to stderr in the Makefile

Paul Bolle (1):
      kconfig: remove lkc_defs.h from .gitignore and dontdiff

Steven Rostedt (1):
      kconfig: Document oldnoconfig to what it really does

Yaakov Selkowitz (5):
      kconfig/nconf: fix compile with ncurses reentrant API
      kconfig: check ncursesw headers first in check-lxdialog
      kconfig: fix check-lxdialog for DLL platforms
      xconfig: use pkgconfig to find moc
      xconfig: add quiet rule for moc

Yann E. MORIN (1):
      scripts/config: fix double-quotes un-escaping

 Documentation/dontdiff                     |    1 -
 scripts/config                             |    2 +-
 scripts/kconfig/.gitignore                 |    1 -
 scripts/kconfig/Makefile                   |   41 ++++++++++---------
 scripts/kconfig/confdata.c                 |   61 +++++++++++++++++++++++++++-
 scripts/kconfig/lxdialog/check-lxdialog.sh |    8 ++--
 scripts/kconfig/lxdialog/textbox.c         |    3 +
 scripts/kconfig/mconf.c                    |    6 +-
 scripts/kconfig/nconf.c                    |   10 +++-
 scripts/kconfig/nconf.gui.c                |    8 ++-
 10 files changed, 104 insertions(+), 37 deletions(-)

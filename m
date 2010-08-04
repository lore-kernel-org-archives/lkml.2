Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932793Ab0HDM76 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 08:59:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40865 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932117Ab0HDM74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 08:59:56 -0400
Date: Wed, 4 Aug 2010 14:58:30 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ettl.martin@gmx.de, mmarek@suse.cz, npalix@diku.dk, rabin@rab.in,
        rdreier@cisco.com, segooon@gmail.com, xiyou.wangcong@gmail.com,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] kbuild: misc changes
Message-ID: <20100804125830.GA24407@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

these are the kbuild changes that did not fit anywhere else. The most
interesting part is integration of the coccinelle tool into the kernel
build, see Documentation/coccinelle.txt for the details. With this,
further semantic patches should appear below scripts/coccinelle and not
in the changelog messages.

Michal

The following changes since commit 9fe6206f400646a2322096b56c59891d530e8d51:

  Linux 2.6.35 (2010-08-01 15:11:14 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git misc

Américo Wang (1):
      scripts: add nconf into gitignore file

Kulikov Vasiliy (1):
      Documentation: fix ubuntu distro name

Martin Ettl (1):
      scripts/dtc: Fix a resource leak

Michal Marek (3):
      Makefile: clarify a comment
      Merge branch 'kbuild/coccinelle' into kbuild/misc
      MAINTAINERS: Update kbuild git URLs

Nicolas Palix (8):
      Add a target to use the Coccinelle checker
      Add Documentation/coccinelle.txt
      Add scripts/coccinelle/alloc/drop_kmalloc_cast.cocci
      Add scripts/coccinelle/alloc/kzalloc-simple.cocci
      Add scripts/coccinelle/resource_size.cocci
      Add scripts/coccinelle/err_cast.cocci
      Add scripts/coccinelle/deref_null.cocci
      Add support for the C variable in the coccicheck script

Rabin Vincent (1):
      scripts: decodecode: remove bashisms

Roland Dreier (1):
      checkkconfigsymbols.sh: Kconfig symbols sometimes have lowercase letters

 Documentation/coccinelle.txt                     |  258 +++++++++++++++++++
 MAINTAINERS                                      |   14 +-
 Makefile                                         |   12 +-
 scripts/Makefile.help                            |    3 +
 scripts/checkkconfigsymbols.sh                   |    2 +-
 scripts/coccicheck                               |   80 ++++++
 scripts/coccinelle/alloc/drop_kmalloc_cast.cocci |   67 +++++
 scripts/coccinelle/alloc/kzalloc-simple.cocci    |   82 ++++++
 scripts/coccinelle/deref_null.cocci              |  293 ++++++++++++++++++++++
 scripts/coccinelle/err_cast.cocci                |   56 ++++
 scripts/coccinelle/resource_size.cocci           |   93 +++++++
 scripts/decodecode                               |   10 +-
 scripts/dtc/fstree.c                             |    1 +
 scripts/kconfig/.gitignore                       |    1 +
 14 files changed, 960 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/coccinelle.txt
 create mode 100644 scripts/Makefile.help
 create mode 100755 scripts/coccicheck
 create mode 100644 scripts/coccinelle/alloc/drop_kmalloc_cast.cocci
 create mode 100644 scripts/coccinelle/alloc/kzalloc-simple.cocci
 create mode 100644 scripts/coccinelle/deref_null.cocci
 create mode 100644 scripts/coccinelle/err_cast.cocci
 create mode 100644 scripts/coccinelle/resource_size.cocci

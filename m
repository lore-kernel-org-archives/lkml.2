Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab1EXGik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 02:38:40 -0400
Received: from smtp.nokia.com ([147.243.1.48]:18769 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384Ab1EXGij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 02:38:39 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 24 May 2011 09:41:39 +0300
Message-Id: <20110524064139.4507.8224.sendpatchset@localhost.localdomain>
Subject: [GIT PULL] UBIFS changes for 2.6.40
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull UBIFS changes.

The following changes since commit 693d92a1bbc9e42681c42ed190bd42b636ca876f:

  Linux 2.6.39-rc7 (2011-05-09 19:33:54 -0700)

are available in the git repository at:
  git://git.infradead.org/ubifs-2.6.git linux-next

Artem Bityutskiy (48):
      UBIFS: make debugfs files non-seekable
      UBIFS: fix minor stylistic issues
      UBIFS: use __packed instead of __attribute__((packed))
      UBIFS: introduce a separate structure for budgeting info
      UBIFS: simplify dbg_dump_budg calling conventions
      UBIFS: rearrange the budget dump
      UBIFS: improve space checking debugging feature
      UBIFS: make force in-the-gaps to be a general self-check
      UBIFS: introduce lsave debugging
      UBIFS: use EROFS when emulating failures
      UBIFS: use ro_mount instead of MS_RDONLY
      UBIFS: fix oops in lprops dump function
      UBIFS: do not change debugfs file position
      UBIFS: remove strange commentary
      UBIFS: remove duplicated code
      UBIFS: remove dead GC LEB recovery piece of code
      UBIFS: print useful debugging messages when cannot recover gc_lnum
      UBIFS: dump the stack on errors in failure mode too
      UBIFS: split ubifs_rcvry_gc_commit
      UBIFS: refactor ubifs_rcvry_gc_commit
      UBIFS: fix debugging message
      UBIFS: remove an unneeded check
      UBIFS: fix debugging FS checking failure
      UBIFS: fix inode size debugging check failure
      UBIFS: fix a rare memory leak in ro to rw remounting path
      UBIFS: improve debugging lprops scanning a little
      UBIFS: simplify error path in lprops debugging check
      UBIFS: simplify lprops debugging check
      UBIFS: dump more in the lprops debugging check
      UBIFS: improve debugging messages
      UBIFS: improve commentary
      UBIFS: make 2 functions static
      UBIFS: double check that buds are replied in order
      UBIFS: remove unnecessary stack variable
      UBIFS: store free and dirty space in the bud replay entry
      UBIFS: simplify replay
      UBIFS: substitute the replay tree with a replay list
      UBIFS: change bud replay function conventions
      UBIFS: remove BUG statement
      UBIFS: synchronize write-buffer before switching to the next bud
      UBIFS: expect corruption only in last journal head LEBs
      UBIFS: share the next_log_lnum helper
      UBIFS: clean up LEB recovery function
      UBIFS: always cleanup the recovered LEB
      UBIFS: simplify LEB recovery function further
      UBIFS: fix extremely rare mount failure
      UBIFS: fix kernel-doc comments
      UBIFS: switch to dynamic printks

Matthew L. Creech (3):
      UBIFS: add a superblock flag for free space fix-up
      UBIFS: add the fixup function
      UBIFS: fix-up free space on mount if flag is set

Sedat Dilek (1):
      UBIFS: make xattr operations names consistent

 Documentation/filesystems/ubifs.txt |   26 +--
 fs/ubifs/budget.c                   |  104 ++++----
 fs/ubifs/commit.c                   |    2 +-
 fs/ubifs/debug.c                    |  167 ++++++++-----
 fs/ubifs/debug.h                    |  178 +++++---------
 fs/ubifs/dir.c                      |    4 +-
 fs/ubifs/file.c                     |   28 ++-
 fs/ubifs/find.c                     |   10 +-
 fs/ubifs/gc.c                       |   71 +++---
 fs/ubifs/io.c                       |   33 +--
 fs/ubifs/journal.c                  |   29 ++-
 fs/ubifs/log.c                      |   28 +--
 fs/ubifs/lprops.c                   |  115 ++++------
 fs/ubifs/lpt_commit.c               |   55 ++++-
 fs/ubifs/master.c                   |    8 +-
 fs/ubifs/misc.h                     |   17 ++
 fs/ubifs/orphan.c                   |    3 +-
 fs/ubifs/recovery.c                 |  354 +++++++++++++-------------
 fs/ubifs/replay.c                   |  468 +++++++++++++++++------------------
 fs/ubifs/sb.c                       |  153 +++++++++++-
 fs/ubifs/super.c                    |   46 +++--
 fs/ubifs/tnc.c                      |   10 +-
 fs/ubifs/tnc_commit.c               |   18 +-
 fs/ubifs/ubifs-media.h              |   30 ++-
 fs/ubifs/ubifs.h                    |   86 ++++---
 fs/ubifs/xattr.c                    |    8 +-
 26 files changed, 1117 insertions(+), 934 deletions(-)

Thanks,
Artem.

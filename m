Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab1CROVW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 10:21:22 -0400
Received: from smtp.nokia.com ([147.243.128.24]:20455 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756728Ab1CROVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 10:21:08 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 18 Mar 2011 16:18:57 +0200
Message-Id: <20110318141857.5529.40164.sendpatchset@localhost.localdomain>
Subject: [GIT PULL] UBIFS changes for 2.6.39
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull UBIFS changes. Note, I usually keep UBI and UBIFS
changes in separate trees, but this time I have a couple of UBI changes
in the UBIFS tree because they have hard dependency with UBIFS fixes.

The following changes since commit 3c0eee3fe6a3a1c745379547c7e7c904aa64f6d5:

  Linux 2.6.37 (2011-01-04 16:50:19 -0800)

are available in the git repository at:
  git://git.infradead.org/ubifs-2.6.git linux-next

Artem Bityutskiy (23):
      UBIFS: re-arrange variables in ubifs_info
      UBIFS: introduce mounting flag
      UBIFS: do not start the commit if there is nothing to commit
      UBIFS: remove double semicolon
      UBIFS: describe UBIFS recovery logic some more
      UBIFS: fix LEB number in printk
      UBI: incorporate maximum write size
      UBI: provide LEB offset information
      UBIFS: incorporate maximum write size
      UBI: incorporate LEB offset information
      UBIFS: introduce write-buffer size field
      UBIFS: use max_write_size for write-buffers
      UBIFS: use max_write_size during recovery
      UBIFS: print max. index node size
      UBIFS: simplify UBIFS Kconfig menu
      UBIFS: do not check data crc by default
      UBIFS: allocate dump buffer on demand
      UBIFS: allocate scanning buffer on demand
      UBIFS: allocate ltab checking buffer on demand
      UBIFS: allocate lpt dump buffer on demand
      UBIFS: allocate orphans scan buffer on demand
      UBIFS: save 128KiB or more RAM
      UBIFS: clean-up commentaries

Matthew L. Creech (1):
      UBIFS: handle allocation failures in UBIFS write path

Vasiliy Kulikov (1):
      UBIFS: restrict world-writable debugfs files

 Documentation/filesystems/ubifs.txt |    4 +-
 drivers/mtd/ubi/build.c             |   14 +++
 drivers/mtd/ubi/kapi.c              |    2 +
 drivers/mtd/ubi/ubi.h               |    3 +
 fs/ubifs/Kconfig                    |   23 ++---
 fs/ubifs/commit.c                   |   58 ++++++++++-
 fs/ubifs/debug.c                    |   34 +++---
 fs/ubifs/debug.h                    |   30 +-----
 fs/ubifs/io.c                       |  201 +++++++++++++++++++++++++++--------
 fs/ubifs/journal.c                  |   28 ++++-
 fs/ubifs/lprops.c                   |   26 ++++-
 fs/ubifs/lpt_commit.c               |   56 +++++++---
 fs/ubifs/orphan.c                   |   10 ++-
 fs/ubifs/recovery.c                 |   44 ++++++---
 fs/ubifs/scan.c                     |    2 +-
 fs/ubifs/super.c                    |   54 ++++++++--
 fs/ubifs/tnc.c                      |   10 ++-
 fs/ubifs/ubifs.h                    |   45 ++++++--
 include/linux/mtd/ubi.h             |   22 ++++
 19 files changed, 490 insertions(+), 176 deletions(-)

Thanks,
Artem.

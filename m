Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab1DGKcW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 06:32:22 -0400
Received: from smtp.nokia.com ([147.243.1.48]:63127 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753225Ab1DGKcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 06:32:21 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 07 Apr 2011 13:35:22 +0300
Message-Id: <20110407103522.14727.6712.sendpatchset@localhost.localdomain>
Subject: [GIT PULL] UBI/UBIFS changes for 2.6.39
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please, pull the UBI and UBIFS fixes for 2.6.39.

The following changes since commit 0ce790e7d736cedc563e1fb4e998babf5a4dbc3d:

  Linux 2.6.39-rc1 (2011-03-29 12:09:47 -0700)

are available in the git repository at:
  git://git.infradead.org/ubifs-2.6.git for-linus

Artem Bityutskiy (10):
      UBIFS: do not read flash unnecessarily
      UBIFS: fix oops on error path in read_pnode
      UBIFS: fix assertion warnings
      UBIFS: do not select KALLSYMS_ALL
      UBIFS: unify error path dbg_debugfs_init_fs
      UBIFS: fix error path in dbg_debugfs_init_fs
      UBIFS: fix debugging failure in dbg_check_space_info
      UBI: check if we are in RO mode in the erase routine
      UBI: do not compare array with NULL
      UBI: do not select KALLSYMS_ALL

 drivers/mtd/ubi/Kconfig |    2 +-
 drivers/mtd/ubi/io.c    |    8 +++++-
 drivers/mtd/ubi/vmt.c   |    5 ---
 fs/ubifs/Kconfig        |    2 +-
 fs/ubifs/commit.c       |    2 +-
 fs/ubifs/debug.c        |   63 ++++++++++++++++++++++++++++++++++------------
 fs/ubifs/lpt.c          |    7 ++---
 fs/ubifs/super.c        |    3 +-
 8 files changed, 61 insertions(+), 31 deletions(-)

Thanks,
Artem.

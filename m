Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab1EXGiq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 02:38:46 -0400
Received: from smtp.nokia.com ([147.243.1.47]:19061 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384Ab1EXGio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 02:38:44 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 24 May 2011 09:41:47 +0300
Message-Id: <20110524064147.4545.43792.sendpatchset@localhost.localdomain>
Subject: [GIT PULL] UBI changes for 2.6.40
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull UBI changes.

The following changes since commit a6360dd37e1a144ed11e6548371bade559a1e4df:

  Linux 2.6.39-rc3 (2011-04-11 17:21:51 -0700)

are available in the git repository at:
  git://git.infradead.org/ubi-2.6.git linux-next

Artem Bityutskiy (9):
      UBI: make the control character device non-seekable
      UBI: re-name set volume properties ioctl
      UBI: cleanup comments around volume properties
      UBI: use __packed instead of __attribute__((packed))
      UBI: fix minor stylistic issues
      UBI: fix typo in a message
      UBI: improve checking in debugging prints
      UBI: turn some macros into static inline
      UBI: switch to dynamic printks

 drivers/mtd/ubi/cdev.c      |   14 ++--
 drivers/mtd/ubi/debug.c     |   21 +++---
 drivers/mtd/ubi/debug.h     |  161 ++++++++++++++++++++++---------------------
 drivers/mtd/ubi/io.c        |    6 +-
 drivers/mtd/ubi/scan.c      |    2 +-
 drivers/mtd/ubi/ubi-media.h |    6 +-
 drivers/mtd/ubi/ubi.h       |    4 +-
 drivers/mtd/ubi/wl.c        |    3 +-
 include/linux/mtd/ubi.h     |    4 +-
 include/mtd/ubi-user.h      |   40 ++++++-----
 10 files changed, 132 insertions(+), 129 deletions(-)

Thanks,
Artem.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab1GVIzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 04:55:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:19784 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731Ab1GVIzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 04:55:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,246,1309762800"; 
   d="scan'208";a="30714516"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>, linux-kernel@vger.kernel.org
Date: Fri, 22 Jul 2011 11:57:11 +0300
Message-Id: <20110722085711.9723.11947.sendpatchset@localhost.localdomain>
Subject: [GIT PULL] UBI changes for 3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull UBI changes.

The following changes since commit 55922c9d1b84b89cb946c777fddccb3247e7df2c:

  Linux 3.0-rc1 (2011-05-29 17:43:36 -0700)

are available in the git repository at:
  git://git.infradead.org/ubi-2.6.git linux-next

Artem Bityutskiy (8):
      UBI: change the interface of a debugging check function
      UBI: use debugfs for the extra checks knobs
      UBI: prepare debugging stuff to further debugfs conversion
      UBI: make it possible to use struct ubi_device in debug.h
      UBI: switch debugging tests knobs to debugfs
      UBI: fix oops in error path
      UBI: dump stack when switching to R/O mode
      UBI: remove dead code

David Wagner (1):
      UBI: clarify the volume notification types' doc

 drivers/mtd/ubi/build.c |   28 +++++-
 drivers/mtd/ubi/debug.c |  269 +++++++++++++++++++++++++++++++++++++++++++++--
 drivers/mtd/ubi/debug.h |  113 ++++++++++++--------
 drivers/mtd/ubi/io.c    |   20 ++--
 drivers/mtd/ubi/scan.c  |    2 +-
 drivers/mtd/ubi/ubi.h   |    8 ++-
 drivers/mtd/ubi/vmt.c   |    2 +-
 drivers/mtd/ubi/vtbl.c  |   18 +---
 drivers/mtd/ubi/wl.c    |   42 ++++---
 include/linux/mtd/ubi.h |   14 ++-
 10 files changed, 406 insertions(+), 110 deletions(-)

Thanks,
Artem.

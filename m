Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab1CROVN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 10:21:13 -0400
Received: from smtp.nokia.com ([147.243.1.48]:48064 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756651Ab1CROVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 10:21:06 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 18 Mar 2011 16:18:46 +0200
Message-Id: <20110318141846.5524.21713.sendpatchset@localhost.localdomain>
Subject: [GIT PULL] UBI changes for 2.6.39
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull UBI changes.

The following changes since commit 3c0eee3fe6a3a1c745379547c7e7c904aa64f6d5:

  Linux 2.6.37 (2011-01-04 16:50:19 -0800)

are available in the git repository at:
  git://git.infradead.org/ubi-2.6.git linux-next

Artem Bityutskiy (13):
      UBI: add a commentary about allocating VID header buffer on stack
      UBI: try to reveal buggy MTD drivers
      UBI: use raw mtd read function in debugging code
      UBI: add slab cache for ubi_scan_leb objects
      UBI: cleanup comments about corrupted PEBs
      UBI: always re-read in case of read failures
      UBI: allocate write checking buffer on demand
      UBI: allocate erase checking buffer on demand
      UBI: kill debugging buffer
      UBI: remove UBI_IO_DEBUG macro
      UBI: make debugging messages dynamic
      UBI: make self-checks dynamic
      UBI: make tests modes dynamic

Holger Brunck (1):
      UBI: fix NOR erase preparation quirk

John Ogness (1):
      UBI: cleanup LEB start calculations

 drivers/mtd/ubi/Kconfig       |    8 ++-
 drivers/mtd/ubi/Kconfig.debug |   73 ---------------------
 drivers/mtd/ubi/build.c       |   20 +-----
 drivers/mtd/ubi/debug.c       |   14 ++++
 drivers/mtd/ubi/debug.h       |  131 ++++++++++++++++++++++---------------
 drivers/mtd/ubi/io.c          |  145 +++++++++++++++++++++++++++++------------
 drivers/mtd/ubi/scan.c        |   95 +++++++++++++++++----------
 drivers/mtd/ubi/scan.h        |    2 +
 drivers/mtd/ubi/ubi.h         |    7 +--
 drivers/mtd/ubi/vmt.c         |    7 ++-
 drivers/mtd/ubi/vtbl.c        |    9 ++-
 drivers/mtd/ubi/wl.c          |   20 ++++--
 12 files changed, 297 insertions(+), 234 deletions(-)
 delete mode 100644 drivers/mtd/ubi/Kconfig.debug

Thanks,
Artem.

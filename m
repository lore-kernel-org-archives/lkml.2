Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab0JVGsP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 02:48:15 -0400
Received: from smtp.nokia.com ([192.100.122.233]:31109 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952Ab0JVGsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 02:48:14 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 22 Oct 2010 09:48:06 +0300
Message-Id: <20101022064806.1700.208.sendpatchset@localhost.localdomain>
Subject: [GIT PULL] UBI changes for 2.6.37
X-OriginalArrivalTime: 22 Oct 2010 06:47:25.0082 (UTC) FILETIME=[FC47FFA0:01CB71B4]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull UBI tree.

The following changes since commit cd07202cc8262e1669edff0d97715f3dd9260917:

  Linux 2.6.36-rc8 (2010-10-14 16:26:43 -0700)

are available in the git repository at:
  git://git.infradead.org/ubi-2.6.git linux-next

Artem Bityutskiy (15):
      UBI: fix small 80 characters limit style issue
      UBI: rename IO error code
      UBI: remove duplicate IO error codes
      UBI: handle bit-flips when no header found
      UBI: rename a local variable
      UBI: change cascade of ifs to switch statements
      UBI: separate out corrupted list
      UBI: do not put eraseblocks to the corrupted list unnecessarily
      UBI: make check_pattern function non-static
      UBI: introduce debugging helper function
      UBI: add truly corrupted PEBs to corrupted list
      UBI: preserve corrupted PEBs
      UBI: remember copy_flag while scanning
      UBI: fix check_data_ff return code
      UBI: tighten the corrupted PEB criteria

H Hartley Sweeten (1):
      UBI: cleanup and simplify Kconfig

 drivers/mtd/ubi/Kconfig       |   17 +--
 drivers/mtd/ubi/Kconfig.debug |   29 +---
 drivers/mtd/ubi/build.c       |    6 +-
 drivers/mtd/ubi/debug.h       |    4 +
 drivers/mtd/ubi/eba.c         |   10 +-
 drivers/mtd/ubi/io.c          |  138 ++++++----------
 drivers/mtd/ubi/misc.c        |   19 ++
 drivers/mtd/ubi/scan.c        |  387 ++++++++++++++++++++++++++++-------------
 drivers/mtd/ubi/scan.h        |   19 +-
 drivers/mtd/ubi/ubi.h         |   29 ++-
 drivers/mtd/ubi/vmt.c         |    6 +
 drivers/mtd/ubi/vtbl.c        |   10 +-
 drivers/mtd/ubi/wl.c          |   31 ++--
 13 files changed, 419 insertions(+), 286 deletions(-)

Thanks,
Artem.

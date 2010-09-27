Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759742Ab0I0QFt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 12:05:49 -0400
Received: from mail.logicpd.com ([66.162.60.3]:29868 "EHLO smtp.logicpd.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759570Ab0I0QFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 12:05:48 -0400
From: Tim Nordell <tim.nordell@logicpd.com>
To: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Tim Nordell <tim.nordell@logicpd.com>
Subject: [PATCH v4 0/4] LogicPD minimal board support for LV_SOM and Torpedo
Date: Mon, 27 Sep 2010 11:05:46 -0500
Message-Id: <1285603550-6382-1-git-send-email-tim.nordell@logicpd.com>
X-Mailer: git-send-email 1.7.1
X-OriginalArrivalTime: 27 Sep 2010 16:05:47.0320 (UTC) FILETIME=[D8D81380:01CB5E5D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was tested (and based) against 2.6.36-rc5

Difference from patch v3 1/4:
 - Merged DEBUG_LL support patch (patch v3 5/5) into first patch
 - Added "select OMAP_PACKAGE_CBB" into Kconfig for both boards

Tim Nordell (4):
  Adding LogicPD OMAP3 board support
  ARM: OMAP3LOGIC: Adding SDMMC support
  ARM: OMAP3: Add generic smsc911x support when connected to GPMC
  ARM: OMAP3LOGIC: Added SMSC Ethernet board support

 arch/arm/mach-omap2/Kconfig                     |   20 ++
 arch/arm/mach-omap2/Makefile                    |    7 +
 arch/arm/mach-omap2/board-omap3logic.c          |  244 +++++++++++++++++++++++
 arch/arm/mach-omap2/gpmc-smsc911x.c             |  113 +++++++++++
 arch/arm/plat-omap/include/plat/gpmc-smsc911x.h |   35 ++++
 arch/arm/plat-omap/include/plat/uncompress.h    |    2 +
 6 files changed, 421 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-omap2/board-omap3logic.c
 create mode 100644 arch/arm/mach-omap2/gpmc-smsc911x.c
 create mode 100644 arch/arm/plat-omap/include/plat/gpmc-smsc911x.h


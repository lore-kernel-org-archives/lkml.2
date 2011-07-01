Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333Ab1GARgj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 13:36:39 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:53234 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753516Ab1GARgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 13:36:38 -0400
From: Kevin Hilman <khilman@ti.com>
To: linux-mmc@vger.kernel.org, Chris Ball <cjb@laptop.org>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Madhusudhan Chikkature <madhu.cr@ti.com>
Subject: [PATCH] MMC: OMAP: change HSMMC maintainence to Orphan
Date: Fri,  1 Jul 2011 10:36:42 -0700
Message-Id: <1309541802-5975-1-git-send-email-khilman@ti.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Madhusudhan Chikkature <madhu.cr@ti.com>

Update the OMAP HS MMC entry from the MAINTAINERS file as I will
no longer be able to maintain this driver.

Signed-off-by: Madhusudhan Chikkature <madhu.cr@ti.com>
[khilman@ti.com: change to Orphan rather than complete removal]
Signed-off-by: Kevin Hilman <khilman@ti.com>
---
Applies to v3.0-rc5

 MAINTAINERS |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f0358cd..2f238b5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4574,9 +4574,8 @@ S:	Maintained
 F:	drivers/mmc/host/omap.c
 
 OMAP HS MMC SUPPORT
-M:	Madhusudhan Chikkature <madhu.cr@ti.com>
 L:	linux-omap@vger.kernel.org
-S:	Maintained
+S:	Orphan
 F:	drivers/mmc/host/omap_hsmmc.c
 
 OMAP RANDOM NUMBER GENERATOR SUPPORT
-- 
1.7.6


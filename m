Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964865Ab2GLVvN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 17:51:13 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:34468 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964834Ab2GLVvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 17:51:07 -0400
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 5/8] staging: ft1000-usb: Remove name comments from ft1000_usb.h.
Date: Thu, 12 Jul 2012 23:50:47 +0200
Message-Id: <1342129850-32209-5-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342129850-32209-1-git-send-email-marek.belisko@open-nandra.com>
References: <1342129850-32209-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index 06bce31..2b98754 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -1,7 +1,6 @@
 #ifndef _FT1000_USB_H_
 #define _FT1000_USB_H_
 
-/*Jim*/
 #include "../ft1000.h"
 #include "ft1000_ioctl.h"
 #define FT1000_DRV_VER      0x01010403
@@ -27,7 +26,6 @@ struct app_info_block {
 	struct list_head app_sqlist;   // link list of msgs for applicaton on slow queue
 } __attribute__((packed));
 
-/*end of Jim*/
 #define DEBUG(args...) printk(KERN_INFO args)
 
 #define FALSE           0
@@ -121,8 +119,8 @@ struct ft1000_info {
 	u8 RfCalVer[CALVERSZ];
 	u8 RfCalDate[CALDATESZ];
 	u16 DSP_TIME[4];
-	u16 LedStat;	//mbelian
-	u16 ConStat;	//mbelian
+	u16 LedStat;
+	u16 ConStat;
 	u16 ProgConStat;
 	struct list_head prov_list;
 	int appcnt;
@@ -137,7 +135,7 @@ struct ft1000_info {
 	} DSPSess;
 	unsigned short tempbuf[32];
 	char netdevname[IFNAMSIZ];
-	struct proc_dir_entry *ft1000_proc_dir; //mbelian
+	struct proc_dir_entry *ft1000_proc_dir;
 };
 
 
-- 
1.7.9.5


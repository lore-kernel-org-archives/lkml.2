Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933197Ab0FEKgg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 06:36:36 -0400
Received: from outbound-mail03.westnet.com.au ([203.10.1.244]:3094 "EHLO
	outbound-mail03.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933157Ab0FEKg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 06:36:28 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlJPAPbECUw6B9wNPGdsb2JhbACHb5ZlDAEBAQE1LbAkjUSFFwSDSA
X-IronPort-AV: E=Sophos;i="4.53,366,1272816000"; 
   d="scan'208";a="77635030"
From: Mike Gilks <mike.kernel@gilksonline.com>
To: gregkh@suse.de, mchehab@redhat.com, julia@diku.dk, joe@perches.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mike Gilks <kernel.online@gilksonline.com>
Subject: [PATCH 06/12] fix most checkpatch.pl issues to line 400
Date: Sat,  5 Jun 2010 18:36:21 +0800
Message-Id: <1275734187-26583-7-git-send-email-mike.kernel@gilksonline.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1275734187-26583-6-git-send-email-mike.kernel@gilksonline.com>
References: <1275734187-26583-1-git-send-email-mike.kernel@gilksonline.com>
 <1275734187-26583-2-git-send-email-mike.kernel@gilksonline.com>
 <1275734187-26583-3-git-send-email-mike.kernel@gilksonline.com>
 <1275734187-26583-4-git-send-email-mike.kernel@gilksonline.com>
 <1275734187-26583-5-git-send-email-mike.kernel@gilksonline.com>
 <1275734187-26583-6-git-send-email-mike.kernel@gilksonline.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Gilks <kernel.online@gilksonline.com>

---
 drivers/staging/rtl8192u/r8192U_core.c |   21 ++++++---------------
 1 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index ac620a5..ae388f7 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -315,9 +315,8 @@ void write_nic_byte_E(struct net_device *dev, int indx, u8 data)
 			       RTL8187_REQ_SET_REGS, RTL8187_REQT_WRITE,
 			       indx|0xfe00, 0, &data, 1, HZ / 2);
 
-	if (status < 0) {
+	if (status < 0)
 		printk("write_nic_byte_E TimeOut! status:%d\n", status);
-	}
 }
 
 u8 read_nic_byte_E(struct net_device *dev, int indx)
@@ -331,9 +330,8 @@ u8 read_nic_byte_E(struct net_device *dev, int indx)
 			       RTL8187_REQ_GET_REGS, RTL8187_REQT_READ,
 			       indx|0xfe00, 0, &data, 1, HZ / 2);
 
-	if (status < 0) {
+	if (status < 0)
 		printk("read_nic_byte_E TimeOut! status:%d\n", status);
-	}
 
 	return data;
 }
@@ -351,10 +349,8 @@ void write_nic_byte(struct net_device *dev, int indx, u8 data)
 				       (indx&0xff)|0xff00, (indx>>8)&0x0f,
 							&data, 1, HZ / 2);
 
-	if (status < 0) {
+	if (status < 0)
 		printk("write_nic_byte TimeOut! status:%d\n", status);
-	}
-
 
 }
 
@@ -370,9 +366,8 @@ void write_nic_word(struct net_device *dev, int indx, u16 data)
 					(indx&0xff)|0xff00, (indx>>8)&0x0f,
 							&data, 2, HZ / 2);
 
-	if (status < 0) {
+	if (status < 0)
 		printk("write_nic_word TimeOut! status:%d\n", status);
-	}
 
 }
 
@@ -388,13 +383,10 @@ void write_nic_dword(struct net_device *dev, int indx, u32 data)
 					(indx&0xff)|0xff00, (indx>>8)&0x0f,
 							&data, 4, HZ / 2);
 
-	if (status < 0) {
+	if (status < 0)
 		printk("write_nic_dword TimeOut! status:%d\n", status);
-	}
 }
 
-
-
 u8 read_nic_byte(struct net_device *dev, int indx)
 {
 	u8 data;
@@ -407,9 +399,8 @@ u8 read_nic_byte(struct net_device *dev, int indx)
 					(indx&0xff)|0xff00, (indx>>8)&0x0f,
 							&data, 1, HZ / 2);
 
-	if (status < 0) {
+	if (status < 0)
 		printk("read_nic_byte TimeOut! status:%d\n", status);
-	}
 
 	return data;
 }
-- 
1.6.3.3


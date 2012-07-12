Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964876Ab2GLVvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 17:51:23 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:34468 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964834Ab2GLVvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 17:51:19 -0400
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 6/8] staging: ft1000-usb: Fix lines over 80 chars.
Date: Thu, 12 Jul 2012 23:50:48 +0200
Message-Id: <1342129850-32209-6-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342129850-32209-1-git-send-email-marek.belisko@open-nandra.com>
References: <1342129850-32209-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h |   33 ++++++++++++++++--------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index 2b98754..60071f0 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -144,28 +144,38 @@ struct dpram_blk {
 	u16 *pbuffer;
 } __attribute__ ((packed));
 
-int ft1000_read_register(struct ft1000_device *ft1000dev, u16* Data, u16 nRegIndx);
-int ft1000_write_register(struct ft1000_device *ft1000dev, u16 value, u16 nRegIndx);
-int ft1000_read_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer, u16 cnt);
-int ft1000_write_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer, u16 cnt);
-int ft1000_read_dpram16(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer, u8 highlow);
-int ft1000_write_dpram16(struct ft1000_device *ft1000dev, u16 indx, u16 value, u8 highlow);
-int fix_ft1000_read_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer);
-int fix_ft1000_write_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer);
+int ft1000_read_register(struct ft1000_device *ft1000dev,
+			u16* Data, u16 nRegIndx);
+int ft1000_write_register(struct ft1000_device *ft1000dev,
+			u16 value, u16 nRegIndx);
+int ft1000_read_dpram32(struct ft1000_device *ft1000dev,
+			u16 indx, u8 *buffer, u16 cnt);
+int ft1000_write_dpram32(struct ft1000_device *ft1000dev,
+			u16 indx, u8 *buffer, u16 cnt);
+int ft1000_read_dpram16(struct ft1000_device *ft1000dev,
+			u16 indx, u8 *buffer, u8 highlow);
+int ft1000_write_dpram16(struct ft1000_device *ft1000dev,
+			u16 indx, u16 value, u8 highlow);
+int fix_ft1000_read_dpram32(struct ft1000_device *ft1000dev,
+			u16 indx, u8 *buffer);
+int fix_ft1000_write_dpram32(struct ft1000_device *ft1000dev,
+			u16 indx, u8 *buffer);
 
 extern void *pFileStart;
 extern size_t FileLength;
 extern int numofmsgbuf;
 
 int ft1000_close (struct net_device *dev);
-u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, u32  FileLength);
+u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart,
+		u32  FileLength);
 
 extern struct list_head freercvpool;
 extern spinlock_t free_buff_lock;   // lock to arbitrate free buffer list for receive command data
 
 int ft1000_create_dev(struct ft1000_device *dev);
 void ft1000_destroy_dev(struct net_device *dev);
-extern void card_send_command(struct ft1000_device *ft1000dev, void *ptempbuffer, int size);
+extern void card_send_command(struct ft1000_device *ft1000dev,
+				void *ptempbuffer, int size);
 
 struct dpram_blk *ft1000_get_buffer(struct list_head *bufflist);
 void ft1000_free_buffer(struct dpram_blk *pdpram_blk, struct list_head *plist);
@@ -173,7 +183,8 @@ void ft1000_free_buffer(struct dpram_blk *pdpram_blk, struct list_head *plist);
 int dsp_reload(struct ft1000_device *ft1000dev);
 int init_ft1000_netdev(struct ft1000_device *ft1000dev);
 struct usb_interface;
-int reg_ft1000_netdev(struct ft1000_device *ft1000dev, struct usb_interface *intf);
+int reg_ft1000_netdev(struct ft1000_device *ft1000dev,
+			struct usb_interface *intf);
 int ft1000_poll(void* dev_id);
 
 int ft1000_init_proc(struct net_device *dev);
-- 
1.7.9.5


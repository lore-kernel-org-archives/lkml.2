Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab1CJKzL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 05:55:11 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34245 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469Ab1CJKv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 05:51:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=CK9d1aT7rvoRwLO9lh9dO5M8vQDGuBo2Rrm8hpaWq93btC0XJzzLQucZKThUgwNJmU
         mIBKNqZbcNn85SowRgEZKGvb7ETzG2v65zDg39LIEtOoFXoL0+nQv7fP/ZAuB/QI8AaM
         yPuOBzhjpnsKLSXPEXrrRBEGf0pecUPLUW6wk=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH v2 08/21] staging: ft1000: Change return value for init_ft1000_netdev function.
Date: Thu, 10 Mar 2011 11:51:22 +0100
Message-Id: <1299754295-8493-9-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299754295-8493-1-git-send-email-marek.belisko@open-nandra.com>
References: <1299754295-8493-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c  |    2 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index adf16c6..55998ec 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -710,7 +710,7 @@ static const struct net_device_ops ftnet_ops =
 // Notes:
 //
 //---------------------------------------------------------------------------
-u16 init_ft1000_netdev(struct ft1000_device *ft1000dev)
+int init_ft1000_netdev(struct ft1000_device *ft1000dev)
 {
 	struct net_device *netdev;
 	struct ft1000_info *pInfo = NULL;
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index 84ff53d..e047c03 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -589,7 +589,7 @@ void ft1000_free_buffer(struct dpram_blk *pdpram_blk, struct list_head *plist);
 char *getfw (char *fn, size_t *pimgsz);
 
 int dsp_reload(struct ft1000_device *ft1000dev);
-u16 init_ft1000_netdev(struct ft1000_device *ft1000dev);
+int init_ft1000_netdev(struct ft1000_device *ft1000dev);
 struct usb_interface;
 int reg_ft1000_netdev(struct ft1000_device *ft1000dev, struct usb_interface *intf);
 int ft1000_poll(void* dev_id);
-- 
1.7.1


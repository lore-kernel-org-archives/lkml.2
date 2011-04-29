Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab1D2Fla (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 01:41:30 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51237 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab1D2Fl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 01:41:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=cFcY4kmLH3XabJ5rSib+YOA16a8ulsEmUdncKd3N8Rc6wu3p1ktkI1zAztdUDxrAjT
         fkM59Ft/R+nPgacRBYmASMBti4rYutrQjFXPPsyfVjhW563xqJl91SeErioyjfZPXL9X
         JrymRL+duoZi3bJvqF5LTSp78tRFn6myGUhJM=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 3/6] staging: ft1000: Remove unused variable ASICResetNum.
Date: Fri, 29 Apr 2011 07:41:07 +0200
Message-Id: <1304055670-3573-3-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304055670-3573-1-git-send-email-marek.belisko@open-nandra.com>
References: <1304055670-3573-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed because was only assigned and not used on other places.

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c  |    3 ---
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h |    1 -
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 97a2926..5d85382 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -593,8 +593,6 @@ static void ft1000_reset_asic(struct net_device *dev)
 
 	DEBUG("ft1000_hw:ft1000_reset_asic called\n");
 
-	info->ASICResetNum++;
-
 	/* Let's use the register provided by the Magnemite ASIC to reset the
 	 * ASIC and DSP.
 	 */
@@ -748,7 +746,6 @@ int init_ft1000_netdev(struct ft1000_device *ft1000dev)
 	spin_lock_init(&pInfo->dpram_lock);
 	pInfo->pFt1000Dev = ft1000dev;
 	pInfo->DrvErrNum = 0;
-	pInfo->ASICResetNum = 0;
 	pInfo->registered = 1;
 	pInfo->ft1000_reset = ft1000_reset;
 	pInfo->mediastate = 0;
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index 4111e5c..55ba1ad 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -496,7 +496,6 @@ struct ft1000_info {
     bool fAppMsgPend;
     u16 DrvErrNum;
     u16 AsicID;
-    int ASICResetNum;
     int DspAsicReset;
     int DSPResetNum;
     int DeviceCreated;
-- 
1.7.1


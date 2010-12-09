Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360Ab0LIKZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 05:25:51 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:36647 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756159Ab0LIKYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 05:24:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=jfITHf4Rxe8fBoT2r4v90R7+AnIURpueQA4I9Xg9aJq0QCSpjpdmtGRwSFLF8heF+3
         wTtO1zM5fmnYE9aLcJpeziH9qXyBo23aNXB9zJt1Ra+FV9GbZNp7M3n9ui3PYSzAwAAK
         lbvncpZPh6pitKRzsYBTEe0/9hwymkTjF4Rgo=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 4/8] staging: ft1000: Remove unused variable.
Date: Thu,  9 Dec 2010 11:26:49 +0100
Message-Id: <1291890413-15255-5-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291890413-15255-1-git-send-email-marek.belisko@open-nandra.com>
References: <1291890413-15255-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c |    1 -
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c    |    1 -
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h   |    1 -
 3 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
index 0871e43..4e5c8a3 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
@@ -170,7 +170,6 @@ int ft1000_CreateDevice(struct ft1000_device *dev)
 
     // register the device
     DEBUG("ft1000_CreateDevice: \"%s\" device registration\n", info->DeviceName);
-    info->DeviceMajor = 0;
 
 	tmp = kmalloc(sizeof(struct ft1000_debug_dirs), GFP_KERNEL);
 	if (tmp == NULL) {
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 22536da..69f920f 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -835,7 +835,6 @@ u16 init_ft1000_netdev(struct ft1000_device *ft1000dev)
     pInfo->mediastate = 0;
     pInfo->fifo_cnt = 0;
     pInfo->DeviceCreated = FALSE;
-    pInfo->DeviceMajor = 0;
     pInfo->CurrentInterruptEnableMask = ISR_DEFAULT_MASK;
     pInfo->InterruptsEnabled = FALSE;
     pInfo->CardReady = 0;
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index 5bead63..2c89d14 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -514,7 +514,6 @@ struct ft1000_info {
     int NetDevRegDone;
     u8 CardNumber;
     u8 DeviceName[15];
-    int DeviceMajor;
     struct ft1000_debug_dirs nodes;
     int registered;
     int mediastate;
-- 
1.7.1


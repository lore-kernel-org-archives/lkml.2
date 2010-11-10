Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab0KJKNZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 05:13:25 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35998 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755003Ab0KJKNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 05:13:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=XOvqMBUueXxY689kmuMD9owOnDFaUvZcfFnzty0DxxmELLf60gRLlsy5Jv0wvJM1hz
         LlTQ8ZeUIEB2wFiS2x9nMgTjZfQV3QayYkZwdjAdsUhqKVV3sGLuICudR2npbouUEU/J
         lQZONzEtExyFSM3fLlWiT73Vh/0BZ40xBvGik=
From: Marek Belisko <marek.belisko@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH 3/3] staging: ft1000: Remove unused variables.
Date: Wed, 10 Nov 2010 11:15:28 +0100
Message-Id: <1289384128-19823-3-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1289384128-19823-1-git-send-email-marek.belisko@gmail.com>
References: <1289384128-19823-1-git-send-email-marek.belisko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This variables was used mainly for char device and char device
was removed so remove also unused variables.

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c  |    1 -
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h |    2 --
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 62db2a3..62d4068 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -834,7 +834,6 @@ u16 init_ft1000_netdev(struct ft1000_device *ft1000dev)
     pInfo->ft1000_reset = ft1000_reset;
     pInfo->mediastate = 0;
     pInfo->fifo_cnt = 0;
-    pInfo->DeviceCreated = FALSE;
     pInfo->DeviceMajor = 0;
     pInfo->CurrentInterruptEnableMask = ISR_DEFAULT_MASK;
     pInfo->InterruptsEnabled = FALSE;
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index 4375994..804f20e 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -502,7 +502,6 @@ struct ft1000_info {
     int DSPResetNum;
     int NumIOCTLBufs;
     int IOCTLBufLvl;
-    int DeviceCreated;
     int CardReady;
     int NetDevRegDone;
     u8 CardNumber;
@@ -532,7 +531,6 @@ struct ft1000_info {
     u16 ConStat;	//mbelian
     u16 ProgConStat;
     struct list_head prov_list;
-    int appcnt;
 	struct app_info_block app_info[MAX_NUM_APP];
     u16 DSPInfoBlklen;
     u16 DrvMsgPend;
-- 
1.7.1


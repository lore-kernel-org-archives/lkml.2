Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab1D2Fl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 01:41:28 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42429 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609Ab1D2Fl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 01:41:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=YUgci2LGmJQbDQXKCRONn3G18Iki/lzVK8NXTQf/aZceWbI3g3hQ9Rnm9Pe7mBG7VJ
         tS1mQqbBMy/HxCeM+Q6DKSFsK/Ul8VwMQ0TDYhALPnwOMAGiSJNOg2s0MUDlHpgGhjhv
         rOk4gV+QSZJH8W2TpcU2ovaxKw5OC/KRd4NoU=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 2/6] staging: ft1000: Remove unused variables in ft1000_info.
Date: Fri, 29 Apr 2011 07:41:06 +0200
Message-Id: <1304055670-3573-2-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304055670-3573-1-git-send-email-marek.belisko@open-nandra.com>
References: <1304055670-3573-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index bade59d..4111e5c 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -494,21 +494,11 @@ struct ft1000_info {
     bool fProvComplete;
     bool fCondResetPend;
     bool fAppMsgPend;
-    char *pfwimg;
-    int fwimgsz;
     u16 DrvErrNum;
-    u8  *pTestImage;
     u16 AsicID;
-    unsigned long TestImageIndx;
-    unsigned long TestImageSz;
-    u8  TestImageEnable;
-    u8  TestImageReady;
     int ASICResetNum;
     int DspAsicReset;
-    int PktIntfErr;
     int DSPResetNum;
-    int NumIOCTLBufs;
-    int IOCTLBufLvl;
     int DeviceCreated;
     int CardReady;
     int NetDevRegDone;
@@ -517,8 +507,6 @@ struct ft1000_info {
     struct ft1000_debug_dirs nodes;
     int registered;
     int mediastate;
-    int dhcpflg;
-    u16 packetseqnum;
     u8 squeseqnum;                 // sequence number on slow queue
     spinlock_t dpram_lock;
     spinlock_t fifo_lock;
@@ -534,7 +522,6 @@ struct ft1000_info {
     u8 RfCalVer[CALVERSZ];
     u8 RfCalDate[CALDATESZ];
     u16 DSP_TIME[4];
-    u16 ProgSnr;
     u16 LedStat;	//mbelian
     u16 ConStat;	//mbelian
     u16 ProgConStat;
-- 
1.7.1


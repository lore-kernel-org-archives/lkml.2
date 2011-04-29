Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab1D2Fle (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 01:41:34 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42429 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972Ab1D2Flb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 01:41:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=leaabppkdvM+E0occacujGzdpfGw5k8pgWPsjiI2vDbp+C+b1YjrIkbinz5oi3G2er
         uL7l6KXI4cq7xGebNkDGTje856N73eoH8553E0fgUVMbgGPBCRr/ibU2gF1X3aYh8NgY
         y1kiGSzuvGRylJGhe2O9HepmocwlAP6FmXzMw=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 6/6] staging: ft1000: Removed unused variable InterruptsEnabled.
Date: Fri, 29 Apr 2011 07:41:10 +0200
Message-Id: <1304055670-3573-6-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304055670-3573-1-git-send-email-marek.belisko@open-nandra.com>
References: <1304055670-3573-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed beacuse was only assigned and never used.

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c  |    1 -
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 1e5c750..b0a4211 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -749,7 +749,6 @@ int init_ft1000_netdev(struct ft1000_device *ft1000dev)
 	pInfo->mediastate = 0;
 	pInfo->fifo_cnt = 0;
 	pInfo->DeviceCreated = FALSE;
-	pInfo->InterruptsEnabled = FALSE;
 	pInfo->CardReady = 0;
 	pInfo->DSP_TIME[0] = 0;
 	pInfo->DSP_TIME[1] = 0;
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index 69576cd..0b30020 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -508,7 +508,6 @@ struct ft1000_info {
     u8 squeseqnum;                 // sequence number on slow queue
     spinlock_t dpram_lock;
     spinlock_t fifo_lock;
-    int InterruptsEnabled;
     u16 fifo_cnt;
     u8 DspVer[DSPVERSZ];        // DSP version number
     u8 HwSerNum[HWSERNUMSZ];    // Hardware Serial Number
-- 
1.7.1


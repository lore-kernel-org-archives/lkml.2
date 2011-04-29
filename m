Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707Ab1D2FmP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 01:42:15 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59821 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215Ab1D2Fl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 01:41:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=SsRBC8lmNSddXao5q0KmYzYQy8fytk3Gbvqi9DY+xTu3/i5ICQvIP5Q64La6seJkkM
         tWivFpOYB41ObB1sfyWufQ1D4j45eI0h3y/tPvydVInBwtnUcw//zW/ZxNrLJx8l9kHi
         iyuTGNG5EEXeFtczsURskUjSoHE63ACcs1wck=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 4/6] staging: ft1000: Remove unused variable DSPResetNum.
Date: Fri, 29 Apr 2011 07:41:08 +0200
Message-Id: <1304055670-3573-4-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304055670-3573-1-git-send-email-marek.belisko@open-nandra.com>
References: <1304055670-3573-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed because was only assigned and never used.

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c  |    2 --
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h |    1 -
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 5d85382..b4b4f1d 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -650,8 +650,6 @@ static int ft1000_reset_card(struct net_device *dev)
 	DEBUG("ft1000_hw:ft1000_reset_card: reset asic\n");
 	ft1000_reset_asic(dev);
 
-	info->DSPResetNum++;
-
 	DEBUG("ft1000_hw:ft1000_reset_card: call dsp_reload\n");
 	dsp_reload(ft1000dev);
 
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index 55ba1ad..ee47d4c 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -497,7 +497,6 @@ struct ft1000_info {
     u16 DrvErrNum;
     u16 AsicID;
     int DspAsicReset;
-    int DSPResetNum;
     int DeviceCreated;
     int CardReady;
     int NetDevRegDone;
-- 
1.7.1


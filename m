Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab1AYLa4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 06:30:56 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39955 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab1AYLay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 06:30:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=AOEVGXmPNtP0hz5rEK0IwhQTrkObKcmWzy1CgEsw9BUX3Lp9KuJklhvdv894jGwdXn
         LvWLBvmP4b3L7PjWvhdmFR1+33V7jt54Qr/9BefInnV2NILNlnldeUG2/7WZWWihqoS2
         PRU2Z9c9gcH1vIIVqiD1O3VgGy18er3rba/4s=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH resend 04/12] staging: ft1000: Fix coding style in put_handshake() function.
Date: Tue, 25 Jan 2011 12:31:15 +0100
Message-Id: <1295955083-11086-4-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1295955083-11086-1-git-send-email-marek.belisko@open-nandra.com>
References: <1295955083-11086-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |   29 ++++++++++---------
 1 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index 30501f5..21b42f9 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -255,20 +255,21 @@ static u16 get_handshake(struct ft1000_device *ft1000dev, u16 expected_value)
 //---------------------------------------------------------------------------
 static void put_handshake(struct ft1000_device *ft1000dev,u16 handshake_value)
 {
-    u32 tempx;
-    u16 tempword;
-    u32 status;
-
-
-
-        tempx = (u32)handshake_value;
-        tempx = ntohl(tempx);
-
-        tempword = (u16)(tempx & 0xffff);
-        status = ft1000_write_dpram16 (ft1000dev, DWNLD_MAG1_HANDSHAKE_LOC, tempword, 0);
-        tempword = (u16)(tempx >> 16);
-        status = ft1000_write_dpram16 (ft1000dev, DWNLD_MAG1_HANDSHAKE_LOC, tempword, 1);
-        status = ft1000_write_register(ft1000dev, FT1000_DB_DNLD_TX, FT1000_REG_DOORBELL);
+	u32 tempx;
+	u16 tempword;
+	u32 status;
+
+	tempx = (u32)handshake_value;
+	tempx = ntohl(tempx);
+
+	tempword = (u16)(tempx & 0xffff);
+	status = ft1000_write_dpram16(ft1000dev, DWNLD_MAG1_HANDSHAKE_LOC,
+					tempword, 0);
+	tempword = (u16)(tempx >> 16);
+	status = ft1000_write_dpram16(ft1000dev, DWNLD_MAG1_HANDSHAKE_LOC,
+					tempword, 1);
+	status = ft1000_write_register(ft1000dev, FT1000_DB_DNLD_TX,
+					FT1000_REG_DOORBELL);
 }
 
 static u16 get_handshake_usb(struct ft1000_device *ft1000dev, u16 expected_value)
-- 
1.7.1


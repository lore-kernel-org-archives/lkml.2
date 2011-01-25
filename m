Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab1AYNEu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 08:04:50 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64668 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab1AYNEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 08:04:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=GRahob85hDwjTO4x5V4T+uXW0AbosqxPt+0nLEiUeoJRHcg02pMU7merJpLNtUu2SC
         ciPLIgxpYO6tCK07lrXiKJA0XoRnYTpDvgKkIVmdI2Otp2Vqq6Gqg22+k+dOwm7D8Jnn
         tdCFx09y9xevR/bOK3EkSNxp0plyRD772xTCs=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH v2 09/11] staging: ft1000: Fix coding style in put_request_value() function.
Date: Tue, 25 Jan 2011 14:05:04 +0100
Message-Id: <1295960706-15667-10-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1295960706-15667-1-git-send-email-marek.belisko@open-nandra.com>
References: <1295960706-15667-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index b34429c..9167210 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -444,16 +444,12 @@ static long get_request_value(struct ft1000_device *ft1000dev)
 //---------------------------------------------------------------------------
 static void put_request_value(struct ft1000_device *ft1000dev, long lvalue)
 {
-   u32    tempx;
-   u32    status;
-
-       tempx = ntohl(lvalue);
-       status = fix_ft1000_write_dpram32(ft1000dev, DWNLD_MAG1_SIZE_LOC, (u8 *)&tempx);
-
-
-
-   //DEBUG("put_request_value: value is %x\n", lvalue);
+	u32    tempx;
+	u32    status;
 
+	tempx = ntohl(lvalue);
+	status = fix_ft1000_write_dpram32(ft1000dev, DWNLD_MAG1_SIZE_LOC,
+					  (u8 *)&tempx);
 }
 
 
-- 
1.7.1


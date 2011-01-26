Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab1AZJbk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 04:31:40 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40701 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab1AZJbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 04:31:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=XTac0B3/ge20D95OCVCGT8x/RCOT28XT56UorsBjHezuqEJE3Bwbwxv38ZMR92V9/i
         ty7K9NmmjZX2sgF1nZ/ByQ5iDoIG6o7AK/Yxu7CHODFpyn5VgBsDtRiPw8KoIrESp95G
         tKJBg1v/zzO2+9J6fRynSwpZurvnLaOfLmzKY=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH] staging: ft1000: Compilation error fix.
Date: Wed, 26 Jan 2011 10:32:09 +0100
Message-Id: <1296034329-20797-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This compilation error was introduced by coding style fixes
series patch. Fix for problem (forgot to compile).

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index 05f3e22..7a930f5 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -265,7 +265,7 @@ static void put_handshake(struct ft1000_device *ft1000dev,u16 handshake_value)
 
 static u16 get_handshake_usb(struct ft1000_device *ft1000dev, u16 expected_value)
 {
-	u16 handshake
+	u16 handshake;
 	int loopcnt;
 	u16 temp;
 	u32 status = 0;
-- 
1.7.1


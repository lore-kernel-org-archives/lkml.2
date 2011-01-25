Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab1AYNFS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 08:05:18 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36351 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302Ab1AYNEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 08:04:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=DAv6K2Q6g6hf43LwzMgjWUt/VuGPC6Ue76KzfAgbGETiQPknIYlt1PiR1Jat2depto
         +wM/8lQYRbEeoP3Gq0Yd3z/zp1m5HY/V7eqTmGHBlGl1EOwIUQ7waWQVii8eZQESGvS9
         0c3If/eB/Hgai2r2Wovn+6QjwoUGeRXbda1hk=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH v2 10/11] staging: ft1000: Fix coding style in hdr_checksum() function.
Date: Tue, 25 Jan 2011 14:05:05 +0100
Message-Id: <1295960706-15667-11-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1295960706-15667-1-git-send-email-marek.belisko@open-nandra.com>
References: <1295960706-15667-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index 9167210..7ebb683 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -468,14 +468,14 @@ static void put_request_value(struct ft1000_device *ft1000dev, long lvalue)
 //---------------------------------------------------------------------------
 static u16 hdr_checksum(struct pseudo_hdr *pHdr)
 {
-   u16   *usPtr = (u16 *)pHdr;
-   u16   chksum;
+	u16   *usPtr = (u16 *)pHdr;
+	u16   chksum;
 
 
-  chksum = ((((((usPtr[0] ^ usPtr[1]) ^ usPtr[2]) ^ usPtr[3]) ^
-                    usPtr[4]) ^ usPtr[5]) ^ usPtr[6]);
+	chksum = ((((((usPtr[0] ^ usPtr[1]) ^ usPtr[2]) ^ usPtr[3]) ^
+	usPtr[4]) ^ usPtr[5]) ^ usPtr[6]);
 
-  return chksum;
+	return chksum;
 }
 
 
-- 
1.7.1


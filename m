Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486Ab1AYRI3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 12:08:29 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:63576 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab1AYRI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 12:08:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=H/HlO/Gk6x4BZ5HifUR3FV9p5syf1WTCbmrlRK5hUhIhG+MDlpT+43hiAeVXpKhwQ7
         CSt/C2aUvdRjvmL9EtEWulVn4kmuLO/VnlxmnlFL6BV6HewM0tQ99BS/b8Zav2OS0RYI
         k1y1h+Jkip8IbTRL/LULk+yXaA8kW/3GRCZTY=
MIME-Version: 1.0
Date: Tue, 25 Jan 2011 22:38:27 +0530
Message-ID: <AANLkTimiwirjc2Ow_J6TgmVFXRC=i7-gb4cY-hYMCSgx@mail.gmail.com>
Subject: [PATCH 2.6.37 1/4] edac: correct commented info, i82975x
From: Arvind R <arvino55@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 2.6.37 1/4] edac: correct commented info

wrong comments in i82975x driver corrected

Signed-off-by: Arvind R. <arvino55@gmail.com>
---
 i82975x_edac.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)
---
diff -up a/drivers/edac/i82975x_edac.c b/drivers/edac/i82975x_edac.c
--- a/drivers/edac/i82975x_edac.c
+++ b/drivers/edac/i82975x_edac.c
@@ -160,8 +160,8 @@ NOTE: Only ONE of the three must be enab
 					 * 3:2  Rank 1 architecture
 					 * 1:0  Rank 0 architecture
 					 *
-					 * 00 => x16 devices; i.e 4 banks
-					 * 01 => x8  devices; i.e 8 banks
+					 * 00 => 4 banks
+					 * 01 => 8 banks
 					 */
 #define I82975X_C0BNKARC	0x10e
 #define I82975X_C1BNKARC	0x18e
@@ -344,11 +344,7 @@ static int dual_channel_active(void __io
 static enum dev_type i82975x_dram_type(void __iomem *mch_window, int rank)
 {
 	/*
-	 * ASUS P5W DH either does not program this register or programs
-	 * it wrong!
-	 * ECC is possible on i92975x ONLY with DEV_X8 which should mean 'val'
-	 * for each rank should be 01b - the LSB of the word should be 0x55;
-	 * but it reads 0!
+	 * ECC is possible on i92975x ONLY with DEV_X8
 	 */
 	return DEV_X8;
 }

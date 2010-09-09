Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933213Ab0IIWom (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:44:42 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42850 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933186Ab0IIWoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:44:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=b9tgSdEortYqflEHA572lNP0V783KzOy5kAF9fIaoZTMBieK+kkKIZMOmFn2YLfZfW
         wBegIyanXm0OtajrcCbz0y5Ef0yBYHZ47nbSdRxtkJjo5cp7BMWWJOeI9Bbp9A+MflYx
         FkGCGQ16IiIXMRW8FHJVYSF5ms43LicWuukhU=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 195/223]drivers/staging/go7007/go7007.txt Update broken web addresses.
Date: Thu,  9 Sep 2010 15:44:13 -0700
Message-Id: <1284072253-8390-15-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284072253-8390-1-git-send-email-justinmattock@gmail.com>
References: <1284072253-8390-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/go7007/go7007.txt |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/go7007/go7007.txt b/drivers/staging/go7007/go7007.txt
index 06a76da..c053a1d 100644
--- a/drivers/staging/go7007/go7007.txt
+++ b/drivers/staging/go7007/go7007.txt
@@ -414,11 +414,11 @@ in the TDA8290/TDA8275 tuner driver.
 
 The following patches must be downloaded from Gerd Knorr's website and
 applied in the order listed:
-
-	http://dl.bytesex.org/patches/2.6.11-2/i2c-tuner
-	http://dl.bytesex.org/patches/2.6.11-2/i2c-tuner2
-	http://dl.bytesex.org/patches/2.6.11-2/v4l2-api-mpeg
-	http://dl.bytesex.org/patches/2.6.11-2/saa7134-update
+	
+	http://dl.bytesex.org/patches/`uname -r`/i2c-tuner
+	*i2c-tuner2
+	*v4l2-api-mpeg
+	*saa7134-update
 
 The following patches are included with this SDK and can be applied in any
 order:
-- 
1.7.2.1


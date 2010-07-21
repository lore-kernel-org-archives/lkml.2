Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762652Ab0GUGla (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 02:41:30 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52975 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762569Ab0GUGlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 02:41:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=EVXht7Xi40m0bbT5KTbzuCq8ssPNvLrK4iKco0VZm64GGnaO+nqEFZtgGqqj6d4CEB
         y59fHMAoBap9BDlHWujMnUK0mFTdCiQbWl9RaW1TqQR2WhlKlcX5e0PEuM2y30VqZpfT
         qqt3qmudrCrz9Ho7dOhfw5giX30XlzK8RH8wU=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Mike Frysinger <vapier.adi@gmail.com>
Subject: [PATCH 36/36 v2]Documentation/hwmon/lm85 update web addresses.
Date: Tue, 20 Jul 2010 23:41:37 -0700
Message-Id: <1279694497-32565-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates some broken web addresses.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>

---
 Documentation/hwmon/lm85 |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/hwmon/lm85 b/Documentation/hwmon/lm85
index a76aefe..b98e0e0 100644
--- a/Documentation/hwmon/lm85
+++ b/Documentation/hwmon/lm85
@@ -9,15 +9,15 @@ Supported chips:
   * Analog Devices ADM1027
     Prefix: 'adm1027'
     Addresses scanned: I2C 0x2c, 0x2d, 0x2e
-    Datasheet: http://www.analog.com/en/prod/0,,766_825_ADM1027,00.html
+    Datasheet: http://www.onsemi.com/PowerSolutions/product.do?id=ADM1027
   * Analog Devices ADT7463
     Prefix: 'adt7463'
     Addresses scanned: I2C 0x2c, 0x2d, 0x2e
-    Datasheet: http://www.analog.com/en/prod/0,,766_825_ADT7463,00.html
+    Datasheet: http://www.onsemi.com/PowerSolutions/product.do?id=ADT7463
   * SMSC EMC6D100, SMSC EMC6D101
     Prefix: 'emc6d100'
     Addresses scanned: I2C 0x2c, 0x2d, 0x2e
-    Datasheet: http://www.smsc.com/main/tools/discontinued/6d100.pdf
+    Datasheet: http://www.smsc.com/media/Downloads_Public/discontinued/6d100.pdf 
   * SMSC EMC6D102
     Prefix: 'emc6d102'
     Addresses scanned: I2C 0x2c, 0x2d, 0x2e
-- 
1.7.1.rc1.21.gf3bd6


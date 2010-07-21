Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762489Ab0GUFSP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:18:15 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:34369 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755648Ab0GUExH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:53:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=XoNMG+t7hWg7EGx5Jjn6c4UfO8sMECXozvhzd+yx+v04bF++uIseF/S79Q5VyFwf45
         o814Ic9Bshdaq/QscSdCvfzeT2Pae++1l9QSt9sf9iyTiatFg3/htIFoecDFdq1Mluf2
         HpIU57SO7DXj86Bfx2qmGPYBq12fYVsj7MmWc=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 36/36]Documentation/hwmon/lm85 update web address.
Date: Tue, 20 Jul 2010 21:52:53 -0700
Message-Id: <1279687982-29413-6-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279687982-29413-1-git-send-email-justinmattock@gmail.com>
References: <1279687982-29413-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates broken web addresses to the best of my
knowledge.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/hwmon/lm85 |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/hwmon/lm85 b/Documentation/hwmon/lm85
index a76aefe..c7f9cfa 100644
--- a/Documentation/hwmon/lm85
+++ b/Documentation/hwmon/lm85
@@ -13,11 +13,11 @@ Supported chips:
   * Analog Devices ADT7463
     Prefix: 'adt7463'
     Addresses scanned: I2C 0x2c, 0x2d, 0x2e
-    Datasheet: http://www.analog.com/en/prod/0,,766_825_ADT7463,00.html
+    http://www.analog.com/en/index.html 
   * SMSC EMC6D100, SMSC EMC6D101
     Prefix: 'emc6d100'
     Addresses scanned: I2C 0x2c, 0x2d, 0x2e
-    Datasheet: http://www.smsc.com/main/tools/discontinued/6d100.pdf
+    Datasheet: http://www.smsc.com/
   * SMSC EMC6D102
     Prefix: 'emc6d102'
     Addresses scanned: I2C 0x2c, 0x2d, 0x2e
-- 
1.7.1.rc1.21.gf3bd6


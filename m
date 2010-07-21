Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727Ab0GUExs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:53:48 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:50155 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756135Ab0GUExT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:53:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=s7sSL5r7kSn3ITK8nMXmy5vBfOyEynIjOTDEWRQRhjEHGSwCp/1cHi14UtxgVe4dZJ
         Ve9kkTJ29ApA2QKqqX2Nokgstvbtqah355sO2uEhlB6tR6I6rNowsqjZwxG1uV8X/7ct
         8ddyWe6vjyC8ogGczhwlj4iYyZwnRf1A/+zuk=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 41/41]Documentation/hwmon/thmc50 update web address.
Date: Tue, 20 Jul 2010 21:52:58 -0700
Message-Id: <1279687982-29413-11-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279687982-29413-1-git-send-email-justinmattock@gmail.com>
References: <1279687982-29413-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/hwmon/thmc50 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/hwmon/thmc50 b/Documentation/hwmon/thmc50
index 9639ca9..8a7772a 100644
--- a/Documentation/hwmon/thmc50
+++ b/Documentation/hwmon/thmc50
@@ -9,7 +9,7 @@ Supported chips:
   * Texas Instruments THMC50
     Prefix: 'thmc50'
     Addresses scanned: I2C 0x2c - 0x2e
-    Datasheet: http://focus.ti.com/docs/prod/folders/print/thmc50.html
+    Datasheet: http://www.ti.com/ 
 
 Author: Krzysztof Helt <krzysztof.h1@wp.pl>
 
-- 
1.7.1.rc1.21.gf3bd6


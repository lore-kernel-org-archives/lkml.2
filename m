Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578Ab0GUFRe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:17:34 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:34369 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755947Ab0GUExQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:53:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Od7W53J9gxL9L54xWkXr5BHWlZL+v9iuln/K+shY1VUSAcnKA1baNN1qYz26asgvIK
         v4TtozCuBdJfsCkRFUuPtDTZAmeq5fnXA2gLKr1P8cWJdCLj4TIxhhhWlkv3hGRSzOAk
         YZHOxDPD+nKYJ4dJUo9UWtXdYg/zqWYDJxbbc=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 39/39]Documentation/hwmon/w83627hf update web address.
Date: Tue, 20 Jul 2010 21:52:56 -0700
Message-Id: <1279687982-29413-9-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279687982-29413-1-git-send-email-justinmattock@gmail.com>
References: <1279687982-29413-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes broken web addresses that I cant seem to locate
and adds the correct location to the company.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/hwmon/w83627hf |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/Documentation/hwmon/w83627hf b/Documentation/hwmon/w83627hf
index 44dd2bc..fb145e5 100644
--- a/Documentation/hwmon/w83627hf
+++ b/Documentation/hwmon/w83627hf
@@ -5,23 +5,19 @@ Supported chips:
   * Winbond W83627HF (ISA accesses ONLY)
     Prefix: 'w83627hf'
     Addresses scanned: ISA address retrieved from Super I/O registers
-    Datasheet: http://www.winbond.com/PDF/sheet/w83627hf.pdf
   * Winbond W83627THF
     Prefix: 'w83627thf'
     Addresses scanned: ISA address retrieved from Super I/O registers
-    Datasheet: http://www.winbond.com/PDF/sheet/w83627thf.pdf
   * Winbond W83697HF
     Prefix: 'w83697hf'
     Addresses scanned: ISA address retrieved from Super I/O registers
-    Datasheet: http://www.winbond.com/PDF/sheet/697hf.pdf
   * Winbond W83637HF
     Prefix: 'w83637hf'
     Addresses scanned: ISA address retrieved from Super I/O registers
-    Datasheet: http://www.winbond.com/PDF/sheet/w83637hf.pdf
   * Winbond W83687THF
     Prefix: 'w83687thf'
     Addresses scanned: ISA address retrieved from Super I/O registers
-    Datasheet: Provided by Winbond on request
+    Datasheet: Provided by Winbond on request(http://www.winbond.com/hq/enu)
 
 Authors:
         Frodo Looijaard <frodol@dds.nl>,
-- 
1.7.1.rc1.21.gf3bd6


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932593Ab2KVU4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:56:53 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:58996 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756140Ab2KVU4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:56:50 -0500
X-Greylist: delayed 3791 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Nov 2012 15:56:50 EST
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 1/1] Documentation: Fix historical inconsistency in STMPE DT doc
Date: Thu, 22 Nov 2012 12:24:24 +0000
Message-Id: <1353587064-10541-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously a generic binding 'i2c-client-wake' was created which
enabled I2C devices to register themselves as wake-up devices.
This binding was later over-thrown by 'wakeup-source'. The STMPE
driver was fixed-up, but the document was neglected. This patch
aims to rectify that.

Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: devicetree-discuss@lists.ozlabs.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 Documentation/devicetree/bindings/mfd/stmpe.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/stmpe.txt b/Documentation/devicetree/bindings/mfd/stmpe.txt
index 8f0aeda..c984508 100644
--- a/Documentation/devicetree/bindings/mfd/stmpe.txt
+++ b/Documentation/devicetree/bindings/mfd/stmpe.txt
@@ -8,7 +8,7 @@ Optional properties:
  - interrupts                   : The interrupt outputs from the controller
  - interrupt-controller         : Marks the device node as an interrupt controller
  - interrupt-parent             : Specifies which IRQ controller we're connected to
- - i2c-client-wake              : Marks the input device as wakable
+ - wakeup-source                : Marks the input device as wakable
  - st,autosleep-timeout         : Valid entries (ms); 4, 16, 32, 64, 128, 256, 512 and 1024
 
 Example:
@@ -20,6 +20,6 @@ Example:
 		interrupt-parent = <&gpio6>;
 		interrupt-controller;
 
-		i2c-client-wake;
+		wakeup-source;
 		st,autosleep-timeout = <1024>;
 	};
-- 
1.7.9.5


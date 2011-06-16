Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab1FPLmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 07:42:54 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:36367 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754478Ab1FPLmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 07:42:52 -0400
X-Sasl-enc: KbvgboTrEBdzoMStW51Tz/RO385F0xnGAjEIhPTkDXlR 1308224570
Message-ID: <4DF9ECF3.20700@ladisch.de>
Date: Thu, 16 Jun 2011 13:45:55 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
CC: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: hwmon: (k10temp) update documentation
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add some CPU series IDs and links to the Fam12h datasheets.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>

--- a/Documentation/hwmon/k10temp
+++ b/Documentation/hwmon/k10temp
@@ -9,8 +9,8 @@ Supported chips:
   Socket S1G3: Athlon II, Sempron, Turion II
 * AMD Family 11h processors:
   Socket S1G2: Athlon (X2), Sempron (X2), Turion X2 (Ultra)
-* AMD Family 12h processors: "Llano"
-* AMD Family 14h processors: "Brazos" (C/E/G-Series)
+* AMD Family 12h processors: "Llano" (E2/A4/A6/A8-Series)
+* AMD Family 14h processors: "Brazos" (C/E/G/Z-Series)
 * AMD Family 15h processors: "Bulldozer"
 
   Prefix: 'k10temp'
@@ -20,12 +20,16 @@ Supported chips:
     http://support.amd.com/us/Processor_TechDocs/31116.pdf
   BIOS and Kernel Developer's Guide (BKDG) for AMD Family 11h Processors:
     http://support.amd.com/us/Processor_TechDocs/41256.pdf
+  BIOS and Kernel Developer's Guide (BKDG) for AMD Family 12h Processors:
+    http://support.amd.com/us/Processor_TechDocs/41131.pdf
   BIOS and Kernel Developer's Guide (BKDG) for AMD Family 14h Models 00h-0Fh Processors:
     http://support.amd.com/us/Processor_TechDocs/43170.pdf
   Revision Guide for AMD Family 10h Processors:
     http://support.amd.com/us/Processor_TechDocs/41322.pdf
   Revision Guide for AMD Family 11h Processors:
     http://support.amd.com/us/Processor_TechDocs/41788.pdf
+  Revision Guide for AMD Family 12h Processors:
+    http://support.amd.com/us/Processor_TechDocs/44739.pdf
   Revision Guide for AMD Family 14h Models 00h-0Fh Processors:
     http://support.amd.com/us/Processor_TechDocs/47534.pdf
   AMD Family 11h Processor Power and Thermal Data Sheet for Notebooks:

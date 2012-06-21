Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab2FUO2j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 10:28:39 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:36877 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab2FUO2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 10:28:37 -0400
Date: Thu, 21 Jun 2012 16:28:07 +0200
From: Jean Delvare <khali@linux-fr.org>
To: x86@kernel.org
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86, cpufeature: Fix duplicate feature name "dts"
Message-ID: <20120621162807.3c621d46@endymion.delvare>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Delvare <khali@linux-fr.org>
Subject: x86, cpufeature: Fix duplicate feature name "dts"

We currently have two different x86 CPU features reported as "dts"
in /proc/cpuinfo: Debug Store and Digital Thermal Sensor. Change the
former to "ds" which makes more sense anyway, to clear up the
confusion.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/cpufeature.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-3.5-rc3.orig/arch/x86/include/asm/cpufeature.h	2012-06-21 15:57:17.061585016 +0200
+++ linux-3.5-rc3/arch/x86/include/asm/cpufeature.h	2012-06-21 15:57:42.087585387 +0200
@@ -35,7 +35,7 @@
 #define X86_FEATURE_PSE36	(0*32+17) /* 36-bit PSEs */
 #define X86_FEATURE_PN		(0*32+18) /* Processor serial number */
 #define X86_FEATURE_CLFLSH	(0*32+19) /* "clflush" CLFLUSH instruction */
-#define X86_FEATURE_DS		(0*32+21) /* "dts" Debug Store */
+#define X86_FEATURE_DS		(0*32+21) /* Debug Store */
 #define X86_FEATURE_ACPI	(0*32+22) /* ACPI via MSR */
 #define X86_FEATURE_MMX		(0*32+23) /* Multimedia Extensions */
 #define X86_FEATURE_FXSR	(0*32+24) /* FXSAVE/FXRSTOR, CR4.OSFXSR */


-- 
Jean Delvare

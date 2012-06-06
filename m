Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab2FFMRx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 08:17:53 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:2069 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753348Ab2FFMRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 08:17:51 -0400
Message-ID: <1338985066.21725.11.camel@x61.thuisdomein>
Subject: [PATCH] [TRIVIAL] treewide: Put a space between #include and FILE
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 06 Jun 2012 14:17:46 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 06 Jun 2012 12:17:46.0260 (UTC) FILETIME=[61957D40:01CD43DE]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) I was surprised to learn that it is legal to have no whitespace
between an #include preprocessor directive and its "FILE" or <FILE>. I
only discovered that because of some oddities in the output of a script
that grepped for #include directives. Since it is uncommon to have no
whitespace after #include, and a bit ugly too, I suggest to put a space
between these #include directives and their FILE.

1) Only git tested (with "git diff -w HEAD^"). Compile test would
require toolchains that I do not have at hand. Looks obviously correct
anyway.

 arch/arm/plat-samsung/include/plat/gpio-cfg.h |    2 +-
 arch/ia64/kernel/ia64_ksyms.c                 |    2 +-
 arch/ia64/kvm/vmm.c                           |    6 +++---
 arch/parisc/include/asm/compat_rt_sigframe.h  |    6 +++---
 drivers/media/video/zoran/zr36016.c           |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-io.c         |    2 +-
 drivers/scsi/aha1542.c                        |    2 +-
 drivers/staging/comedi/drivers/s626.h         |    2 +-
 8 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/arm/plat-samsung/include/plat/gpio-cfg.h b/arch/arm/plat-samsung/include/plat/gpio-cfg.h
index df8155b..08740ee 100644
--- a/arch/arm/plat-samsung/include/plat/gpio-cfg.h
+++ b/arch/arm/plat-samsung/include/plat/gpio-cfg.h
@@ -24,7 +24,7 @@
 #ifndef __PLAT_GPIO_CFG_H
 #define __PLAT_GPIO_CFG_H __FILE__
 
-#include<linux/types.h>
+#include <linux/types.h>
 
 typedef unsigned int __bitwise__ samsung_gpio_pull_t;
 typedef unsigned int __bitwise__ s5p_gpio_drvstr_t;
diff --git a/arch/ia64/kernel/ia64_ksyms.c b/arch/ia64/kernel/ia64_ksyms.c
index 7f4a0ed..5b7791d 100644
--- a/arch/ia64/kernel/ia64_ksyms.c
+++ b/arch/ia64/kernel/ia64_ksyms.c
@@ -12,7 +12,7 @@ EXPORT_SYMBOL(memset);
 EXPORT_SYMBOL(memcpy);
 EXPORT_SYMBOL(strlen);
 
-#include<asm/pgtable.h>
+#include <asm/pgtable.h>
 EXPORT_SYMBOL_GPL(empty_zero_page);
 
 #include <asm/checksum.h>
diff --git a/arch/ia64/kvm/vmm.c b/arch/ia64/kvm/vmm.c
index f0b9cac..176a12c 100644
--- a/arch/ia64/kvm/vmm.c
+++ b/arch/ia64/kvm/vmm.c
@@ -20,9 +20,9 @@
  */
 

-#include<linux/kernel.h>
-#include<linux/module.h>
-#include<asm/fpswa.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <asm/fpswa.h>
 
 #include "vcpu.h"
 
diff --git a/arch/parisc/include/asm/compat_rt_sigframe.h b/arch/parisc/include/asm/compat_rt_sigframe.h
index 81bec28..b3f95a7 100644
--- a/arch/parisc/include/asm/compat_rt_sigframe.h
+++ b/arch/parisc/include/asm/compat_rt_sigframe.h
@@ -1,6 +1,6 @@
-#include<linux/compat.h>
-#include<linux/compat_siginfo.h>
-#include<asm/compat_ucontext.h>
+#include <linux/compat.h>
+#include <linux/compat_siginfo.h>
+#include <asm/compat_ucontext.h>
 
 #ifndef _ASM_PARISC_COMPAT_RT_SIGFRAME_H
 #define _ASM_PARISC_COMPAT_RT_SIGFRAME_H
diff --git a/drivers/media/video/zoran/zr36016.c b/drivers/media/video/zoran/zr36016.c
index 21c088e..b87ddba 100644
--- a/drivers/media/video/zoran/zr36016.c
+++ b/drivers/media/video/zoran/zr36016.c
@@ -40,10 +40,10 @@
 /* v4l  API */
 
 /* headerfile of this module */
-#include"zr36016.h"
+#include "zr36016.h"
 
 /* codec io API */
-#include"videocodec.h"
+#include "videocodec.h"
 
 /* it doesn't make sense to have more than 20 or so,
   just to prevent some unwanted loops */
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.c b/drivers/net/wireless/iwlwifi/iwl-io.c
index 081dd34..0f8b8aa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/iwlwifi/iwl-io.c
@@ -29,7 +29,7 @@
 #include <linux/device.h>
 
 #include "iwl-io.h"
-#include"iwl-csr.h"
+#include "iwl-csr.h"
 #include "iwl-debug.h"
 
 #define IWL_POLL_INTERVAL 10	/* microseconds */
diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index f79c8f9..770c48d 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -49,7 +49,7 @@
 #define SCSI_BUF_PA(address)	isa_virt_to_bus(address)
 #define SCSI_SG_PA(sgent)	(isa_page_to_bus(sg_page((sgent))) + (sgent)->offset)
 
-#include<linux/stat.h>
+#include <linux/stat.h>
 
 #ifdef DEBUG
 #define DEB(x) x
diff --git a/drivers/staging/comedi/drivers/s626.h b/drivers/staging/comedi/drivers/s626.h
index 2d1afec..92d3ea5 100644
--- a/drivers/staging/comedi/drivers/s626.h
+++ b/drivers/staging/comedi/drivers/s626.h
@@ -80,7 +80,7 @@
 #define INLINE static __inline
 #endif
 
-#include<linux/slab.h>
+#include <linux/slab.h>
 
 #define S626_SIZE 0x0200
 #define SIZEOF_ADDRESS_SPACE		0x0200
-- 
1.7.7.6


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114Ab2BWOnJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 09:43:09 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:34564
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab2BWOnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 09:43:06 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: ralf@linux-mips.org, linux-mips@linux-mips.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] mips: Fix typo in arc/mips
Date: Thu, 23 Feb 2012 23:42:19 +0900
Message-Id: <1330008139-1916-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "platfom" to "platform", "deactived" to "deactivated"
and "deprectated" to "deprecated" in arch/mips directory.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 arch/mips/kernel/mips-mt.c       |    2 +-
 arch/mips/lantiq/xway/gpio.c     |    2 +-
 arch/mips/lantiq/xway/gpio_ebu.c |    2 +-
 arch/mips/lantiq/xway/gpio_stp.c |    2 +-
 arch/mips/pci/pci-lantiq.c       |    2 +-
 arch/mips/sni/pcimt.c            |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/mips/kernel/mips-mt.c b/arch/mips/kernel/mips-mt.c
index c23d11f..b3b0b94 100644
--- a/arch/mips/kernel/mips-mt.c
+++ b/arch/mips/kernel/mips-mt.c
@@ -210,7 +210,7 @@ void mips_mt_set_cpuoptions(void)
 	unsigned int nconfig7 = oconfig7;
 
 	if (mt_opt_norps) {
-		printk("\"norps\" option deprectated: use \"rpsctl=\"\n");
+		printk("\"norps\" option deprecated: use \"rpsctl=\"\n");
 	}
 	if (mt_opt_rpsctl >= 0) {
 		printk("34K return prediction stack override set to %d.\n",
diff --git a/arch/mips/lantiq/xway/gpio.c b/arch/mips/lantiq/xway/gpio.c
index d2fa98f..c429a5b 100644
--- a/arch/mips/lantiq/xway/gpio.c
+++ b/arch/mips/lantiq/xway/gpio.c
@@ -188,7 +188,7 @@ int __init ltq_gpio_init(void)
 	int ret = platform_driver_register(&ltq_gpio_driver);
 
 	if (ret)
-		pr_info("ltq_gpio : Error registering platfom driver!");
+		pr_info("ltq_gpio : Error registering platform driver!");
 	return ret;
 }
 
diff --git a/arch/mips/lantiq/xway/gpio_ebu.c b/arch/mips/lantiq/xway/gpio_ebu.c
index b91c7f1..aae1717 100644
--- a/arch/mips/lantiq/xway/gpio_ebu.c
+++ b/arch/mips/lantiq/xway/gpio_ebu.c
@@ -119,7 +119,7 @@ static int __init ltq_ebu_init(void)
 	int ret = platform_driver_register(&ltq_ebu_driver);
 
 	if (ret)
-		pr_info("ltq_ebu : Error registering platfom driver!");
+		pr_info("ltq_ebu : Error registering platform driver!");
 	return ret;
 }
 
diff --git a/arch/mips/lantiq/xway/gpio_stp.c b/arch/mips/lantiq/xway/gpio_stp.c
index ff9991c..fd07d87 100644
--- a/arch/mips/lantiq/xway/gpio_stp.c
+++ b/arch/mips/lantiq/xway/gpio_stp.c
@@ -150,7 +150,7 @@ int __init ltq_stp_init(void)
 	int ret = platform_driver_register(&ltq_stp_driver);
 
 	if (ret)
-		pr_info("ltq_stp: error registering platfom driver");
+		pr_info("ltq_stp: error registering platform driver");
 	return ret;
 }
 
diff --git a/arch/mips/pci/pci-lantiq.c b/arch/mips/pci/pci-lantiq.c
index be1e1af..df3dca0 100644
--- a/arch/mips/pci/pci-lantiq.c
+++ b/arch/mips/pci/pci-lantiq.c
@@ -296,7 +296,7 @@ int __init pcibios_init(void)
 {
 	int ret = platform_driver_register(&ltq_pci_driver);
 	if (ret)
-		printk(KERN_INFO "ltq_pci: Error registering platfom driver!");
+		printk(KERN_INFO "ltq_pci: Error registering platform driver!");
 	return ret;
 }
 
diff --git a/arch/mips/sni/pcimt.c b/arch/mips/sni/pcimt.c
index ed3b3d317..cdb1417 100644
--- a/arch/mips/sni/pcimt.c
+++ b/arch/mips/sni/pcimt.c
@@ -29,7 +29,7 @@ static void __init sni_pcimt_sc_init(void)
 
 	scsiz = cacheconf & 7;
 	if (scsiz == 0) {
-		printk("Second level cache is deactived.\n");
+		printk("Second level cache is deactivated.\n");
 		return;
 	}
 	if (scsiz >= 6) {
-- 
1.7.6.5


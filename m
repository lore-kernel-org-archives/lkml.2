Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab2K3FKd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 00:10:33 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51142 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab2K3FKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 00:10:31 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] treewide: Fix typos in various drivers
Date: Fri, 30 Nov 2012 14:10:25 +0900
Message-Id: <1354252225-25996-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.0.1.244.g77b598b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix typos in printk within various drivers.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 arch/arm/kernel/kprobes-test.c             | 2 +-
 arch/arm/mach-netx/xc.c                    | 2 +-
 arch/blackfin/mach-bf609/Kconfig           | 2 +-
 arch/blackfin/mm/sram-alloc.c              | 2 +-
 drivers/media/dvb-frontends/drxk_hard.c    | 2 +-
 drivers/media/platform/mx2_emmaprp.c       | 2 +-
 drivers/remoteproc/remoteproc_elf_loader.c | 4 ++--
 tools/perf/Documentation/perf-record.txt   | 2 +-
 tools/perf/util/parse-events-test.c        | 2 +-
 9 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm/kernel/kprobes-test.c b/arch/arm/kernel/kprobes-test.c
index 1862d8f..0cd63d0 100644
--- a/arch/arm/kernel/kprobes-test.c
+++ b/arch/arm/kernel/kprobes-test.c
@@ -1598,7 +1598,7 @@ static int __init run_all_tests(void)
 {
 	int ret = 0;
 
-	pr_info("Begining kprobe tests...\n");
+	pr_info("Beginning kprobe tests...\n");
 
 #ifndef CONFIG_THUMB2_KERNEL
 
diff --git a/arch/arm/mach-netx/xc.c b/arch/arm/mach-netx/xc.c
index e4cfb7e..f1c972d 100644
--- a/arch/arm/mach-netx/xc.c
+++ b/arch/arm/mach-netx/xc.c
@@ -136,7 +136,7 @@ int xc_request_firmware(struct xc *x)
 	if (head->magic != 0x4e657458) {
 		if (head->magic == 0x5874654e) {
 			dev_err(x->dev,
-			    "firmware magic is 'XteN'. Endianess problems?\n");
+			    "firmware magic is 'XteN'. Endianness problems?\n");
 			ret = -ENODEV;
 			goto exit_release_firmware;
 		}
diff --git a/arch/blackfin/mach-bf609/Kconfig b/arch/blackfin/mach-bf609/Kconfig
index 101b33e..95a4f1b 100644
--- a/arch/blackfin/mach-bf609/Kconfig
+++ b/arch/blackfin/mach-bf609/Kconfig
@@ -56,7 +56,7 @@ config SEC_IRQ_PRIORITY_LEVELS
 	default 7
 	range 0 7
 	help
-	  Devide the total number of interrupt priority levels into sub-levels.
+	  Divide the total number of interrupt priority levels into sub-levels.
 	  There is 2 ^ (SEC_IRQ_PRIORITY_LEVELS + 1) different levels.
 
 endmenu
diff --git a/arch/blackfin/mm/sram-alloc.c b/arch/blackfin/mm/sram-alloc.c
index 342e378..1f3b3ef 100644
--- a/arch/blackfin/mm/sram-alloc.c
+++ b/arch/blackfin/mm/sram-alloc.c
@@ -191,7 +191,7 @@ static irqreturn_t l2_ecc_err(int irq, void *dev_id)
 {
 	int status;
 
-	printk(KERN_ERR "L2 ecc error happend\n");
+	printk(KERN_ERR "L2 ecc error happened\n");
 	status = bfin_read32(L2CTL0_STAT);
 	if (status & 0x1)
 		printk(KERN_ERR "Core channel error type:0x%x, addr:0x%x\n",
diff --git a/drivers/media/dvb-frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
index 8b4c6d5..df9abe8 100644
--- a/drivers/media/dvb-frontends/drxk_hard.c
+++ b/drivers/media/dvb-frontends/drxk_hard.c
@@ -948,7 +948,7 @@ static int GetDeviceCapabilities(struct drxk_state *state)
 		state->m_oscClockFreq = 20250;
 		break;
 	default:
-		printk(KERN_ERR "drxk: Clock Frequency is unkonwn\n");
+		printk(KERN_ERR "drxk: Clock Frequency is unknown\n");
 		return -EINVAL;
 	}
 	/*
diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
index 8f22ce5..bfa6507 100644
--- a/drivers/media/platform/mx2_emmaprp.c
+++ b/drivers/media/platform/mx2_emmaprp.c
@@ -371,7 +371,7 @@ static irqreturn_t emmaprp_irq(int irq_emma, void *data)
 	if (!curr_ctx->aborting) {
 		if ((irqst & PRP_INTR_ST_RDERR) ||
 		(irqst & PRP_INTR_ST_CH2WERR)) {
-			pr_err("PrP bus error ocurred, this transfer is probably corrupted\n");
+			pr_err("PrP bus error occurred, this transfer is probably corrupted\n");
 			writel(PRP_CNTL_SWRST, pcdev->base_emma + PRP_CNTL);
 		} else if (irqst & PRP_INTR_ST_CH2B1CI) { /* buffer ready */
 			src_vb = v4l2_m2m_src_buf_remove(curr_ctx->m2m_ctx);
diff --git a/drivers/remoteproc/remoteproc_elf_loader.c b/drivers/remoteproc/remoteproc_elf_loader.c
index e1f89d6..0d36f94 100644
--- a/drivers/remoteproc/remoteproc_elf_loader.c
+++ b/drivers/remoteproc/remoteproc_elf_loader.c
@@ -66,13 +66,13 @@ rproc_elf_sanity_check(struct rproc *rproc, const struct firmware *fw)
 		return -EINVAL;
 	}
 
-	/* We assume the firmware has the same endianess as the host */
+	/* We assume the firmware has the same endianness as the host */
 # ifdef __LITTLE_ENDIAN
 	if (ehdr->e_ident[EI_DATA] != ELFDATA2LSB) {
 # else /* BIG ENDIAN */
 	if (ehdr->e_ident[EI_DATA] != ELFDATA2MSB) {
 # endif
-		dev_err(dev, "Unsupported firmware endianess\n");
+		dev_err(dev, "Unsupported firmware endianness\n");
 		return -EINVAL;
 	}
 
diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index b38a1f9..938e890 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -175,7 +175,7 @@ following filters are defined:
 
 +
 The option requires at least one branch type among any, any_call, any_ret, ind_call.
-The privilege levels may be ommitted, in which case, the privilege levels of the associated
+The privilege levels may be omitted, in which case, the privilege levels of the associated
 event are applied to the branch filter. Both kernel (k) and hypervisor (hv) privilege
 levels are subject to permissions.  When sampling on multiple events, branch stack sampling
 is enabled for all the sampling events. The sampled branch type is the same for all events.
diff --git a/tools/perf/util/parse-events-test.c b/tools/perf/util/parse-events-test.c
index b49c2ee..f07abeb 100644
--- a/tools/perf/util/parse-events-test.c
+++ b/tools/perf/util/parse-events-test.c
@@ -1054,7 +1054,7 @@ static int test_pmu_events(void)
 
 	ret = stat(path, &st);
 	if (ret) {
-		pr_debug("ommiting PMU cpu events tests\n");
+		pr_debug("omitting PMU cpu events tests\n");
 		return 0;
 	}
 
-- 
1.8.0.1.244.g77b598b


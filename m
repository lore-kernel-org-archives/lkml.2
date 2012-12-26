Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab2LZB4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 20:56:13 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:48085 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab2LZByE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 20:54:04 -0500
X-AuditID: cbfee61b-b7f616d00000319b-22-50da58bb1481
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>
Cc: "'Hyunwoong Kim'" <khw0178.kim@samsung.com>,
        "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>
Subject: [PATCH v6 07/12] ARM: EXYNOS: remove system mmu initialization from
 exynos tree
Date: Wed, 26 Dec 2012 10:54:02 +0900
Message-id: <003a01cde30b$e13c1910$a3b44b30$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3jC+EgrvN31H2XRzyzUdFf02mIkQ==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsVy+t8zY93dEbcCDP7s4bK4vGsOm8WM8/uY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4MpY35FT8PgWY8Wbw/PYGxhvbGPsYuTkkBAwkXi3ZDoT
	hC0mceHeerYuRi4OIYFljBKfLzxjgymauWEGVGI6o8TcJ+9YIZx/jBI7ny4Aa2cT0JJYPfc4
	2FgRgbuMEi/P84AUMQv8ZZT4dOYQO0hCWCBKYvW3Y2ANLAKqEi8OPAcay8HBK2ArcW5fIUiY
	V0BQ4sfkeywgNrOAgcT7WX2sELa8xOY1b5lByiUE1CUe/dWFWKUn0fF5KlSJiMS+F+8YIaYL
	SHybfIgFolxWYtMBZpBrJAQms0v0dz5mhXhMUuLgihssExjFZiHZPAvJ5llINs9CsmIBI8sq
	RtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjJC4kd7BuKrB4hCjAAejEg8v56+bAUKsiWXFlbmH
	GCU4mJVEeJ0/AoV4UxIrq1KL8uOLSnNSiw8x+gBdPpFZSjQ5HxjTeSXxhsbGJmYmpibmlqbm
	pjiElcR5mz1SAoQE0hNLUrNTUwtSi2DGMXFwSjUwpq57NoXJt9gp1/idUu/1yTO9Nk6y+CEi
	vpHpJX9dTlW06+1uvTWhh/hfeK9d+myTxbGKqL5pt+auOfzcq6mrKKlJ4E/e1e2H19s4pM8J
	0N5317x4SvycXbtU3r8v+KPyJJgzb+o8lbVCEsEb/QoU/T+569p7zAv7ZbmzZDa7pbS4lJvJ
	AbEIJZbijERDLeai4kQAZeNBssgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t9jQd3dEbcCDOZPYLG4vGsOm8WM8/uY
	HJg8Pm+SC2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAEaraRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMWN+RU/D4FmPF
	m8Pz2BsYb2xj7GLk5JAQMJGYuWEGG4QtJnHh3nogm4tDSGA6o8TcJ+9YIZx/jBI7ny5gAqli
	E9CSWD33OFi3iMBdRomX53lAipgF/jJKfDpziB0kISwQJbH62zGwBhYBVYkXB54DjeXg4BWw
	lTi3rxAkzCsgKPFj8j0WEJtZwEDi/aw+VghbXmLzmrfMIOUSAuoSj/7qQqzSk+j4PBWqRERi
	34t3jBMYBWYhmTQLyaRZSCbNQtKygJFlFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwVD6T
	3sG4qsHiEKMAB6MSDy/nr5sBQqyJZcWVuYcYJTiYlUR4nT8ChXhTEiurUovy44tKc1KLDzH6
	AP05kVlKNDkfmDDySuINjU3MjCyNzCyMTMzNcQgrifM2e6QECAmkJ5akZqemFqQWwYxj4uCU
	amCUlF9TqWko3Rmx2c4u9fM8mdTtG1tCuJ/9E3WUlLhXfa6wTq2pOV8oun7n2rz+/z3L71xa
	xvfD0qryzbs6zzg/QZfM16GH0vsKD55+tm+nbY9FVXe7ZeE5YZ41+v2iW/o5nkotuOIvIXne
	9aj04tKVz5bHpssL78htO+9afPrkI51Tv/7sMFRiKc5INNRiLipOBADJ18Ma9wIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes System MMU initialization from arch/arm/mach-exynos/
to move them to DT and the exynos-iommu driver except gating clock
definitions.

Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
---
 arch/arm/mach-exynos/Kconfig               |   5 -
 arch/arm/mach-exynos/Makefile              |   1 -
 arch/arm/mach-exynos/clock-exynos4.c       |  41 +++--
 arch/arm/mach-exynos/clock-exynos4210.c    |   9 +-
 arch/arm/mach-exynos/clock-exynos4212.c    |  23 ++-
 arch/arm/mach-exynos/clock-exynos5.c       |  62 ++++---
 arch/arm/mach-exynos/dev-sysmmu.c          | 274 -----------------------------
 arch/arm/mach-exynos/include/mach/sysmmu.h |  66 -------
 arch/arm/mach-exynos/mach-exynos4-dt.c     |  34 ++++
 arch/arm/mach-exynos/mach-exynos5-dt.c     |  30 ++++
 10 files changed, 137 insertions(+), 408 deletions(-)
 delete mode 100644 arch/arm/mach-exynos/dev-sysmmu.c
 delete mode 100644 arch/arm/mach-exynos/include/mach/sysmmu.h

diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index 91d5b6f..eba6eb5 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -103,11 +103,6 @@ config EXYNOS4_SETUP_FIMD0
 	help
 	  Common setup code for FIMD0.
 
-config EXYNOS_DEV_SYSMMU
-	bool
-	help
-	  Common setup code for SYSTEM MMU in EXYNOS platforms
-
 config EXYNOS4_DEV_USB_OHCI
 	bool
 	help
diff --git a/arch/arm/mach-exynos/Makefile b/arch/arm/mach-exynos/Makefile
index b189881..435757e 100644
--- a/arch/arm/mach-exynos/Makefile
+++ b/arch/arm/mach-exynos/Makefile
@@ -52,7 +52,6 @@ obj-$(CONFIG_ARCH_EXYNOS4)		+= dev-audio.o
 obj-$(CONFIG_EXYNOS4_DEV_AHCI)		+= dev-ahci.o
 obj-$(CONFIG_EXYNOS_DEV_DMA)		+= dma.o
 obj-$(CONFIG_EXYNOS4_DEV_USB_OHCI)	+= dev-ohci.o
-obj-$(CONFIG_EXYNOS_DEV_SYSMMU)		+= dev-sysmmu.o
 
 obj-$(CONFIG_ARCH_EXYNOS)		+= setup-i2c0.o
 obj-$(CONFIG_EXYNOS4_SETUP_FIMC)	+= setup-fimc.o
diff --git a/arch/arm/mach-exynos/clock-exynos4.c b/arch/arm/mach-exynos/clock-exynos4.c
index bbcb3de..8a8468d 100644
--- a/arch/arm/mach-exynos/clock-exynos4.c
+++ b/arch/arm/mach-exynos/clock-exynos4.c
@@ -24,7 +24,6 @@
 
 #include <mach/map.h>
 #include <mach/regs-clock.h>
-#include <mach/sysmmu.h>
 
 #include "common.h"
 #include "clock-exynos4.h"
@@ -709,53 +708,53 @@ static struct clk exynos4_init_clocks_off[] = {
 		.enable		= exynos4_clk_ip_peril_ctrl,
 		.ctrlbit	= (1 << 14),
 	}, {
-		.name		= SYSMMU_CLOCK_NAME,
-		.devname	= SYSMMU_CLOCK_DEVNAME(mfc_l, 0),
+		.name		= "sysmmu",
+		.devname	= "exynos-sysmmu.0",
 		.enable		= exynos4_clk_ip_mfc_ctrl,
 		.ctrlbit	= (1 << 1),
 	}, {
-		.name		= SYSMMU_CLOCK_NAME,
-		.devname	= SYSMMU_CLOCK_DEVNAME(mfc_r, 1),
+		.name		= "sysmmu",
+		.devname	= "exynos-sysmmu.1",
 		.enable		= exynos4_clk_ip_mfc_ctrl,
 		.ctrlbit	= (1 << 2),
 	}, {
-		.name		= SYSMMU_CLOCK_NAME,
-		.devname	= SYSMMU_CLOCK_DEVNAME(tv, 2),
+		.name		= "sysmmu",
+		.devname	= "exynos-sysmmu.2",
 		.enable		= exynos4_clk_ip_tv_ctrl,
 		.ctrlbit	= (1 << 4),
 	}, {
-		.name		= SYSMMU_CLOCK_NAME,
-		.devname	= SYSMMU_CLOCK_DEVNAME(jpeg, 3),
+		.name		= "sysmmu",
+		.devname	= "exynos-sysmmu.3",
 		.enable		= exynos4_clk_ip_cam_ctrl,
 		.ctrlbit	= (1 << 11),
 	}, {
-		.name		= SYSMMU_CLOCK_NAME,
-		.devname	= SYSMMU_CLOCK_DEVNAME(rot, 4),
+		.name		= "sysmmu",
+		.devname	= "exynos-sysmmu.4",
 		.enable		= exynos4_clk_ip_image_ctrl,
 		.ctrlbit	= (1 << 4),
 	}, {
-		.name		= SYSMMU_CLOCK_NAME,
-		.devname	= SYSMMU_CLOCK_DEVNAME(fimc0, 5),
+		.name		= "sysmmu",
+		.devname	= "exynos-sysmmu.5",
 		.enable		= exynos4_clk_ip_cam_ctrl,
 		.ctrlbit	= (1 << 7),
 	}, {
-		.name		= SYSMMU_CLOCK_NAME,
-		.devname	= SYSMMU_CLOCK_DEVNAME(fimc1, 6),
+		.name		= "sysmmu",
+		.devname	= "exynos-sysmmu.6",
 		.enable		= exynos4_clk_ip_cam_ctrl,
 		.ctrlbit	= (1 << 8),
 	}, {
-		.name		= SYSMMU_CLOCK_NAME,
-		.devname	= SYSMMU_CLOCK_DEVNAME(fimc2, 7),
+		.name		= "sysmmu",
+		.devname	= "exynos-sysmmu.7",
 		.enable		= exynos4_clk_ip_cam_ctrl,
 		.ctrlbit	= (1 << 9),
 	}, {
-		.name		= SYSMMU_CLOCK_NAME,
-		.devname	= SYSMMU_CLOCK_DEVNAME(fimc3, 8),
+		.name		= "sysmmu",
+		.devname	= "exynos-sysmmu.8",
 		.enable		= exynos4_clk_ip_cam_ctrl,
 		.ctrlbit	= (1 << 10),
 	}, {
-		.name		= SYSMMU_CLOCK_NAME,
-		.devname	= SYSMMU_CLOCK_DEVNAME(fimd0, 10),
+		.name		= "sysmmu",
+		.devname	= "exynos-sysmmu.10",
 		.enable		= exynos4_clk_ip_lcd0_ctrl,
 		.ctrlbit	= (1 << 4),
 	}
diff --git a/arch/arm/mach-exynos/clock-exynos4210.c b/arch/arm/mach-exynos/clock-exynos4210.c
index fed4c26..19af9f7 100644
--- a/arch/arm/mach-exynos/clock-exynos4210.c
+++ b/arch/arm/mach-exynos/clock-exynos4210.c
@@ -26,7 +26,6 @@
 #include <mach/hardware.h>
 #include <mach/map.h>
 #include <mach/regs-clock.h>
-#include <mach/sysmmu.h>
 
 #include "common.h"
 #include "clock-exynos4.h"
@@ -129,13 +128,13 @@ static struct clk init_clocks_off[] = {
 		.enable		= exynos4_clk_ip_lcd1_ctrl,
 		.ctrlbit	= (1 << 0),
 	}, {
-		.name		= SYSMMU_CLOCK_NAME,
-		.devname	= SYSMMU_CLOCK_DEVNAME(2d, 14),
+		.name		= "sysmmu",
+		.devname	= "exynos-sysmmu.9",
 		.enable		= exynos4_clk_ip_image_ctrl,
 		.ctrlbit	= (1 << 3),
 	}, {
-		.name		= SYSMMU_CLOCK_NAME,
-		.devname	= SYSMMU_CLOCK_DEVNAME(fimd1, 11),
+		.name		= "sysmmu",
+		.devname	= "exynos-sysmmu.11",
 		.enable		= exynos4_clk_ip_lcd1_ctrl,
 		.ctrlbit	= (1 << 4),
 	}, {
diff --git a/arch/arm/mach-exynos/clock-exynos4212.c b/arch/arm/mach-exynos/clock-exynos4212.c
index 8fba0b5..529476f 100644
--- a/arch/arm/mach-exynos/clock-exynos4212.c
+++ b/arch/arm/mach-exynos/clock-exynos4212.c
@@ -26,7 +26,6 @@
 #include <mach/hardware.h>
 #include <mach/map.h>
 #include <mach/regs-clock.h>
-#include <mach/sysmmu.h>
 
 #include "common.h"
 #include "clock-exynos4.h"
@@ -111,21 +110,31 @@ static struct clksrc_clk clksrcs[] = {
 
 static struct clk init_clocks_off[] = {
 	{
-		.name		= SYSMMU_CLOCK_NAME,
-		.devname	= SYSMMU_CLOCK_DEVNAME(2d, 14),
+		.name		= "sysmmu",
+		.devname	= "exynos-sysmmu.9",
 		.enable		= exynos4_clk_ip_dmc_ctrl,
 		.ctrlbit	= (1 << 24),
 	}, {
-		.name		= SYSMMU_CLOCK_NAME,
-		.devname	= SYSMMU_CLOCK_DEVNAME(isp, 9),
+		.name		= "sysmmu",
+		.devname	= "exynos-sysmmu.12",
 		.enable		= exynos4212_clk_ip_isp0_ctrl,
 		.ctrlbit	= (7 << 8),
 	}, {
-		.name		= SYSMMU_CLOCK_NAME2,
-		.devname	= SYSMMU_CLOCK_DEVNAME(isp, 9),
+		.name		= "sysmmu",
+		.devname	= "exynos-sysmmu.13",
 		.enable		= exynos4212_clk_ip_isp1_ctrl,
 		.ctrlbit	= (1 << 4),
 	}, {
+		.name		= "sysmmu",
+		.devname	= "exynos-sysmmu.14",
+		.enable		= exynos4212_clk_ip_isp0_ctrl,
+		.ctrlbit	= (1 << 11),
+	}, {
+		.name		= "sysmmu",
+		.devname	= "exynos-sysmmu.15",
+		.enable		= exynos4212_clk_ip_isp0_ctrl,
+		.ctrlbit	= (1 << 12),
+	}, {
 		.name		= "flite",
 		.devname	= "exynos-fimc-lite.0",
 		.enable		= exynos4212_clk_ip_isp0_ctrl,
diff --git a/arch/arm/mach-exynos/clock-exynos5.c b/arch/arm/mach-exynos/clock-exynos5.c
index 0208c3a..bee2d53 100644
--- a/arch/arm/mach-exynos/clock-exynos5.c
+++ b/arch/arm/mach-exynos/clock-exynos5.c
@@ -24,7 +24,6 @@
 
 #include <mach/map.h>
 #include <mach/regs-clock.h>
-#include <mach/sysmmu.h>
 
 #include "common.h"
 
@@ -869,86 +868,91 @@ static struct clk exynos5_init_clocks_off[] = {
 		.enable		= exynos5_clk_ip_gscl_ctrl,
 		.ctrlbit	= (1 << 3),
 	}, {
-		.name		= SYSMMU_CLOCK_NAME,
-		.devname	= SYSMMU_CLOCK_DEVNAME(mfc_l, 0),
+		.name		= "sysmmu",
+		.devname	= "exynos-sysmmu.1",
 		.enable		= &exynos5_clk_ip_mfc_ctrl,
 		.ops		= &exynos5_gate_clk_ops,
 		.ctrlbit	= (1 << 1),
 	}, {
-		.name		= SYSMMU_CLOCK_NAME,
-		.devname	= SYSMMU_CLOCK_DEVNAME(mfc_r, 1),
+		.name		= "sysmmu",
+		.devname	= "exynos-sysmmu.0",
 		.enable		= &exynos5_clk_ip_mfc_ctrl,
 		.ops		= &exynos5_gate_clk_ops,
 		.ctrlbit	= (1 << 2),
 	}, {
-		.name		= SYSMMU_CLOCK_NAME,
-		.devname	= SYSMMU_CLOCK_DEVNAME(tv, 2),
+		.name		= "sysmmu",
+		.devname	= "exynos-sysmmu.2",
 		.enable		= &exynos5_clk_ip_disp1_ctrl,
 		.ops		= &exynos5_gate_clk_ops,
 		.ctrlbit	= (1 << 9)
 	}, {
-		.name		= SYSMMU_CLOCK_NAME,
-		.devname	= SYSMMU_CLOCK_DEVNAME(jpeg, 3),
+		.name		= "sysmmu",
+		.devname	= "exynos-sysmmu.3",
 		.enable		= &exynos5_clk_ip_gen_ctrl,
 		.ops		= &exynos5_gate_clk_ops,
 		.ctrlbit	= (1 << 7),
 	}, {
-		.name		= SYSMMU_CLOCK_NAME,
-		.devname	= SYSMMU_CLOCK_DEVNAME(rot, 4),
+		.name		= "sysmmu",
+		.devname	= "exynos-sysmmu.4",
 		.enable		= &exynos5_clk_ip_gen_ctrl,
 		.ops		= &exynos5_gate_clk_ops,
 		.ctrlbit	= (1 << 6)
 	}, {
-		.name		= SYSMMU_CLOCK_NAME,
-		.devname	= SYSMMU_CLOCK_DEVNAME(gsc0, 5),
+		.name		= "sysmmu",
+		.devname	= "exynos-sysmmu.5",
 		.enable		= &exynos5_clk_ip_gscl_ctrl,
 		.ops		= &exynos5_gate_clk_ops,
 		.ctrlbit	= (1 << 7),
 	}, {
-		.name		= SYSMMU_CLOCK_NAME,
-		.devname	= SYSMMU_CLOCK_DEVNAME(gsc1, 6),
+		.name		= "sysmmu",
+		.devname	= "exynos-sysmmu.6",
 		.enable		= &exynos5_clk_ip_gscl_ctrl,
 		.ops		= &exynos5_gate_clk_ops,
 		.ctrlbit	= (1 << 8),
 	}, {
-		.name		= SYSMMU_CLOCK_NAME,
-		.devname	= SYSMMU_CLOCK_DEVNAME(gsc2, 7),
+		.name		= "sysmmu",
+		.devname	= "exynos-sysmmu.7",
 		.enable		= &exynos5_clk_ip_gscl_ctrl,
 		.ops		= &exynos5_gate_clk_ops,
 		.ctrlbit	= (1 << 9),
 	}, {
-		.name		= SYSMMU_CLOCK_NAME,
-		.devname	= SYSMMU_CLOCK_DEVNAME(gsc3, 8),
+		.name		= "sysmmu",
+		.devname	= "exynos-sysmmu.8",
 		.enable		= &exynos5_clk_ip_gscl_ctrl,
 		.ops		= &exynos5_gate_clk_ops,
 		.ctrlbit	= (1 << 10),
 	}, {
-		.name		= SYSMMU_CLOCK_NAME,
-		.devname	= SYSMMU_CLOCK_DEVNAME(isp, 9),
+		.name		= "sysmmu",
+		.devname	= "exynos-sysmmu.9",
 		.enable		= &exynos5_clk_ip_isp0_ctrl,
 		.ops		= &exynos5_gate_clk_ops,
 		.ctrlbit	= (0x3F << 8),
 	}, {
-		.name		= SYSMMU_CLOCK_NAME2,
-		.devname	= SYSMMU_CLOCK_DEVNAME(isp, 9),
+		.name		= "sysmmu",
+		.devname	= "exynos-sysmmu.10",
 		.enable		= &exynos5_clk_ip_isp1_ctrl,
 		.ops		= &exynos5_gate_clk_ops,
 		.ctrlbit	= (0xF << 4),
 	}, {
-		.name		= SYSMMU_CLOCK_NAME,
-		.devname	= SYSMMU_CLOCK_DEVNAME(camif0, 12),
+		.name		= "sysmmu",
+		.devname	= "exynos-sysmmu.11",
+		.enable		= &exynos5_clk_ip_disp1_ctrl,
+		.ctrlbit	= (1 << 8)
+	}, {
+		.name		= "sysmmu",
+		.devname	= "exynos-sysmmu.12",
 		.enable		= &exynos5_clk_ip_gscl_ctrl,
 		.ops		= &exynos5_gate_clk_ops,
 		.ctrlbit	= (1 << 11),
 	}, {
-		.name		= SYSMMU_CLOCK_NAME,
-		.devname	= SYSMMU_CLOCK_DEVNAME(camif1, 13),
+		.name		= "sysmmu",
+		.devname	= "exynos-sysmmu.13",
 		.enable		= &exynos5_clk_ip_gscl_ctrl,
 		.ops		= &exynos5_gate_clk_ops,
 		.ctrlbit	= (1 << 12),
 	}, {
-		.name		= SYSMMU_CLOCK_NAME,
-		.devname	= SYSMMU_CLOCK_DEVNAME(2d, 14),
+		.name		= "sysmmu",
+		.devname	= "exynos-sysmmu.14",
 		.enable		= &exynos5_clk_ip_acp_ctrl,
 		.ops		= &exynos5_gate_clk_ops,
 		.ctrlbit	= (1 << 7)
diff --git a/arch/arm/mach-exynos/dev-sysmmu.c b/arch/arm/mach-exynos/dev-sysmmu.c
deleted file mode 100644
index c5b1ea3..0000000
--- a/arch/arm/mach-exynos/dev-sysmmu.c
+++ /dev/null
@@ -1,274 +0,0 @@
-/* linux/arch/arm/mach-exynos/dev-sysmmu.c
- *
- * Copyright (c) 2010-2012 Samsung Electronics Co., Ltd.
- *		http://www.samsung.com
- *
- * EXYNOS - System MMU support
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/platform_device.h>
-#include <linux/dma-mapping.h>
-
-#include <plat/cpu.h>
-
-#include <mach/map.h>
-#include <mach/irqs.h>
-#include <mach/sysmmu.h>
-
-static u64 exynos_sysmmu_dma_mask = DMA_BIT_MASK(32);
-
-#define SYSMMU_PLATFORM_DEVICE(ipname, devid)				\
-static struct sysmmu_platform_data platdata_##ipname = {		\
-	.dbgname = #ipname,						\
-};									\
-struct platform_device SYSMMU_PLATDEV(ipname) =				\
-{									\
-	.name		= SYSMMU_DEVNAME_BASE,				\
-	.id		= devid,					\
-	.dev		= {						\
-		.dma_mask		= &exynos_sysmmu_dma_mask,	\
-		.coherent_dma_mask	= DMA_BIT_MASK(32),		\
-		.platform_data		= &platdata_##ipname,		\
-	},								\
-}
-
-SYSMMU_PLATFORM_DEVICE(mfc_l,	0);
-SYSMMU_PLATFORM_DEVICE(mfc_r,	1);
-SYSMMU_PLATFORM_DEVICE(tv,	2);
-SYSMMU_PLATFORM_DEVICE(jpeg,	3);
-SYSMMU_PLATFORM_DEVICE(rot,	4);
-SYSMMU_PLATFORM_DEVICE(fimc0,	5); /* fimc* and gsc* exist exclusively */
-SYSMMU_PLATFORM_DEVICE(fimc1,	6);
-SYSMMU_PLATFORM_DEVICE(fimc2,	7);
-SYSMMU_PLATFORM_DEVICE(fimc3,	8);
-SYSMMU_PLATFORM_DEVICE(gsc0,	5);
-SYSMMU_PLATFORM_DEVICE(gsc1,	6);
-SYSMMU_PLATFORM_DEVICE(gsc2,	7);
-SYSMMU_PLATFORM_DEVICE(gsc3,	8);
-SYSMMU_PLATFORM_DEVICE(isp,	9);
-SYSMMU_PLATFORM_DEVICE(fimd0,	10);
-SYSMMU_PLATFORM_DEVICE(fimd1,	11);
-SYSMMU_PLATFORM_DEVICE(camif0,	12);
-SYSMMU_PLATFORM_DEVICE(camif1,	13);
-SYSMMU_PLATFORM_DEVICE(2d,	14);
-
-#define SYSMMU_RESOURCE_NAME(core, ipname) sysmmures_##core##_##ipname
-
-#define SYSMMU_RESOURCE(core, ipname)					\
-	static struct resource SYSMMU_RESOURCE_NAME(core, ipname)[] __initdata =
-
-#define DEFINE_SYSMMU_RESOURCE(core, mem, irq)				\
-	DEFINE_RES_MEM_NAMED(core##_PA_SYSMMU_##mem, SZ_4K, #mem),	\
-	DEFINE_RES_IRQ_NAMED(core##_IRQ_SYSMMU_##irq##_0, #mem)
-
-#define SYSMMU_RESOURCE_DEFINE(core, ipname, mem, irq)			\
-	SYSMMU_RESOURCE(core, ipname) {					\
-		DEFINE_SYSMMU_RESOURCE(core, mem, irq)			\
-	}
-
-struct sysmmu_resource_map {
-	struct platform_device *pdev;
-	struct resource *res;
-	u32 rnum;
-	struct device *pdd;
-	char *clocknames;
-};
-
-#define SYSMMU_RESOURCE_MAPPING(core, ipname, resname) {		\
-	.pdev = &SYSMMU_PLATDEV(ipname),				\
-	.res = SYSMMU_RESOURCE_NAME(EXYNOS##core, resname),		\
-	.rnum = ARRAY_SIZE(SYSMMU_RESOURCE_NAME(EXYNOS##core, resname)),\
-	.clocknames = SYSMMU_CLOCK_NAME,				\
-}
-
-#define SYSMMU_RESOURCE_MAPPING_MC(core, ipname, resname, pdata) {	\
-	.pdev = &SYSMMU_PLATDEV(ipname),				\
-	.res = SYSMMU_RESOURCE_NAME(EXYNOS##core, resname),		\
-	.rnum = ARRAY_SIZE(SYSMMU_RESOURCE_NAME(EXYNOS##core, resname)),\
-	.clocknames = SYSMMU_CLOCK_NAME "," SYSMMU_CLOCK_NAME2,		\
-}
-
-#ifdef CONFIG_EXYNOS_DEV_PD
-#define SYSMMU_RESOURCE_MAPPING_PD(core, ipname, resname, pd) {		\
-	.pdev = &SYSMMU_PLATDEV(ipname),				\
-	.res = &SYSMMU_RESOURCE_NAME(EXYNOS##core, resname),		\
-	.rnum = ARRAY_SIZE(SYSMMU_RESOURCE_NAME(EXYNOS##core, resname)),\
-	.clocknames = SYSMMU_CLOCK_NAME,				\
-	.pdd = &exynos##core##_device_pd[pd].dev,			\
-}
-
-#define SYSMMU_RESOURCE_MAPPING_MCPD(core, ipname, resname, pd, pdata) {\
-	.pdev = &SYSMMU_PLATDEV(ipname),				\
-	.res = &SYSMMU_RESOURCE_NAME(EXYNOS##core, resname),		\
-	.rnum = ARRAY_SIZE(SYSMMU_RESOURCE_NAME(EXYNOS##core, resname)),\
-	.clocknames = SYSMMU_CLOCK_NAME "," SYSMMU_CLOCK_NAME2,		\
-	.pdd = &exynos##core##_device_pd[pd].dev,			\
-}
-#else
-#define SYSMMU_RESOURCE_MAPPING_PD(core, ipname, resname, pd)		\
-		SYSMMU_RESOURCE_MAPPING(core, ipname, resname)
-#define SYSMMU_RESOURCE_MAPPING_MCPD(core, ipname, resname, pd, pdata)	\
-		SYSMMU_RESOURCE_MAPPING_MC(core, ipname, resname, pdata)
-
-#endif /* CONFIG_EXYNOS_DEV_PD */
-
-#ifdef CONFIG_ARCH_EXYNOS4
-SYSMMU_RESOURCE_DEFINE(EXYNOS4, fimc0,	FIMC0,	FIMC0);
-SYSMMU_RESOURCE_DEFINE(EXYNOS4, fimc1,	FIMC1,	FIMC1);
-SYSMMU_RESOURCE_DEFINE(EXYNOS4, fimc2,	FIMC2,	FIMC2);
-SYSMMU_RESOURCE_DEFINE(EXYNOS4, fimc3,	FIMC3,	FIMC3);
-SYSMMU_RESOURCE_DEFINE(EXYNOS4, jpeg,	JPEG,	JPEG);
-SYSMMU_RESOURCE_DEFINE(EXYNOS4, 2d,	G2D,	2D);
-SYSMMU_RESOURCE_DEFINE(EXYNOS4, tv,	TV,	TV_M0);
-SYSMMU_RESOURCE_DEFINE(EXYNOS4, 2d_acp,	2D_ACP,	2D);
-SYSMMU_RESOURCE_DEFINE(EXYNOS4, rot,	ROTATOR, ROTATOR);
-SYSMMU_RESOURCE_DEFINE(EXYNOS4, fimd0,	FIMD0,	LCD0_M0);
-SYSMMU_RESOURCE_DEFINE(EXYNOS4, fimd1,	FIMD1,	LCD1_M1);
-SYSMMU_RESOURCE_DEFINE(EXYNOS4, flite0,	FIMC_LITE0, FIMC_LITE0);
-SYSMMU_RESOURCE_DEFINE(EXYNOS4, flite1,	FIMC_LITE1, FIMC_LITE1);
-SYSMMU_RESOURCE_DEFINE(EXYNOS4, mfc_r,	MFC_R,	MFC_M0);
-SYSMMU_RESOURCE_DEFINE(EXYNOS4, mfc_l,	MFC_L,	MFC_M1);
-SYSMMU_RESOURCE(EXYNOS4, isp) {
-	DEFINE_SYSMMU_RESOURCE(EXYNOS4, FIMC_ISP, FIMC_ISP),
-	DEFINE_SYSMMU_RESOURCE(EXYNOS4, FIMC_DRC, FIMC_DRC),
-	DEFINE_SYSMMU_RESOURCE(EXYNOS4, FIMC_FD, FIMC_FD),
-	DEFINE_SYSMMU_RESOURCE(EXYNOS4, ISPCPU, FIMC_CX),
-};
-
-static struct sysmmu_resource_map sysmmu_resmap4[] __initdata = {
-	SYSMMU_RESOURCE_MAPPING_PD(4, fimc0,	fimc0,	PD_CAM),
-	SYSMMU_RESOURCE_MAPPING_PD(4, fimc1,	fimc1,	PD_CAM),
-	SYSMMU_RESOURCE_MAPPING_PD(4, fimc2,	fimc2,	PD_CAM),
-	SYSMMU_RESOURCE_MAPPING_PD(4, fimc3,	fimc3,	PD_CAM),
-	SYSMMU_RESOURCE_MAPPING_PD(4, tv,	tv,	PD_TV),
-	SYSMMU_RESOURCE_MAPPING_PD(4, mfc_r,	mfc_r,	PD_MFC),
-	SYSMMU_RESOURCE_MAPPING_PD(4, mfc_l,	mfc_l,	PD_MFC),
-	SYSMMU_RESOURCE_MAPPING_PD(4, rot,	rot,	PD_LCD0),
-	SYSMMU_RESOURCE_MAPPING_PD(4, jpeg,	jpeg,	PD_CAM),
-	SYSMMU_RESOURCE_MAPPING_PD(4, fimd0,	fimd0,	PD_LCD0),
-};
-
-static struct sysmmu_resource_map sysmmu_resmap4210[] __initdata = {
-	SYSMMU_RESOURCE_MAPPING_PD(4, 2d,	2d,	PD_LCD0),
-	SYSMMU_RESOURCE_MAPPING_PD(4, fimd1,	fimd1,	PD_LCD1),
-};
-
-static struct sysmmu_resource_map sysmmu_resmap4212[] __initdata = {
-	SYSMMU_RESOURCE_MAPPING(4,	2d,	2d_acp),
-	SYSMMU_RESOURCE_MAPPING_PD(4,	camif0, flite0,	PD_ISP),
-	SYSMMU_RESOURCE_MAPPING_PD(4,	camif1, flite1,	PD_ISP),
-	SYSMMU_RESOURCE_MAPPING_PD(4,	isp,	isp,	PD_ISP),
-};
-#endif /* CONFIG_ARCH_EXYNOS4 */
-
-#ifdef CONFIG_ARCH_EXYNOS5
-SYSMMU_RESOURCE_DEFINE(EXYNOS5, jpeg,	JPEG,	JPEG);
-SYSMMU_RESOURCE_DEFINE(EXYNOS5, fimd1,	FIMD1,	FIMD1);
-SYSMMU_RESOURCE_DEFINE(EXYNOS5, 2d,	2D,	2D);
-SYSMMU_RESOURCE_DEFINE(EXYNOS5, rot,	ROTATOR, ROTATOR);
-SYSMMU_RESOURCE_DEFINE(EXYNOS5, tv,	TV,	TV);
-SYSMMU_RESOURCE_DEFINE(EXYNOS5, flite0,	LITE0,	LITE0);
-SYSMMU_RESOURCE_DEFINE(EXYNOS5, flite1,	LITE1,	LITE1);
-SYSMMU_RESOURCE_DEFINE(EXYNOS5, gsc0,	GSC0,	GSC0);
-SYSMMU_RESOURCE_DEFINE(EXYNOS5, gsc1,	GSC1,	GSC1);
-SYSMMU_RESOURCE_DEFINE(EXYNOS5, gsc2,	GSC2,	GSC2);
-SYSMMU_RESOURCE_DEFINE(EXYNOS5, gsc3,	GSC3,	GSC3);
-SYSMMU_RESOURCE_DEFINE(EXYNOS5, mfc_r,	MFC_R,	MFC_R);
-SYSMMU_RESOURCE_DEFINE(EXYNOS5, mfc_l,	MFC_L,	MFC_L);
-SYSMMU_RESOURCE(EXYNOS5, isp) {
-	DEFINE_SYSMMU_RESOURCE(EXYNOS5, ISP, ISP),
-	DEFINE_SYSMMU_RESOURCE(EXYNOS5, DRC, DRC),
-	DEFINE_SYSMMU_RESOURCE(EXYNOS5, FD, FD),
-	DEFINE_SYSMMU_RESOURCE(EXYNOS5, ISPCPU, MCUISP),
-	DEFINE_SYSMMU_RESOURCE(EXYNOS5, SCALERC, SCALERCISP),
-	DEFINE_SYSMMU_RESOURCE(EXYNOS5, SCALERP, SCALERPISP),
-	DEFINE_SYSMMU_RESOURCE(EXYNOS5,	ODC, ODC),
-	DEFINE_SYSMMU_RESOURCE(EXYNOS5, DIS0, DIS0),
-	DEFINE_SYSMMU_RESOURCE(EXYNOS5, DIS1, DIS1),
-	DEFINE_SYSMMU_RESOURCE(EXYNOS5, 3DNR, 3DNR),
-};
-
-static struct sysmmu_resource_map sysmmu_resmap5[] __initdata = {
-	SYSMMU_RESOURCE_MAPPING(5,	jpeg,	jpeg),
-	SYSMMU_RESOURCE_MAPPING(5,	fimd1,	fimd1),
-	SYSMMU_RESOURCE_MAPPING(5,	2d,	2d),
-	SYSMMU_RESOURCE_MAPPING(5,	rot,	rot),
-	SYSMMU_RESOURCE_MAPPING_PD(5,	tv,	tv,	PD_DISP1),
-	SYSMMU_RESOURCE_MAPPING_PD(5,	camif0,	flite0,	PD_GSCL),
-	SYSMMU_RESOURCE_MAPPING_PD(5,	camif1,	flite1,	PD_GSCL),
-	SYSMMU_RESOURCE_MAPPING_PD(5,	gsc0,	gsc0,	PD_GSCL),
-	SYSMMU_RESOURCE_MAPPING_PD(5,	gsc1,	gsc1,	PD_GSCL),
-	SYSMMU_RESOURCE_MAPPING_PD(5,	gsc2,	gsc2,	PD_GSCL),
-	SYSMMU_RESOURCE_MAPPING_PD(5,	gsc3,	gsc3,	PD_GSCL),
-	SYSMMU_RESOURCE_MAPPING_PD(5,	mfc_r,	mfc_r,	PD_MFC),
-	SYSMMU_RESOURCE_MAPPING_PD(5,	mfc_l,	mfc_l,	PD_MFC),
-	SYSMMU_RESOURCE_MAPPING_MCPD(5,	isp,	isp,	PD_ISP, mc_platdata),
-};
-#endif /* CONFIG_ARCH_EXYNOS5 */
-
-static int __init init_sysmmu_platform_device(void)
-{
-	int i, j;
-	struct sysmmu_resource_map *resmap[2] = {NULL, NULL};
-	int nmap[2] = {0, 0};
-
-#ifdef CONFIG_ARCH_EXYNOS5
-	if (soc_is_exynos5250()) {
-		resmap[0] = sysmmu_resmap5;
-		nmap[0] = ARRAY_SIZE(sysmmu_resmap5);
-		nmap[1] = 0;
-	}
-#endif
-
-#ifdef CONFIG_ARCH_EXYNOS4
-	if (resmap[0] == NULL) {
-		resmap[0] = sysmmu_resmap4;
-		nmap[0] = ARRAY_SIZE(sysmmu_resmap4);
-	}
-
-	if (soc_is_exynos4210()) {
-		resmap[1] = sysmmu_resmap4210;
-		nmap[1] = ARRAY_SIZE(sysmmu_resmap4210);
-	}
-
-	if (soc_is_exynos4412() || soc_is_exynos4212()) {
-		resmap[1] = sysmmu_resmap4212;
-		nmap[1] = ARRAY_SIZE(sysmmu_resmap4212);
-	}
-#endif
-
-	for (j = 0; j < 2; j++) {
-		for (i = 0; i < nmap[j]; i++) {
-			struct sysmmu_resource_map *map;
-			struct sysmmu_platform_data *platdata;
-
-			map = &resmap[j][i];
-
-			map->pdev->dev.parent = map->pdd;
-
-			platdata = map->pdev->dev.platform_data;
-			platdata->clockname = map->clocknames;
-
-			if (platform_device_add_resources(map->pdev, map->res,
-								map->rnum)) {
-				pr_err("%s: Failed to add device resources for "
-						"%s.%d\n", __func__,
-						map->pdev->name, map->pdev->id);
-				continue;
-			}
-
-			if (platform_device_register(map->pdev)) {
-				pr_err("%s: Failed to register %s.%d\n",
-					__func__, map->pdev->name,
-						map->pdev->id);
-			}
-		}
-	}
-
-	return 0;
-}
-arch_initcall(init_sysmmu_platform_device);
diff --git a/arch/arm/mach-exynos/include/mach/sysmmu.h b/arch/arm/mach-exynos/include/mach/sysmmu.h
deleted file mode 100644
index 88a4543..0000000
--- a/arch/arm/mach-exynos/include/mach/sysmmu.h
+++ /dev/null
@@ -1,66 +0,0 @@
-/*
- * Copyright (c) 2011-2012 Samsung Electronics Co., Ltd.
- *		http://www.samsung.com
- *
- * EXYNOS - System MMU support
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef _ARM_MACH_EXYNOS_SYSMMU_H_
-#define _ARM_MACH_EXYNOS_SYSMMU_H_
-
-struct sysmmu_platform_data {
-	char *dbgname;
-	/* comma(,) separated list of clock names for clock gating */
-	char *clockname;
-};
-
-#define SYSMMU_DEVNAME_BASE "exynos-sysmmu"
-
-#define SYSMMU_CLOCK_NAME "sysmmu"
-#define SYSMMU_CLOCK_NAME2 "sysmmu_mc"
-
-#ifdef CONFIG_EXYNOS_DEV_SYSMMU
-#include <linux/device.h>
-struct platform_device;
-
-#define SYSMMU_PLATDEV(ipname) exynos_device_sysmmu_##ipname
-
-extern struct platform_device SYSMMU_PLATDEV(mfc_l);
-extern struct platform_device SYSMMU_PLATDEV(mfc_r);
-extern struct platform_device SYSMMU_PLATDEV(tv);
-extern struct platform_device SYSMMU_PLATDEV(jpeg);
-extern struct platform_device SYSMMU_PLATDEV(rot);
-extern struct platform_device SYSMMU_PLATDEV(fimc0);
-extern struct platform_device SYSMMU_PLATDEV(fimc1);
-extern struct platform_device SYSMMU_PLATDEV(fimc2);
-extern struct platform_device SYSMMU_PLATDEV(fimc3);
-extern struct platform_device SYSMMU_PLATDEV(gsc0);
-extern struct platform_device SYSMMU_PLATDEV(gsc1);
-extern struct platform_device SYSMMU_PLATDEV(gsc2);
-extern struct platform_device SYSMMU_PLATDEV(gsc3);
-extern struct platform_device SYSMMU_PLATDEV(isp);
-extern struct platform_device SYSMMU_PLATDEV(fimd0);
-extern struct platform_device SYSMMU_PLATDEV(fimd1);
-extern struct platform_device SYSMMU_PLATDEV(camif0);
-extern struct platform_device SYSMMU_PLATDEV(camif1);
-extern struct platform_device SYSMMU_PLATDEV(2d);
-
-#ifdef CONFIG_IOMMU_API
-static inline void platform_set_sysmmu(
-				struct device *sysmmu, struct device *dev)
-{
-	dev->archdata.iommu = sysmmu;
-}
-#endif
-
-#else /* !CONFIG_EXYNOS_DEV_SYSMMU */
-#define platform_set_sysmmu(sysmmu, dev) do { } while (0)
-#endif
-
-#define SYSMMU_CLOCK_DEVNAME(ipname, id) (SYSMMU_DEVNAME_BASE "." #id)
-
-#endif /* _ARM_MACH_EXYNOS_SYSMMU_H_ */
diff --git a/arch/arm/mach-exynos/mach-exynos4-dt.c b/arch/arm/mach-exynos/mach-exynos4-dt.c
index 92757ff..ac09af8 100644
--- a/arch/arm/mach-exynos/mach-exynos4-dt.c
+++ b/arch/arm/mach-exynos/mach-exynos4-dt.c
@@ -80,6 +80,40 @@ static const struct of_dev_auxdata exynos4_auxdata_lookup[] __initconst = {
 	OF_DEV_AUXDATA("arm,pl330", EXYNOS4_PA_MDMA1, "dma-pl330.2", NULL),
 	OF_DEV_AUXDATA("samsung,exynos4210-tmu", EXYNOS4_PA_TMU,
 				"exynos-tmu", NULL),
+	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x13620000,
+			"exynos-sysmmu.0", NULL), /* MFC_L */
+	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x13630000,
+			"exynos-sysmmu.1", NULL), /* MFC_R */
+	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x13E20000,
+			"exynos-sysmmu.2", NULL), /* TV */
+	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x11A60000,
+			"exynos-sysmmu.3", NULL), /* JPEG */
+	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x12A30000,
+			"exynos-sysmmu.4", NULL), /* ROTATOR */
+	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x11A20000,
+			"exynos-sysmmu.5", NULL), /* FIMC0 */
+	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x11A30000,
+			"exynos-sysmmu.6", NULL), /* FIMC1 */
+	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x11A40000,
+			"exynos-sysmmu.7", NULL), /* FIMC2 */
+	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x11A50000,
+			"exynos-sysmmu.8", NULL), /* FIMC3 */
+	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x12A20000,
+			"exynos-sysmmu.9", NULL), /* G2D(4210) */
+	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x10A40000,
+			"exynos-sysmmu.9", NULL), /* G2D(4x12) */
+	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x11E20000,
+			"exynos-sysmmu.10", NULL), /* FIMD0 */
+	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x12220000,
+			"exynos-sysmmu.11", NULL), /* FIMD1(4210) */
+	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x12260000,
+			"exynos-sysmmu.12", NULL), /* IS0(4x12) */
+	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x122B0000,
+			"exynos-sysmmu.13", NULL), /* IS1(4x12) */
+	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x123B0000,
+			"exynos-sysmmu.14", NULL), /* FIMC-LITE0(4x12) */
+	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x123C0000,
+			"exynos-sysmmu.15", NULL), /* FIMC-LITE1(4x12) */
 	{},
 };
 
diff --git a/arch/arm/mach-exynos/mach-exynos5-dt.c b/arch/arm/mach-exynos/mach-exynos5-dt.c
index e99d3d8..2671075 100644
--- a/arch/arm/mach-exynos/mach-exynos5-dt.c
+++ b/arch/arm/mach-exynos/mach-exynos5-dt.c
@@ -104,6 +104,36 @@ static const struct of_dev_auxdata exynos5250_auxdata_lookup[] __initconst = {
 	OF_DEV_AUXDATA("samsung,mfc-v6", 0x11000000, "s5p-mfc-v6", NULL),
 	OF_DEV_AUXDATA("samsung,exynos5250-tmu", 0x10060000,
 				"exynos-tmu", NULL),
+	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x11210000,
+			"exynos-sysmmu.0", "mfc"), /* MFC_L */
+	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x11200000,
+			"exynos-sysmmu.1", "mfc"), /* MFC_R */
+	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x14650000,
+			"exynos-sysmmu.2", NULL), /* TV */
+	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x11F20000,
+			"exynos-sysmmu.3", "jpeg"), /* JPEG */
+	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x11D40000,
+			"exynos-sysmmu.4", NULL), /* ROTATOR */
+	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x13E80000,
+			"exynos-sysmmu.5", "gscl"), /* GSCL0 */
+	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x13E90000,
+			"exynos-sysmmu.6", "gscl"), /* GSCL1 */
+	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x13EA0000,
+			"exynos-sysmmu.7", "gscl"), /* GSCL2 */
+	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x13EB0000,
+			"exynos-sysmmu.8", "gscl"), /* GSCL3 */
+	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x13260000,
+			"exynos-sysmmu.9", NULL), /* FIMC-IS0 */
+	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x132C0000,
+			"exynos-sysmmu.10", NULL), /* FIMC-IS1 */
+	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x14640000,
+			"exynos-sysmmu.11", NULL), /* FIMD1 */
+	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x13C40000,
+			"exynos-sysmmu.12", NULL), /* FIMC-LITE0 */
+	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x13C50000,
+			"exynos-sysmmu.13", NULL), /* FIMC-LITE1 */
+	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x10A60000,
+			"exynos-sysmmu.14", NULL), /* G2D */
 	{},
 };
 
-- 
1.8.0



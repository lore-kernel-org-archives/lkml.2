Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757728Ab3AIMAj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 07:00:39 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:60017 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757475Ab3AIMAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 07:00:37 -0500
X-AuditID: cbfee61b-b7f616d00000319b-d3-50ed5be4dcde
From: Abhilash Kesavan <a.kesavan@samsung.com>
To: myungjoo.ham@samsung.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, kgene.kim@samsung.com
Cc: kyungmin.park@samsung.com, rjw@sisk.pl, jhbird.choi@samsung.com,
        Abhilash Kesavan <a.kesavan@samsung.com>
Subject: [PATCH 2/4] ARM: EXYNOS5: Support Exynos5-bus devfreq driver
Date: Wed, 09 Jan 2013 17:36:37 +0530
Message-id: <1357733199-17206-2-git-send-email-a.kesavan@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1357733199-17206-1-git-send-email-a.kesavan@samsung.com>
References: <1357733199-17206-1-git-send-email-a.kesavan@samsung.com>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsWyRsSkSvdJ9NsAg+mruS0u75rDZvG59wij
	A5PH501yAYxRXDYpqTmZZalF+nYJXBl71n5hLjjnWHHx9g7GBsaF5l2MnBwSAiYSCw7sY4aw
	xSQu3FvP1sXIxSEksJRR4vSkk6wwRRf6tzNDJKYzSkzePxmqqo9JYv7Di2BVbAJ6Egv+fQUb
	JSKQKzFz5hwWEJtZIF/i66SlbCC2sICrxLK/f8BqWARUJZYfe8IOYvMCxSesuMfUxcgBtE1B
	Ys4kG5Awp4CbxJQvaxlBbCGgkqNzzrJDtApIfJt8iAWiXFZi0wGw2yQEbrNJzNm9BuobSYmD
	K26wTGAUXsDIsIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjMBhP/3smvYNxVYPFIUYBDkYl
	Hl5Gz7cBQqyJZcWVuYcYJTiYlUR4g32BQrwpiZVVqUX58UWlOanFhxh9gC6ZyCwlmpwPjJS8
	knhDYxNzU2NTSyMjM1NTHMJK4ryMp54ECAmkJ5akZqemFqQWwYxj4uCUamBsjNe5yZFbw77h
	qF/642uVUiIpawwnLuXzWXzCmlvG2Jq750MI78pMncxZQoWdEtxpeadceErWZ/+ykK3w+eLZ
	2x4h++jEBhcJ9mNbnm1feOAQK4/8gfe1uTzRkz5eSlRakeMSqvBU6uOmoqOHdENjRabJL9Qo
	XuT82GJLe5r4gv8+4i0LeJVYijMSDbWYi4oTAZ2sIt5zAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42I5/e+xoO7j6LcBBr/2Glpc3jWHzeJz7xFG
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJaxgz9qz9wlxwzrHi
	4u0djA2MC827GDk5JARMJC70b2eGsMUkLtxbz9bFyMUhJDCdUWLy/slQTh+TxPyHF1lBqtgE
	9CQW/PsK1iEikCsxc+YcFhCbWSBf4uukpWwgtrCAq8Syv3/AalgEVCWWH3vCDmLzAsUnrLjH
	1MXIAbRNQWLOJBuQMKeAm8SUL2sZQWwhoJKjc86yT2DkXcDIsIpRNLUguaA4KT3XSK84Mbe4
	NC9dLzk/dxMjONSfSe9gXNVgcYhRgINRiYeX0fNtgBBrYllxZe4hRgkOZiUR3mBfoBBvSmJl
	VWpRfnxRaU5q8SFGH6CjJjJLiSbnA+MwryTe0NjE3NTY1NLEwsTMEoewkjgv46knAUIC6Ykl
	qdmpqQWpRTDjmDg4pRoYZ7c8fKvmMusQZ3HmvNXdDFfmvjRdkLNV9MPsO2Y7XqcqfOwXit4u
	GT+n6pjwzKhvB+c7aTyaJnjka+QujS7fyfseRP27uCcpjn95t9ht9uzib36um9d7xLdEr6nY
	xPDi/C2jpqZ72gWGu7f/PnVSJ21bjmep99uG8p+T1vQvj1hs6Lt4s3GngRJLcUaioRZzUXEi
	AK1jXCWiAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setup the INT clock ops to control/vary INT frequency

Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
Cc: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>
---
 arch/arm/mach-exynos/clock-exynos5.c           |  143 ++++++++++++++++++++++++
 arch/arm/mach-exynos/include/mach/regs-clock.h |   37 ++++++
 2 files changed, 180 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-exynos/clock-exynos5.c b/arch/arm/mach-exynos/clock-exynos5.c
index 0208c3a..050879c 100644
--- a/arch/arm/mach-exynos/clock-exynos5.c
+++ b/arch/arm/mach-exynos/clock-exynos5.c
@@ -108,6 +108,11 @@ static struct clk exynos5_clk_sclk_usbphy = {
 	.rate		= 48000000,
 };
 
+/* Virtual Bus INT clock */
+static struct clk exynos5_int_clk = {
+	.name		= "int_clk",
+};
+
 static int exynos5_clksrc_mask_top_ctrl(struct clk *clk, int enable)
 {
 	return s5p_gatectrl(EXYNOS5_CLKSRC_MASK_TOP, clk, enable);
@@ -1426,6 +1431,141 @@ static struct clk *exynos5_clks[] __initdata = {
 	&clk_fout_cpll,
 	&clk_fout_mpll_div2,
 	&exynos5_clk_armclk,
+	&exynos5_int_clk,
+};
+
+#define INT_FREQ(f, a0, a1, a2, a3, a4, a5, b0, b1, b2, b3, \
+			c0, c1, d0, e0) \
+	{ \
+		.freq = (f) * 1000000, \
+		.clk_div_top0 = ((a0) << 0 | (a1) << 8 | (a2) << 12 | \
+				(a3) << 16 | (a4) << 20 | (a5) << 28), \
+		.clk_div_top1 = ((b0) << 12 | (b1) << 16 | (b2) << 20 | \
+				(b3) << 24), \
+		.clk_div_lex = ((c0) << 4 | (c1) << 8), \
+		.clk_div_r0x = ((d0) << 4), \
+		.clk_div_r1x = ((e0) << 4), \
+	}
+
+static struct {
+	unsigned long freq;
+	u32 clk_div_top0;
+	u32 clk_div_top1;
+	u32 clk_div_lex;
+	u32 clk_div_r0x;
+	u32 clk_div_r1x;
+} int_freq[] = {
+	/*
+	 * values:
+	 * freq
+	 * clock divider for ACLK66, ACLK166, ACLK200, ACLK266,
+			ACLK333, ACLK300_DISP1
+	 * clock divider for ACLK300_GSCL, ACLK400_IOP, ACLK400_ISP, ACLK66_PRE
+	 * clock divider for PCLK_LEX, ATCLK_LEX
+	 * clock divider for ACLK_PR0X
+	 * clock divider for ACLK_PR1X
+	 */
+	INT_FREQ(266, 1, 1, 3, 2, 0, 0, 0, 1, 1, 5, 1, 0, 1, 1),
+	INT_FREQ(200, 1, 2, 4, 3, 1, 0, 0, 3, 2, 5, 1, 0, 1, 1),
+	INT_FREQ(160, 1, 3, 4, 4, 2, 0, 0, 3, 3, 5, 1, 0, 1, 1),
+	INT_FREQ(133, 1, 3, 5, 5, 2, 1, 1, 4, 4, 5, 1, 0, 1, 1),
+	INT_FREQ(100, 1, 7, 7, 7, 7, 3, 7, 7, 7, 5, 1, 0, 1, 1),
+};
+
+static unsigned long exynos5_clk_int_get_rate(struct clk *clk)
+{
+	return clk->rate;
+}
+
+static void exynos5_int_set_clkdiv(unsigned int div_index)
+{
+	unsigned int tmp;
+
+	/* Change Divider - TOP0 */
+	tmp = __raw_readl(EXYNOS5_CLKDIV_TOP0);
+
+	tmp &= ~(EXYNOS5_CLKDIV_TOP0_ACLK266_MASK |
+		EXYNOS5_CLKDIV_TOP0_ACLK200_MASK |
+		EXYNOS5_CLKDIV_TOP0_ACLK66_MASK |
+		EXYNOS5_CLKDIV_TOP0_ACLK333_MASK |
+		EXYNOS5_CLKDIV_TOP0_ACLK166_MASK |
+		EXYNOS5_CLKDIV_TOP0_ACLK300_DISP1_MASK);
+
+	tmp |= int_freq[div_index].clk_div_top0;
+
+	__raw_writel(tmp, EXYNOS5_CLKDIV_TOP0);
+
+	/* Wait for TOP0 divider to stabilize */
+	while (__raw_readl(EXYNOS5_CLKDIV_STAT_TOP0) & 0x151101)
+		cpu_relax();
+
+	/* Change Divider - TOP1 */
+	tmp = __raw_readl(EXYNOS5_CLKDIV_TOP1);
+
+	tmp &= ~(EXYNOS5_CLKDIV_TOP1_ACLK400_ISP_MASK |
+		EXYNOS5_CLKDIV_TOP1_ACLK400_IOP_MASK |
+		EXYNOS5_CLKDIV_TOP1_ACLK66_PRE_MASK |
+		EXYNOS5_CLKDIV_TOP1_ACLK300_GSCL_MASK);
+
+	tmp |= int_freq[div_index].clk_div_top1;
+
+	__raw_writel(tmp, EXYNOS5_CLKDIV_TOP1);
+
+	/* Wait for TOP0 and TOP1 dividers to stabilize */
+	while ((__raw_readl(EXYNOS5_CLKDIV_STAT_TOP1) & 0x1110000) &&
+		(__raw_readl(EXYNOS5_CLKDIV_STAT_TOP0) & 0x80000))
+		cpu_relax();
+
+	/* Change Divider - LEX */
+	tmp = int_freq[div_index].clk_div_lex;
+
+	__raw_writel(tmp, EXYNOS5_CLKDIV_LEX);
+
+	/* Wait for LEX divider to stabilize */
+	while (__raw_readl(EXYNOS5_CLKDIV_STAT_LEX) & 0x110)
+		cpu_relax();
+
+	/* Change Divider - R0X */
+	tmp = int_freq[div_index].clk_div_r0x;
+
+	__raw_writel(tmp, EXYNOS5_CLKDIV_R0X);
+
+	/* Wait for R0X divider to stabilize */
+	while (__raw_readl(EXYNOS5_CLKDIV_STAT_R0X) & 0x10)
+		cpu_relax();
+
+	/* Change Divider - R1X */
+	tmp = int_freq[div_index].clk_div_r1x;
+
+	__raw_writel(tmp, EXYNOS5_CLKDIV_R1X);
+
+	/* Wait for R1X divider to stabilize */
+	while (__raw_readl(EXYNOS5_CLKDIV_STAT_R1X) & 0x10)
+		cpu_relax();
+}
+
+static int exynos5_clk_int_set_rate(struct clk *clk, unsigned long rate)
+{
+	int index;
+
+	for (index = 0; index < ARRAY_SIZE(int_freq); index++)
+		if (int_freq[index].freq == rate)
+			break;
+
+	if (index == ARRAY_SIZE(int_freq))
+		return -EINVAL;
+
+	/* Change the system clock divider values */
+	exynos5_int_set_clkdiv(index);
+
+	clk->rate = rate;
+
+	return 0;
+}
+
+static struct clk_ops exynos5_clk_int_ops = {
+	.get_rate = exynos5_clk_int_get_rate,
+	.set_rate = exynos5_clk_int_set_rate
 };
 
 static u32 epll_div[][6] = {
@@ -1620,6 +1760,9 @@ void __init_or_cpufreq exynos5_setup_clocks(void)
 
 	clk_fout_epll.ops = &exynos5_epll_ops;
 
+	exynos5_int_clk.ops = &exynos5_clk_int_ops;
+	exynos5_int_clk.rate = aclk_266;
+
 	if (clk_set_parent(&exynos5_clk_mout_epll.clk, &clk_fout_epll))
 		printk(KERN_ERR "Unable to set parent %s of clock %s.\n",
 				clk_fout_epll.name, exynos5_clk_mout_epll.clk.name);
diff --git a/arch/arm/mach-exynos/include/mach/regs-clock.h b/arch/arm/mach-exynos/include/mach/regs-clock.h
index d36ad76..3d3cbc8 100644
--- a/arch/arm/mach-exynos/include/mach/regs-clock.h
+++ b/arch/arm/mach-exynos/include/mach/regs-clock.h
@@ -323,6 +323,9 @@
 #define EXYNOS5_CLKDIV_PERIC5			EXYNOS_CLKREG(0x1056C)
 #define EXYNOS5_SCLK_DIV_ISP			EXYNOS_CLKREG(0x10580)
 
+#define EXYNOS5_CLKDIV_STAT_TOP0		EXYNOS_CLKREG(0x10610)
+#define EXYNOS5_CLKDIV_STAT_TOP1		EXYNOS_CLKREG(0x10614)
+
 #define EXYNOS5_CLKGATE_IP_ACP			EXYNOS_CLKREG(0x08800)
 #define EXYNOS5_CLKGATE_IP_ISP0			EXYNOS_CLKREG(0x0C800)
 #define EXYNOS5_CLKGATE_IP_ISP1			EXYNOS_CLKREG(0x0C804)
@@ -337,6 +340,18 @@
 #define EXYNOS5_CLKGATE_IP_PERIS		EXYNOS_CLKREG(0x10960)
 #define EXYNOS5_CLKGATE_BLOCK			EXYNOS_CLKREG(0x10980)
 
+#define EXYNOS5_CLKGATE_BUS_SYSLFT		EXYNOS_CLKREG(0x08920)
+
+#define EXYNOS5_CLKOUT_CMU_TOP			EXYNOS_CLKREG(0x10A00)
+
+#define EXYNOS5_CLKDIV_LEX			EXYNOS_CLKREG(0x14500)
+#define EXYNOS5_CLKDIV_STAT_LEX			EXYNOS_CLKREG(0x14600)
+
+#define EXYNOS5_CLKDIV_R0X			EXYNOS_CLKREG(0x18500)
+#define EXYNOS5_CLKDIV_STAT_R0X			EXYNOS_CLKREG(0x18600)
+
+#define EXYNOS5_CLKDIV_R1X			EXYNOS_CLKREG(0x1C500)
+#define EXYNOS5_CLKDIV_STAT_R1X			EXYNOS_CLKREG(0x1C600)
 #define EXYNOS5_BPLL_CON0			EXYNOS_CLKREG(0x20110)
 #define EXYNOS5_CLKSRC_CDREX			EXYNOS_CLKREG(0x20200)
 #define EXYNOS5_CLKDIV_CDREX			EXYNOS_CLKREG(0x20500)
@@ -347,6 +362,28 @@
 
 #define EXYNOS5_EPLLCON0_LOCKED_SHIFT		(29)
 
+#define EXYNOS5_CLKDIV_TOP0_ACLK300_DISP1_SHIFT	(28)
+#define EXYNOS5_CLKDIV_TOP0_ACLK300_DISP1_MASK	(0x7 << EXYNOS5_CLKDIV_TOP0_ACLK300_DISP1_SHIFT)
+#define EXYNOS5_CLKDIV_TOP0_ACLK333_SHIFT	(20)
+#define EXYNOS5_CLKDIV_TOP0_ACLK333_MASK	(0x7 << EXYNOS5_CLKDIV_TOP0_ACLK333_SHIFT)
+#define EXYNOS5_CLKDIV_TOP0_ACLK266_SHIFT	(16)
+#define EXYNOS5_CLKDIV_TOP0_ACLK266_MASK	(0x7 << EXYNOS5_CLKDIV_TOP0_ACLK266_SHIFT)
+#define EXYNOS5_CLKDIV_TOP0_ACLK200_SHIFT	(12)
+#define EXYNOS5_CLKDIV_TOP0_ACLK200_MASK	(0x7 << EXYNOS5_CLKDIV_TOP0_ACLK200_SHIFT)
+#define EXYNOS5_CLKDIV_TOP0_ACLK166_SHIFT	(8)
+#define EXYNOS5_CLKDIV_TOP0_ACLK166_MASK	(0x7 << EXYNOS5_CLKDIV_TOP0_ACLK166_SHIFT)
+#define EXYNOS5_CLKDIV_TOP0_ACLK66_SHIFT	(0)
+#define EXYNOS5_CLKDIV_TOP0_ACLK66_MASK		(0x7 << EXYNOS5_CLKDIV_TOP0_ACLK66_SHIFT)
+
+#define EXYNOS5_CLKDIV_TOP1_ACLK66_PRE_SHIFT	(24)
+#define EXYNOS5_CLKDIV_TOP1_ACLK66_PRE_MASK	(0x7 << EXYNOS5_CLKDIV_TOP1_ACLK66_PRE_SHIFT)
+#define EXYNOS5_CLKDIV_TOP1_ACLK400_ISP_SHIFT	(20)
+#define EXYNOS5_CLKDIV_TOP1_ACLK400_ISP_MASK	(0x7 << EXYNOS5_CLKDIV_TOP1_ACLK400_ISP_SHIFT)
+#define EXYNOS5_CLKDIV_TOP1_ACLK400_IOP_SHIFT	(16)
+#define EXYNOS5_CLKDIV_TOP1_ACLK400_IOP_MASK	(0x7 << EXYNOS5_CLKDIV_TOP1_ACLK400_IOP_SHIFT)
+#define EXYNOS5_CLKDIV_TOP1_ACLK300_GSCL_SHIFT	(12)
+#define EXYNOS5_CLKDIV_TOP1_ACLK300_GSCL_MASK	(0x7 << EXYNOS5_CLKDIV_TOP1_ACLK300_GSCL_SHIFT)
+
 #define PWR_CTRL1_CORE2_DOWN_RATIO		(7 << 28)
 #define PWR_CTRL1_CORE1_DOWN_RATIO		(7 << 16)
 #define PWR_CTRL1_DIV2_DOWN_EN			(1 << 9)
-- 
1.7.8.6


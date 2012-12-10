Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439Ab2LJX7I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 18:59:08 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:38429 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab2LJX7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 18:59:03 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-d0-50c6774401e2
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Abhilash Kesavan'" <a.kesavan@samsung.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, kgene.kim@samsung.com
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com, rjw@sisk.pl
References: <1355141166-17205-1-git-send-email-a.kesavan@samsung.com>
In-reply-to: <1355141166-17205-1-git-send-email-a.kesavan@samsung.com>
Subject: RE: [RFC PATCH] ARM: EXYNOS5: Support Exynos5-bus devfreq driver
Date: Tue, 11 Dec 2012 08:59:00 +0900
Message-id: <001701cdd732$53119410$f934bc30$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3WzgUNCi7DMDEUSG+cmPtZ+hKr3QAY1TtQ
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t8zY12X8mMBBk1PzCwu75rDZvG59wij
	A5PH501yAYxRXDYpqTmZZalF+nYJXBmdndOYC94VVbzZfYatgfFxbBcjJ4eEgInE5nX/mCFs
	MYkL99azdTFycQgJLGOUWHr7IlCCA6xo0xFJiPgiRonzHUeYIZy/jBJ9lxezgHSzCehKHFu/
	hRXEFhGol7h3azeYzSzgItEw+Q07iC0k4CrR+eIvI4jNKeAmsfr+czBbWMBT4vvLbjYQm0VA
	VWLFq9NgcV4BO4m9fz5D2YISPybfY4GYqSWxeVsT1Hx5ic1r3kIdqi7x6K8uiCkiYCQxfWoC
	RIWIxL4X7xghpgtIfJt8iAWiWlZi0wGo15exS7zergRhS0ocXHGDZQKjxCwke2ch2TsLyd5Z
	SDYsYGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iRESX1I7GFc2WBxiFOBgVOLh1dA6FiDE
	mlhWXJl7iFGCg1lJhLc0FyjEm5JYWZValB9fVJqTWnyI0Qfo8InMUqLJ+cDYzyuJNzQ2NjEz
	MTUxtzQ1N8UhrCTO2+yREiAkkJ5YkpqdmlqQWgQzjomDU6qB0fbV55DVpp7Heh9ZX8n9vXNq
	6s8//Wev9Bz05DM8rJwQGJ32dUoxU5vo79QLslUfFz9kETvt532akenO58tuNi6GbIZiE2ax
	nlOa0ThfZGtoue3to8ulnhs4bT0Uq94Q+GUrw4qlodprjz649lno1pKSe0dfXrha6HaY6diS
	qPo3r22SvWOso5VYijMSDbWYi4oTAY1kxxXcAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t9jAV2X8mMBBms2Glhc3jWHzeJz7xFG
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzOjunMRe8K6p4
	s/sMWwPj49guRg4OCQETiU1HJLsYOYFMMYkL99azdTFycQgJLGKUON9xhBnC+cso0Xd5MQtI
	FZuArsSx9VtYQWwRgXqJe7d2g9nMAi4SDZPfsIPYQgKuEp0v/jKC2JwCbhKr7z8Hs4UFPCW+
	v+xmA7FZBFQlVrw6DRbnFbCT2PvnM5QtKPFj8j0WiJlaEpu3NUHNl5fYvOYtM8TR6hKP/uqC
	mCICRhLTpyZAVIhI7HvxjnECo9AsJINmIRk0C8mgWUhaFjCyrGIUTS1ILihOSs811CtOzC0u
	zUvXS87P3cQIjt9nUjsYVzZYHGIU4GBU4uHV0DoWIMSaWFZcmXuIUYKDWUmEtzQXKMSbklhZ
	lVqUH19UmpNafIjRB+jPicxSosn5wNSSVxJvaGxiZmRpZGZhZGJujkNYSZy32SMlQEggPbEk
	NTs1tSC1CGYcEwenVANjVvmZKdect8WabPgyy+2AVufGqLf8yo9bw6VFqr5sufb5SczMqnNO
	e1y+TNptWZbUsfgtg1+ZwDulQwLTbqRNmv2U5++G69vztr2YvO9FMoNqwO01h/fe0eoPvH+j
	4zKDq97jNsEzSY9m9C3u99jWoV3FFXhti3iwQ+aUqZ7GuoUJelfE/6wrU2Ipzkg01GIuKk4E
	ABUFLGEMAwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Abhilash Kesavan.


> +	/* Change Divider - LEX */
> +	tmp = __raw_readl(EXYNOS5_CLKDIV_LEX);
> +
> +	tmp &= ~(EXYNOS5_CLKDIV_LEX_ATCLK_LEX_MASK |
> +		EXYNOS5_CLKDIV_LEX_PCLK_LEX_MASK);
> +
> +	tmp |= int_freq[div_index].clk_div_lex;
> +
> +	__raw_writel(tmp, EXYNOS5_CLKDIV_LEX);
> +

I knew that only ATCLK_LEX & PCLK_LEX divider value are in CLKDIV_LEX
register. (Others are reserved and value is 0)
So, I think 
"
tmp = int_freq[div_index].clk_div_lex;
__raw_writel(tmp, EXYNOS5_CLKDIV_LEX);
"
Is enough.

> +	tmp = __raw_readl(EXYNOS5_CLKDIV_LEX);
> +
> +	tmp &= ~(EXYNOS5_CLKDIV_LEX_ATCLK_LEX_MASK |
> +		EXYNOS5_CLKDIV_LEX_PCLK_LEX_MASK);
-> not need.



> +	while (__raw_readl(EXYNOS5_CLKDIV_STAT_LEX) & 0x110)
> +		cpu_relax();
> +
> +	/* Change Divider - R0X */
> +	tmp = __raw_readl(EXYNOS5_CLKDIV_R0X);
> +
> +	tmp &= ~EXYNOS5_CLKDIV_R0X_PCLK_R0X_MASK;
> +
> +	tmp |= int_freq[div_index].clk_div_r0x;
> +
> +	__raw_writel(tmp, EXYNOS5_CLKDIV_R0X);
> +

Same here


> +	while (__raw_readl(EXYNOS5_CLKDIV_STAT_R0X) & 0x10)
> +		cpu_relax();
> +
> +	/* Change Divider - R1X */
> +	tmp = __raw_readl(EXYNOS5_CLKDIV_R1X);
> +
> +	tmp &= ~EXYNOS5_CLKDIV_R1X_PCLK_R1X_MASK;
> +
> +	tmp |= int_freq[div_index].clk_div_r1x;
> +
> +	__raw_writel(tmp, EXYNOS5_CLKDIV_R1X);
> +

Same here

> +	while (__raw_readl(EXYNOS5_CLKDIV_STAT_R1X) & 0x10)
> +		cpu_relax();

How about your opinion?

thanks



> -----Original Message-----
> From: Abhilash Kesavan [mailto:a.kesavan@samsung.com]
> Sent: Monday, December 10, 2012 9:06 PM
> To: linux-kernel@vger.kernel.org; linux-pm@vger.kernel.org;
> kgene.kim@samsung.com
> Cc: myungjoo.ham@samsung.com; kyungmin.park@samsung.com; rjw@sisk.pl;
> jhbird.choi@samsung.com; Abhilash Kesavan
> Subject: [RFC PATCH] ARM: EXYNOS5: Support Exynos5-bus devfreq driver
> 
> - Setup the INT clock ops to control/vary INT frequency
> - Add mappings initially for the PPMU device
> 
> Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
> ---
> Corresponding devfreq driver support for Exynos5 has been posted at:
> https://patchwork.kernel.org/patch/1823931/
> 
> Tested after merging for-rafael branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/mzx/devfreq.git
> with for-next branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
> 
>  arch/arm/mach-exynos/clock-exynos5.c           |  151
> ++++++++++++++++++++++++
>  arch/arm/mach-exynos/common.c                  |   25 ++++
>  arch/arm/mach-exynos/include/mach/map.h        |    6 +
>  arch/arm/mach-exynos/include/mach/regs-clock.h |   48 ++++++++
>  arch/arm/plat-samsung/include/plat/map-s5p.h   |    6 +
>  5 files changed, 236 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-exynos/clock-exynos5.c b/arch/arm/mach-
> exynos/clock-exynos5.c
> index 5c63bc7..f00b259 100644
> --- a/arch/arm/mach-exynos/clock-exynos5.c
> +++ b/arch/arm/mach-exynos/clock-exynos5.c
> @@ -109,6 +109,11 @@ static struct clk exynos5_clk_sclk_usbphy = {
>  	.rate		= 48000000,
>  };
> 
> +/* Virtual Bus INT clock */
> +static struct clk exynos5_int_clk = {
> +	.name		= "int_clk",
> +};
> +
>  static int exynos5_clksrc_mask_top_ctrl(struct clk *clk, int enable)
>  {
>  	return s5p_gatectrl(EXYNOS5_CLKSRC_MASK_TOP, clk, enable);
> @@ -1519,6 +1524,149 @@ static struct clk *exynos5_clks[] __initdata = {
>  	&clk_fout_cpll,
>  	&clk_fout_mpll_div2,
>  	&exynos5_clk_armclk,
> +	&exynos5_int_clk,
> +};
> +
> +#define INT_FREQ(f, a0, a1, a2, a3, a4, a5, b0, b1, b2, b3, \
> +			c0, c1, d0, e0) \
> +	{ \
> +		.freq = (f) * 1000000, \
> +		.clk_div_top0 = ((a0) << 0 | (a1) << 8 | (a2) << 12 | \
> +				(a3) << 16 | (a4) << 20 | (a5) << 28), \
> +		.clk_div_top1 = ((b0) << 12 | (b1) << 16 | (b2) << 20 | \
> +				(b3) << 24), \
> +		.clk_div_lex = ((c0) << 4 | (c1) << 8), \
> +		.clk_div_r0x = ((d0) << 4), \
> +		.clk_div_r1x = ((e0) << 4), \
> +	}
> +
> +static struct {
> +	unsigned long freq;
> +	u32 clk_div_top0;
> +	u32 clk_div_top1;
> +	u32 clk_div_lex;
> +	u32 clk_div_r0x;
> +	u32 clk_div_r1x;
> +} int_freq[] = {
> +	/*
> +	 * values:
> +	 * freq
> +	 * clock divider for ACLK66, ACLK166, ACLK200, ACLK266,
> +			ACLK333, ACLK300_DISP1
> +	 * clock divider for ACLK300_GSCL, ACLK400_IOP, ACLK400_ISP,
> ACLK66_PRE
> +	 * clock divider for PCLK_LEX, ATCLK_LEX
> +	 * clock divider for ACLK_PR0X
> +	 * clock divider for ACLK_PR1X
> +	 */
> +	INT_FREQ(266, 1, 1, 3, 2, 0, 0, 0, 1, 1, 5, 1, 0, 1, 1),
> +	INT_FREQ(200, 1, 2, 4, 3, 1, 0, 0, 3, 2, 5, 1, 0, 1, 1),
> +	INT_FREQ(160, 1, 3, 4, 4, 2, 0, 0, 3, 3, 5, 1, 0, 1, 1),
> +	INT_FREQ(133, 1, 3, 5, 5, 2, 1, 1, 4, 4, 5, 1, 0, 1, 1),
> +	INT_FREQ(100, 1, 7, 7, 7, 7, 3, 7, 7, 7, 5, 1, 0, 1, 1),
> +};
> +
> +static unsigned long exynos5_clk_int_get_rate(struct clk *clk)
> +{
> +	return clk->rate;
> +}
> +
> +static void exynos5_int_set_clkdiv(unsigned int div_index)
> +{
> +	unsigned int tmp;
> +
> +	/* Change Divider - TOP0 */
> +	tmp = __raw_readl(EXYNOS5_CLKDIV_TOP0);
> +
> +	tmp &= ~(EXYNOS5_CLKDIV_TOP0_ACLK266_MASK |
> +		EXYNOS5_CLKDIV_TOP0_ACLK200_MASK |
> +		EXYNOS5_CLKDIV_TOP0_ACLK66_MASK |
> +		EXYNOS5_CLKDIV_TOP0_ACLK333_MASK |
> +		EXYNOS5_CLKDIV_TOP0_ACLK166_MASK |
> +		EXYNOS5_CLKDIV_TOP0_ACLK300_DISP1_MASK);
> +
> +	tmp |= int_freq[div_index].clk_div_top0;
> +
> +	__raw_writel(tmp, EXYNOS5_CLKDIV_TOP0);
> +
> +	while (__raw_readl(EXYNOS5_CLKDIV_STAT_TOP0) & 0x151101)
> +		cpu_relax();
> +
> +	/* Change Divider - TOP1 */
> +	tmp = __raw_readl(EXYNOS5_CLKDIV_TOP1);
> +
> +	tmp &= ~(EXYNOS5_CLKDIV_TOP1_ACLK400_ISP_MASK |
> +		EXYNOS5_CLKDIV_TOP1_ACLK400_IOP_MASK |
> +		EXYNOS5_CLKDIV_TOP1_ACLK66_PRE_MASK |
> +		EXYNOS5_CLKDIV_TOP1_ACLK300_GSCL_MASK);
> +
> +	tmp |= int_freq[div_index].clk_div_top1;
> +
> +	__raw_writel(tmp, EXYNOS5_CLKDIV_TOP1);
> +
> +	while ((__raw_readl(EXYNOS5_CLKDIV_STAT_TOP1) & 0x1110000) &&
> +		(__raw_readl(EXYNOS5_CLKDIV_STAT_TOP0) & 0x80000))
> +		cpu_relax();
> +
> +	/* Change Divider - LEX */
> +	tmp = __raw_readl(EXYNOS5_CLKDIV_LEX);
> +
> +	tmp &= ~(EXYNOS5_CLKDIV_LEX_ATCLK_LEX_MASK |
> +		EXYNOS5_CLKDIV_LEX_PCLK_LEX_MASK);
> +
> +	tmp |= int_freq[div_index].clk_div_lex;
> +
> +	__raw_writel(tmp, EXYNOS5_CLKDIV_LEX);
> +
> +	while (__raw_readl(EXYNOS5_CLKDIV_STAT_LEX) & 0x110)
> +		cpu_relax();
> +
> +	/* Change Divider - R0X */
> +	tmp = __raw_readl(EXYNOS5_CLKDIV_R0X);
> +
> +	tmp &= ~EXYNOS5_CLKDIV_R0X_PCLK_R0X_MASK;
> +
> +	tmp |= int_freq[div_index].clk_div_r0x;
> +
> +	__raw_writel(tmp, EXYNOS5_CLKDIV_R0X);
> +
> +	while (__raw_readl(EXYNOS5_CLKDIV_STAT_R0X) & 0x10)
> +		cpu_relax();
> +
> +	/* Change Divider - R1X */
> +	tmp = __raw_readl(EXYNOS5_CLKDIV_R1X);
> +
> +	tmp &= ~EXYNOS5_CLKDIV_R1X_PCLK_R1X_MASK;
> +
> +	tmp |= int_freq[div_index].clk_div_r1x;
> +
> +	__raw_writel(tmp, EXYNOS5_CLKDIV_R1X);
> +
> +	while (__raw_readl(EXYNOS5_CLKDIV_STAT_R1X) & 0x10)
> +		cpu_relax();
> +}
> +
> +static int exynos5_clk_int_set_rate(struct clk *clk, unsigned long rate)
> +{
> +	int index;
> +
> +	for (index = 0; index < ARRAY_SIZE(int_freq); index++)
> +		if (int_freq[index].freq == rate)
> +			break;
> +
> +	if (index == ARRAY_SIZE(int_freq))
> +		return -EINVAL;
> +
> +	/* Change the system clock divider values */
> +	exynos5_int_set_clkdiv(index);
> +
> +	clk->rate = rate;
> +
> +	return 0;
> +}
> +
> +static struct clk_ops exynos5_clk_int_ops = {
> +	.get_rate = exynos5_clk_int_get_rate,
> +	.set_rate = exynos5_clk_int_set_rate
>  };
> 
>  static u32 epll_div[][6] = {
> @@ -1713,6 +1861,9 @@ void __init_or_cpufreq exynos5_setup_clocks(void)
> 
>  	clk_fout_epll.ops = &exynos5_epll_ops;
> 
> +	exynos5_int_clk.ops = &exynos5_clk_int_ops;
> +	exynos5_int_clk.rate = aclk_266;
> +
>  	if (clk_set_parent(&exynos5_clk_mout_epll.clk, &clk_fout_epll))
>  		printk(KERN_ERR "Unable to set parent %s of clock %s.\n",
>  				clk_fout_epll.name,
> exynos5_clk_mout_epll.clk.name);
> diff --git a/arch/arm/mach-exynos/common.c b/arch/arm/mach-exynos/common.c
> index 73b940f..6b7d4ee 100644
> --- a/arch/arm/mach-exynos/common.c
> +++ b/arch/arm/mach-exynos/common.c
> @@ -282,6 +282,31 @@ static struct map_desc exynos5_iodesc[] __initdata =
> {
>  		.pfn		= __phys_to_pfn(EXYNOS5_PA_UART),
>  		.length		= SZ_512K,
>  		.type		= MT_DEVICE,
> +	}, {
> +		.virtual        = (unsigned long)S5P_VA_PPMU_CPU,
> +		.pfn            = __phys_to_pfn(EXYNOS5_PA_PPMU_CPU),
> +		.length         = SZ_8K,
> +		.type		= MT_DEVICE,
> +	}, {
> +		.virtual        = (unsigned long)S5P_VA_PPMU_DDR_C,
> +		.pfn            = __phys_to_pfn(EXYNOS5_PA_PPMU_DDR_C),
> +		.length         = SZ_8K,
> +		.type           = MT_DEVICE,
> +	}, {
> +		.virtual        = (unsigned long)S5P_VA_PPMU_DDR_R1,
> +		.pfn            = __phys_to_pfn(EXYNOS5_PA_PPMU_DDR_R1),
> +		.length         = SZ_8K,
> +		.type           = MT_DEVICE,
> +	}, {
> +		.virtual        = (unsigned long)S5P_VA_PPMU_DDR_L,
> +		.pfn            = __phys_to_pfn(EXYNOS5_PA_PPMU_DDR_L),
> +		.length         = SZ_8K,
> +		.type           = MT_DEVICE,
> +	}, {
> +		.virtual        = (unsigned long)S5P_VA_PPMU_RIGHT,
> +		.pfn            = __phys_to_pfn(EXYNOS5_PA_PPMU_RIGHT),
> +		.length         = SZ_8K,
> +		.type           = MT_DEVICE,
>  	},
>  };
> 
> diff --git a/arch/arm/mach-exynos/include/mach/map.h b/arch/arm/mach-
> exynos/include/mach/map.h
> index cbb2852..8c8de91 100644
> --- a/arch/arm/mach-exynos/include/mach/map.h
> +++ b/arch/arm/mach-exynos/include/mach/map.h
> @@ -228,6 +228,12 @@
>  #define EXYNOS4_PA_SDRAM		0x40000000
>  #define EXYNOS5_PA_SDRAM		0x40000000
> 
> +#define EXYNOS5_PA_PPMU_DDR_C		0x10C40000
> +#define EXYNOS5_PA_PPMU_DDR_R1		0x10C50000
> +#define EXYNOS5_PA_PPMU_CPU		0x10C60000
> +#define EXYNOS5_PA_PPMU_DDR_L		0x10CB0000
> +#define EXYNOS5_PA_PPMU_RIGHT		0x13660000
> +
>  /* Compatibiltiy Defines */
> 
>  #define S3C_PA_HSMMC0			EXYNOS4_PA_HSMMC(0)
> diff --git a/arch/arm/mach-exynos/include/mach/regs-clock.h
> b/arch/arm/mach-exynos/include/mach/regs-clock.h
> index d36ad76..bad3cd3 100644
> --- a/arch/arm/mach-exynos/include/mach/regs-clock.h
> +++ b/arch/arm/mach-exynos/include/mach/regs-clock.h
> @@ -323,6 +323,9 @@
>  #define EXYNOS5_CLKDIV_PERIC5
EXYNOS_CLKREG(0x1056C)
>  #define EXYNOS5_SCLK_DIV_ISP			EXYNOS_CLKREG(0x10580)
> 
> +#define EXYNOS5_CLKDIV_STAT_TOP0		EXYNOS_CLKREG(0x10610)
> +#define EXYNOS5_CLKDIV_STAT_TOP1		EXYNOS_CLKREG(0x10614)
> +
>  #define EXYNOS5_CLKGATE_IP_ACP
EXYNOS_CLKREG(0x08800)
>  #define EXYNOS5_CLKGATE_IP_ISP0
EXYNOS_CLKREG(0x0C800)
>  #define EXYNOS5_CLKGATE_IP_ISP1
EXYNOS_CLKREG(0x0C804)
> @@ -337,6 +340,18 @@
>  #define EXYNOS5_CLKGATE_IP_PERIS		EXYNOS_CLKREG(0x10960)
>  #define EXYNOS5_CLKGATE_BLOCK
EXYNOS_CLKREG(0x10980)
> 
> +#define EXYNOS5_CLKGATE_BUS_SYSLFT		EXYNOS_CLKREG(0x08920)
> +
> +#define EXYNOS5_CLKOUT_CMU_TOP
EXYNOS_CLKREG(0x10A00)
> +
> +#define EXYNOS5_CLKDIV_LEX			EXYNOS_CLKREG(0x14500)
> +#define EXYNOS5_CLKDIV_STAT_LEX
EXYNOS_CLKREG(0x14600)
> +
> +#define EXYNOS5_CLKDIV_R0X			EXYNOS_CLKREG(0x18500)
> +#define EXYNOS5_CLKDIV_STAT_R0X
EXYNOS_CLKREG(0x18600)
> +
> +#define EXYNOS5_CLKDIV_R1X			EXYNOS_CLKREG(0x1C500)
> +#define EXYNOS5_CLKDIV_STAT_R1X
EXYNOS_CLKREG(0x1C600)
>  #define EXYNOS5_BPLL_CON0			EXYNOS_CLKREG(0x20110)
>  #define EXYNOS5_CLKSRC_CDREX			EXYNOS_CLKREG(0x20200)
>  #define EXYNOS5_CLKDIV_CDREX			EXYNOS_CLKREG(0x20500)
> @@ -347,6 +362,39 @@
> 
>  #define EXYNOS5_EPLLCON0_LOCKED_SHIFT		(29)
> 
> +#define EXYNOS5_CLKDIV_TOP0_ACLK300_DISP1_SHIFT	(28)
> +#define EXYNOS5_CLKDIV_TOP0_ACLK300_DISP1_MASK	(0x7 <<
> EXYNOS5_CLKDIV_TOP0_ACLK300_DISP1_SHIFT)
> +#define EXYNOS5_CLKDIV_TOP0_ACLK333_SHIFT	(20)
> +#define EXYNOS5_CLKDIV_TOP0_ACLK333_MASK	(0x7 <<
> EXYNOS5_CLKDIV_TOP0_ACLK333_SHIFT)
> +#define EXYNOS5_CLKDIV_TOP0_ACLK266_SHIFT	(16)
> +#define EXYNOS5_CLKDIV_TOP0_ACLK266_MASK	(0x7 <<
> EXYNOS5_CLKDIV_TOP0_ACLK266_SHIFT)
> +#define EXYNOS5_CLKDIV_TOP0_ACLK200_SHIFT	(12)
> +#define EXYNOS5_CLKDIV_TOP0_ACLK200_MASK	(0x7 <<
> EXYNOS5_CLKDIV_TOP0_ACLK200_SHIFT)
> +#define EXYNOS5_CLKDIV_TOP0_ACLK166_SHIFT	(8)
> +#define EXYNOS5_CLKDIV_TOP0_ACLK166_MASK	(0x7 <<
> EXYNOS5_CLKDIV_TOP0_ACLK166_SHIFT)
> +#define EXYNOS5_CLKDIV_TOP0_ACLK66_SHIFT	(0)
> +#define EXYNOS5_CLKDIV_TOP0_ACLK66_MASK		(0x7 <<
> EXYNOS5_CLKDIV_TOP0_ACLK66_SHIFT)
> +
> +#define EXYNOS5_CLKDIV_TOP1_ACLK66_PRE_SHIFT	(24)
> +#define EXYNOS5_CLKDIV_TOP1_ACLK66_PRE_MASK	(0x7 <<
> EXYNOS5_CLKDIV_TOP1_ACLK66_PRE_SHIFT)
> +#define EXYNOS5_CLKDIV_TOP1_ACLK400_ISP_SHIFT	(20)
> +#define EXYNOS5_CLKDIV_TOP1_ACLK400_ISP_MASK	(0x7 <<
> EXYNOS5_CLKDIV_TOP1_ACLK400_ISP_SHIFT)
> +#define EXYNOS5_CLKDIV_TOP1_ACLK400_IOP_SHIFT	(16)
> +#define EXYNOS5_CLKDIV_TOP1_ACLK400_IOP_MASK	(0x7 <<
> EXYNOS5_CLKDIV_TOP1_ACLK400_IOP_SHIFT)
> +#define EXYNOS5_CLKDIV_TOP1_ACLK300_GSCL_SHIFT	(12)
> +#define EXYNOS5_CLKDIV_TOP1_ACLK300_GSCL_MASK	(0x7 <<
> EXYNOS5_CLKDIV_TOP1_ACLK300_GSCL_SHIFT)
> +
> +#define EXYNOS5_CLKDIV_LEX_ATCLK_LEX_SHIFT	(8)
> +#define EXYNOS5_CLKDIV_LEX_ATCLK_LEX_MASK	(0x7 <<
> EXYNOS5_CLKDIV_LEX_ATCLK_LEX_SHIFT)
> +#define EXYNOS5_CLKDIV_LEX_PCLK_LEX_SHIFT	(4)
> +#define EXYNOS5_CLKDIV_LEX_PCLK_LEX_MASK	(0x7 <<
> EXYNOS5_CLKDIV_LEX_PCLK_LEX_SHIFT)
> +
> +#define EXYNOS5_CLKDIV_R0X_PCLK_R0X_SHIFT	(4)
> +#define EXYNOS5_CLKDIV_R0X_PCLK_R0X_MASK	(0x7 <<
> EXYNOS5_CLKDIV_R0X_PCLK_R0X_SHIFT)
> +
> +#define EXYNOS5_CLKDIV_R1X_PCLK_R1X_SHIFT	(4)
> +#define EXYNOS5_CLKDIV_R1X_PCLK_R1X_MASK	(0x7 <<
> EXYNOS5_CLKDIV_R1X_PCLK_R1X_SHIFT)
> +
>  #define PWR_CTRL1_CORE2_DOWN_RATIO		(7 << 28)
>  #define PWR_CTRL1_CORE1_DOWN_RATIO		(7 << 16)
>  #define PWR_CTRL1_DIV2_DOWN_EN			(1 << 9)
> diff --git a/arch/arm/plat-samsung/include/plat/map-s5p.h b/arch/arm/plat-
> samsung/include/plat/map-s5p.h
> index 038aa96..28bef98 100644
> --- a/arch/arm/plat-samsung/include/plat/map-s5p.h
> +++ b/arch/arm/plat-samsung/include/plat/map-s5p.h
> @@ -42,6 +42,12 @@
> 
>  #define S5P_VA_AUDSS		S3C_ADDR(0x02830000)
> 
> +#define S5P_VA_PPMU_CPU		S3C_ADDR(0x02840000)
> +#define S5P_VA_PPMU_DDR_C	S3C_ADDR(0x02842000)
> +#define S5P_VA_PPMU_DDR_R1	S3C_ADDR(0x02844000)
> +#define S5P_VA_PPMU_DDR_L	S3C_ADDR(0x02846000)
> +#define S5P_VA_PPMU_RIGHT	S3C_ADDR(0x02848000)
> +
>  #define VA_VIC(x)		(S3C_VA_IRQ + ((x) * 0x10000))
>  #define VA_VIC0			VA_VIC(0)
>  #define VA_VIC1			VA_VIC(1)
> --
> 1.7.8.6


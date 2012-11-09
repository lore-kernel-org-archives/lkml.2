Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216Ab2KIKUH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 05:20:07 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:18715 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab2KIKUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 05:20:00 -0500
X-AuditID: cbfee61b-b7f616d00000319b-bb-509cd8ced15b
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Bartlomiej Zolnierkiewicz'" <b.zolnierkie@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, jassisinghbrar@gmail.com,
        vinod.koul@intel.com, rob.herring@calxeda.com, dinguyen@altera.com,
        pawel.moll@arm.com, t.figa@samsung.com, kyungmin.park@samsung.com
References: <1351504796-24788-1-git-send-email-b.zolnierkie@samsung.com>
 <201210300956.23102.b.zolnierkie@samsung.com>
 <0cea01cdbd6c$7ace7200$706b5600$%kim@samsung.com>
 <201211081054.41649.b.zolnierkie@samsung.com>
In-reply-to: <201211081054.41649.b.zolnierkie@samsung.com>
Subject: RE: [PATCH 2/4] ARM: EXYNOS: PL330 MDMA1 fix for revision 0 of
 Exynos4210 SOC
Date: Fri, 09 Nov 2012 19:19:58 +0900
Message-id: <0e8801cdbe63$c52b6e50$4f824af0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac29lzuGktWzIActS0W0cetE2PhDIAAzECxQ
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t8zI91zN+YEGFzYpmRxedccNosZ5/cx
	OTB5fN4kF8AYxWWTkpqTWZZapG+XwJVx9sYhloImsYpnFyazNTAuF+pi5OSQEDCRONvWwAhh
	i0lcuLeerYuRi0NIYBmjxLwXM5lgitoud7FCJKYzSnz4cg7K+csocaWrixmkik1AQ+Lw+2fs
	ILaIgJXE4xln2UGKmAUmMEmsWH2eBaLjDqNEX88iVpAqTqCq90962UBsYYEIiYcXvoHFWQRU
	Jb5dmwc2lVfAVmLjziYoW1Dix+R7LCA2s4CWxPqdx5kgbHmJzWveAtVwAN2qLvHory7EEUYS
	t+9NYYYoEZHY9+IdI8R4AYlvkw+xQJTLSmw6wAxymoTAKnaJW5c+skO8LClxcMUNlgmMErOQ
	bJ6FZPMsJJtnIVmxgJFlFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZIpEnvYFzVYHGIUYCD
	UYmHN/HB7AAh1sSy4srcQ4wSHMxKIrxGZ+cECPGmJFZWpRblxxeV5qQWH2L0Abp8IrOUaHI+
	MAnklcQbGhubmJmYmphbmpqb4hBWEudt9kgJEBJITyxJzU5NLUgtghnHxMEp1cA4bUvNi9Jr
	pRWrDl2fKHpplvpriaaXHpsT2h57W/uYzOu5X3awNybNz9hK2nR7+sIZPzZ/X5qz6FlPTVvT
	jofnH9WGC7zldv7+wOmNwMeky91vXVeemJTx68G0cEXnd1aycy1mBcd7MQpmTn+bEh1e6rRg
	yq+yorkC/qlbFpZ+rK0P2adS0LRHiaU4I9FQi7moOBEA/EbXVeECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t9jQd1zN+YEGPycJW9xedccNosZ5/cx
	OTB5fN4kF8AY1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIT
	oOuWmQM0WkmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYcfbGIZaCJrGK
	ZxcmszUwLhfqYuTkkBAwkWi73MUKYYtJXLi3nq2LkYtDSGA6o8SHL+dYIZy/jBJXurqYQarY
	BDQkDr9/xg5iiwhYSTyecZYdpIhZYAKTxIrV51kgOu4wSvT1LAKbywlU9f5JLxuILSwQIfHw
	wjewOIuAqsS3a/PApvIK2Eps3NkEZQtK/Jh8jwXEZhbQkli/8zgThC0vsXnNW6AaDqBb1SUe
	/dWFOMJI4va9KcwQJSIS+168Y5zAKDQLyaRZSCbNQjJpFpKWBYwsqxhFUwuSC4qT0nON9IoT
	c4tL89L1kvNzNzGC4/iZ9A7GVQ0WhxgFOBiVeHgTH8wOEGJNLCuuzD3EKMHBrCTCa3R2ToAQ
	b0piZVVqUX58UWlOavEhRh+gRycyS4km5wNTTF5JvKGxiZmRpZGZhZGJuTkOYSVx3maPlAAh
	gfTEktTs1NSC1CKYcUwcnFINjAs5LQIEz8uppc2QyT74ccZsGdPfnOWP1mcb6n+oqnc9dtnT
	+EN1evoZL+tfotPZWo0OL9i3ZpPczrNZjpkss+5N3HT2y5eSKYks2uYfj3cHf1TJcmVUXWJ9
	wNXB0DdIyXvumojd81Q7djNXO7vdEUsTNeNX1jo9mU9HKSS/Zt6S3ZlbrOMLlViKMxINtZiL
	ihMBgivw1xADAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> 
> Ah, okay.  Here is full simplified patch.
> 
> From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Subject: [PATCH v2] ARM: EXYNOS: PL330 MDMA1 fix for revision 0 of
> Exynos4210 SOC
> 
> Commit 8214513 ("ARM: EXYNOS: fix address for EXYNOS4 MDMA1")
> changed EXYNOS specific setup of PL330 DMA engine to use 'non-secure'
> mdma1 address instead of 'secure' one (from 0x12840000 to 0x12850000)
> to fix issue with some Exynos4212 SOCs.  Unfortunately it brakes
> PL330 setup for revision 0 of Exynos4210 SOC (mdma1 device cannot
> be found at 'non-secure' address):
> 
> [    0.566245] dma-pl330 dma-pl330.2: PERIPH_ID 0x0, PCELL_ID 0x0 !
> [    0.566278] dma-pl330: probe of dma-pl330.2 failed with error -22
> 
> Fix it by using 'secure' mdma1 address on Exynos4210 revision 0 SOC.
> 
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  arch/arm/mach-exynos/dma.c              |    3 +++
>  arch/arm/mach-exynos/include/mach/map.h |    1 +
>  2 files changed, 4 insertions(+)
> 
> Index: b/arch/arm/mach-exynos/dma.c
> ===================================================================
> --- a/arch/arm/mach-exynos/dma.c	2012-11-07 18:20:36.561743865 +0100
> +++ b/arch/arm/mach-exynos/dma.c	2012-11-08 10:48:23.445067606 +0100
> @@ -275,6 +275,9 @@ static int __init exynos_dma_init(void)
>  		exynos_pdma1_pdata.nr_valid_peri =
>  			ARRAY_SIZE(exynos4210_pdma1_peri);
>  		exynos_pdma1_pdata.peri_id = exynos4210_pdma1_peri;
> +
> +		if (samsung_rev() == EXYNOS4210_REV_0)
> +			exynos_mdma1_device.res.start = EXYNOS4_PA_S_MDMA1;
>  	} else if (soc_is_exynos4212() || soc_is_exynos4412()) {
>  		exynos_pdma0_pdata.nr_valid_peri =
>  			ARRAY_SIZE(exynos4212_pdma0_peri);
> Index: b/arch/arm/mach-exynos/include/mach/map.h
> ===================================================================
> --- a/arch/arm/mach-exynos/include/mach/map.h	2012-11-07
> 18:20:44.801743862 +0100
> +++ b/arch/arm/mach-exynos/include/mach/map.h	2012-11-08
> 10:48:40.597067605 +0100
> @@ -92,6 +92,7 @@
> 
>  #define EXYNOS4_PA_MDMA0		0x10810000
>  #define EXYNOS4_PA_MDMA1		0x12850000
> +#define EXYNOS4_PA_S_MDMA1		0x12840000
>  #define EXYNOS4_PA_PDMA0		0x12680000
>  #define EXYNOS4_PA_PDMA1		0x12690000
>  #define EXYNOS5_PA_MDMA0		0x10800000

Looks good to me, and I think, this can be handled separate from this
series.

Vinod, if you're ok, let me pick this up into Samsung tree.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.


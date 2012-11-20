Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab2KTMXb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 07:23:31 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:63569 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab2KTMX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 07:23:29 -0500
X-AuditID: cbfee61b-b7f616d00000319b-36-50ab76400dd4
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
Date: Tue, 20 Nov 2012 21:23:27 +0900
Message-id: <0ca001cdc719$d82e5f80$888b1e80$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac29lzuGktWzIActS0W0cetE2PhDIAJgohhg
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t8zA12HstUBBlMOslhc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGW8+X2BqeCkSMX5j7PZGxjnCHYxcnJICJhInJ74lhnC
	FpO4cG89WxcjF4eQwDJGiRnnXrDCFO34fJkZIrGIUaJ3/Veoqr+MEpcnvGUEqWIT0JA4/P4Z
	O4gtImAl8XjGWXaQImaBCUwSK1afZ4HouMMo0dezCGwuJ1DV+ye9bCC2sECExMML38DiLAKq
	Eu9XH2ECsXkFbCX6pj5kg7AFJX5MvscCYjMLaEms33mcCcKWl9i8BuQJDqBb1SUe/dWFOMJI
	Ym7/U1aIEhGJfS/eMUKMF5D4NvkQC0S5rMSmA2CfSQisYpdoOPecEeJlSYmDK26wTGCUmIVk
	8ywkm2ch2TwLyYoFjCyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MUIiTXoH46oGi0OMAhyM
	Sjy8DxNWBQixJpYVV+YeYpTgYFYS4Y0vXB0gxJuSWFmVWpQfX1Sak1p8iNEH6PKJzFKiyfnA
	JJBXEm9obGxiZmJqYm5pam6KQ1hJnLfZIyVASCA9sSQ1OzW1ILUIZhwTB6dUA2ODs8n/NZxv
	F56rnDilLKPjecfBGR7X6wsq/+Z1aG7LfbdDtqrT+baZWmBQmVvBprv2+07MXvfl1ukvpzya
	277Es0Q5F784P0f5xtzJD7pX/ry+VlBhqT93Ur/bqUdrVs6LmbNSQaNhgaq2mRfP6nWyu6I6
	7kY/OnDpB88V2a1NR89sUmv6wKejxFKckWioxVxUnAgAP551XeECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t9jAV37stUBBn0frS0u75rDZjHj/D4m
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgz3vy+wFRwUqTi
	/MfZ7A2McwS7GDk5JARMJHZ8vswMYYtJXLi3nq2LkYtDSGARo0Tv+q9Qzl9GicsT3jKCVLEJ
	aEgcfv+MHcQWEbCSeDzjLDtIEbPABCaJFavPs0B03GGU6OtZxApSxQlU9f5JLxuILSwQIfHw
	wjewOIuAqsT71UeYQGxeAVuJvqkP2SBsQYkfk++xgNjMAloS63ceZ4Kw5SU2r3kLdCsH0K3q
	Eo/+6kIcYSQxt/8pK0SJiMS+F+8YJzAKzUIyaRaSSbOQTJqFpGUBI8sqRtHUguSC4qT0XCO9
	4sTc4tK8dL3k/NxNjOA4fia9g3FVg8UhRgEORiUe3ocJqwKEWBPLiitzDzFKcDArifDGF64O
	EOJNSaysSi3Kjy8qzUktPsToA/ToRGYp0eR8YIrJK4k3NDYxM7I0MrMwMjE3xyGsJM7b7JES
	ICSQnliSmp2aWpBaBDOOiYNTqoEx3btHPJVBk2V5vIykXPaLTt/84zHBLXM5/9qs0dY/6+rx
	uLZ76ntD+8aO7UIxiztN6ldxK7xf9sTP42juNKH7nNwSH032X/CKvl/z7kvJF9W4u3W9/rO1
	2vY+LAr0MeRNmM3xLvFcvPV6Hr3UCdvNXCI3rRT0+co7odRvaVOpl562YPkTJiWW4oxEQy3m
	ouJEAG8oCpMQAwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
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

Applied, thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.


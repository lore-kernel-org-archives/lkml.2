Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758735Ab2KWB4G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 20:56:06 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:42735 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039Ab2KWB4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 20:56:04 -0500
X-AuditID: cbfee61b-b7f616d00000319b-dc-50aed7b27874
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Bartlomiej Zolnierkiewicz'" <b.zolnierkie@samsung.com>,
        linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        jassisinghbrar@gmail.com, vinod.koul@intel.com,
        rob.herring@calxeda.com, dinguyen@altera.com, pawel.moll@arm.com,
        t.figa@samsung.com, kyungmin.park@samsung.com
References: <1351504796-24788-1-git-send-email-b.zolnierkie@samsung.com>
 <1351504796-24788-4-git-send-email-b.zolnierkie@samsung.com>
 <201211221157.26615.b.zolnierkie@samsung.com>
In-reply-to: <201211221157.26615.b.zolnierkie@samsung.com>
Subject: RE: [PATCH 3/4] ARM: dts: exynos4: add node for PL330 MDMA1 controller
Date: Fri, 23 Nov 2012 10:56:02 +0900
Message-id: <10f601cdc91d$b10e4770$132ad650$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3IoGIcPL5F+mwcQV2Mb7LG+Sdr3AAfQXPw
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t8zI91N19cFGDzbamxxedccNosZ5/cx
	OTB5fN4kF8AYxWWTkpqTWZZapG+XwJUx+fgtloLpwhXb135gb2C8w9/FyMEhIWAi8eVERBcj
	J5ApJnHh3nq2LkYuDiGBZYwSq9adZ4FImEgs6fnDCGILCSxilLjfnQZR9JdR4uHDmWBFbAIa
	EoffP2MHsUUEoiT+bl/DAlLELPCJUeJD/zuosdsZJSb2vQCr4hSwkjhz8AMLyBnCAv4S258V
	gJgsAqoS9+bHgpi8ArYSz6ZFgRTzCghK/Jh8D2wVs4CWxPqdx5kgbHmJzWveMkP8oi7x6K8u
	xAVGEi+nvWKEKBGR2PfiHZjNIiAg8W3yIRaIclmJTQeYQe6SEFjHLnH1WBsrxLuSEgdX3GCZ
	wCgxC8nmWUg2z0KyeRaSFQsYWVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525ihMSX9A7GVQ0W
	hxgFOBiVeHgNy9YFCLEmlhVX5h5ilOBgVhLhLToPFOJNSaysSi3Kjy8qzUktPsToA3T5RGYp
	0eR8YOznlcQbGhubmJmYmphbmpqb4hBWEudt9kgJEBJITyxJzU5NLUgtghnHxMEp1cDY/WNX
	YUO15J7ImWLL9v/5/Sf41u6KE8p8JlvfeB36oje9LWx36uykQ6KTb+dPcG6dZ2p7eoatzdw1
	ay09j5Z/7o9xDrgp9m5j1TOD+bqvT72uPS2zPMx2ZkLOTDPVMzcnXNu9sdB+vsyMX4bCa0y0
	DssvOBxmtPj180yGtdxcf+Ol/KJOh009p8RSnJFoqMVcVJwIAD9kXcDcAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t9jAd1N19cFGNzt0bW4vGsOm8WM8/uY
	HJg8Pm+SC2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAEaraRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMmHz8FkvBdOGK
	7Ws/sDcw3uHvYuTkkBAwkVjS84cRwhaTuHBvPRuILSSwiFHifndaFyMXkP2XUeLhw5ksIAk2
	AQ2Jw++fsYPYIgJREn+3r2EBKWIW+MQo8aH/HRtEx3ZGiYl9L8CqOAWsJM4c/ABUxcEhLOAv
	sf1ZAYjJIqAqcW9+LIjJK2Ar8WxaFEgxr4CgxI/J98BWMQtoSazfeZwJwpaX2LzmLTNIuYSA
	usSjv7oQFxhJvJz2ihGiRERi34t3jBMYhWYhmTQLyaRZSCbNQtKygJFlFaNoakFyQXFSeq6R
	XnFibnFpXrpecn7uJkZw/D6T3sG4qsHiEKMAB6MSD69h2boAIdbEsuLK3EOMEhzMSiK8ReeB
	QrwpiZVVqUX58UWlOanFhxh9gN6cyCwlmpwPTC15JfGGxiZmRpZGZhZGJubmOISVxHmbPVIC
	hATSE0tSs1NTC1KLYMYxcXBKNTDyHkxnLejMcGr4dqXmaZOExM3J+Yuftlj8XbL86ub1Ew/f
	jT73TIPVb9uj8q22OQ9Z8i9ZfZyvtPfP9Q8/n6+by7txtnnYvVnakVcfrde8vz/TnvfO2aD0
	DevbvT4tK/i4cNVk7kTZq8r50wp9rC6oLtWa9H278fSM6Bm351p9fvTsmPBlH48Hp5VYijMS
	DbWYi4oTAWDNjLAMAwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> 
> 
> Hi Kukjin,
> 
Hi Bart,

> Could you also apply this patch?
> 
Yeah, looks good to me :-)

Will apply, thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.
> 
> 
> From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Subject: [PATCH v2] ARM: dts: exynos4: add node for PL330 MDMA1 controller
> 
> Add missing PL330 MDMA1 controller node to the device tree (DT).
> 
> [ Currently there is no problem with using 'non-secure' mdma1 address
>   instead of 'secure' one on revision 0 of Exynos4210 SOC (as used by
>   Universal C210 board) as this SOC revision is unsupported by DT. ]
> 
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> v2: refreshed againt next-20121115 and added Reviewed-by tag
> 
>  arch/arm/boot/dts/exynos4.dtsi         |    6 ++++++
>  arch/arm/mach-exynos/mach-exynos4-dt.c |    1 +
>  2 files changed, 7 insertions(+)
> 
> Index: b/arch/arm/boot/dts/exynos4.dtsi
> ===================================================================
> --- a/arch/arm/boot/dts/exynos4.dtsi	2012-11-22 11:40:51.000000000
> +0100
> +++ b/arch/arm/boot/dts/exynos4.dtsi	2012-11-22 11:53:29.520815274
> +0100
> @@ -244,5 +244,11 @@
>  			reg = <0x12690000 0x1000>;
>  			interrupts = <0 36 0>;
>  		};
> +
> +		mdma1: mdma@12850000 {
> +			compatible = "arm,pl330", "arm,primecell";
> +			reg = <0x12850000 0x1000>;
> +			interrupts = <0 34 0>;
> +		};
>  	};
>  };
> Index: b/arch/arm/mach-exynos/mach-exynos4-dt.c
> ===================================================================
> --- a/arch/arm/mach-exynos/mach-exynos4-dt.c	2012-11-22
> 11:40:51.000000000 +0100
> +++ b/arch/arm/mach-exynos/mach-exynos4-dt.c	2012-11-22
> 11:53:55.248815271 +0100
> @@ -77,6 +77,7 @@ static const struct of_dev_auxdata exyno
>  				"exynos4210-spi.2", NULL),
>  	OF_DEV_AUXDATA("arm,pl330", EXYNOS4_PA_PDMA0, "dma-pl330.0", NULL),
>  	OF_DEV_AUXDATA("arm,pl330", EXYNOS4_PA_PDMA1, "dma-pl330.1", NULL),
> +	OF_DEV_AUXDATA("arm,pl330", EXYNOS4_PA_MDMA1, "dma-pl330.2", NULL),
>  	OF_DEV_AUXDATA("samsung,exynos4210-tmu", EXYNOS4_PA_TMU,
>  				"exynos-tmu", NULL),
>  	{},


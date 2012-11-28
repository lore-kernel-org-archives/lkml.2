Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415Ab2K1FXN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 00:23:13 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:19669 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab2K1FXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 00:23:11 -0500
X-AuditID: cbfee61b-b7f616d00000319b-a4-50b59fbdaa4a
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Olof Johansson'" <olof@lixom.net>
Cc: "'Doug Anderson'" <dianders@chromium.org>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        "'Russell King'" <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
References: <1354045994-8977-1-git-send-email-dianders@chromium.org>
 <CAOesGMjyXZwKjycyVcEV0ty0LCM_i61QxykYPhAvXxx2rhgP+A@mail.gmail.com>
 <50B53E37.40303@samsung.com>
 <CAOesGMivs=NA6hcTYWO-MWUeUjVGZ0h258z1MpeexXGtVf9h-g@mail.gmail.com>
In-reply-to: <CAOesGMivs=NA6hcTYWO-MWUeUjVGZ0h258z1MpeexXGtVf9h-g@mail.gmail.com>
Subject: RE: [PATCH] ARM: EXYNOS: Avoid early use of of_machine_is_compatible()
Date: Wed, 28 Nov 2012 14:23:09 +0900
Message-id: <18d701cdcd28$74198d70$5c4ca850$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3M78/Zev9PNB8vTUSwvwHdOKHh8wANoFjQ
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t8zA92987cGGKy+r2BxedccNosZ5/cx
	OTB5fN4kF8AYxWWTkpqTWZZapG+XwJUx83w7Y8FN2Yrln/tZGxg/SHQxcnJICJhILHh7hx3C
	FpO4cG89WxcjF4eQwDJGiY6J25hhim4cXMkMkZjOKDF18T5GCOcvo8TpYzeYQKrYBDQkDr9/
	BjZKREBV4smTLlaQImaBB4wSU9rPMkF0fGSUOLL6FBtIFadAsMT///fBOoQF/CWmn1sLZrMA
	da9YuAGshlfAVuJqw1cWCFtQ4sfke2A2s4CWxPqdx5kgbHmJzWveAt3HAXSrusSjv7oQRxhJ
	/DzxEapERGLfi3eMEOMFJL5NPsQCUS4rsekA2GcSAqvYJXqevmCEeFlS4uCKGywTGCVmIdk8
	C8nmWUg2z0KyYgEjyypG0dSC5ILipPRcI73ixNzi0rx0veT83E2MkEiT3sG4qsHiEKMAB6MS
	D6+D49YAIdbEsuLK3EOMEhzMSiK8PG1AId6UxMqq1KL8+KLSnNTiQ4w+QJdPZJYSTc4HJoG8
	knhDY2MTMxNTE3NLU3NTHMJK4rzNHikBQgLpiSWp2ampBalFMOOYODilGhg3hS71WNQecMU3
	8v4W9yyLGStj2OwO21jpa9tqVuQ8enP2sunrlLjIJka7WXcXO6VFrlJaYKSmeF5585NDE3zZ
	Nq1ZMe/K5U3ZOR9Xq/Qu1hYKLBee2hVzuGLvn8Vs1/r/1Skpn+56ulA97PJ304v1ZU80/8or
	h3EV/jr9JnqFRWrik0vBSoxKLMUZiYZazEXFiQCUhahz4QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t9jQd2987cGGExYLmNxedccNosZ5/cx
	OTB5fN4kF8AY1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIT
	oOuWmQM0WkmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYMfN8O2PBTdmK
	5Z/7WRsYP0h0MXJySAiYSNw4uJIZwhaTuHBvPVsXIxeHkMB0Rompi/cxQjh/GSVOH7vBBFLF
	JqAhcfj9M3YQW0RAVeLJky5WkCJmgQeMElPazzJBdHxklDiy+hQbSBWnQLDE///3wTqEBfwl
	pp9bC2azAHWvWLgBrIZXwFbiasNXFghbUOLH5HtgNrOAlsT6nceZIGx5ic1r3gLdygF0q7rE
	o7+6EEcYSfw88RGqRERi34t3jBMYhWYhmTQLyaRZSCbNQtKygJFlFaNoakFyQXFSeq6RXnFi
	bnFpXrpecn7uJkZwHD+T3sG4qsHiEKMAB6MSD6+D49YAIdbEsuLK3EOMEhzMSiK8PG1AId6U
	xMqq1KL8+KLSnNTiQ4w+QI9OZJYSTc4Hppi8knhDYxMzI0sjMwsjE3NzHMJK4rzNHikBQgLp
	iSWp2ampBalFMOOYODilGhg1ys6cDNzhqxeRfm2K+Jn8tCUMbB0fXwifW/xq8QvbjSWviy5Z
	6D7NTfmj32pUFiO0ruFQ87zpEcfiJ86S8JlafcWgxczgXJYL89b1pvueW4qv065afdX3UbVH
	bLxE255JjsuVVxiUnXKv1P1c3fuknLnA+t59H968r6Il/Dvfdk9RmfTTPUuJpTgj0VCLuag4
	EQAr0M4tEAMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olof Johansson wrote:
> 
> On Tue, Nov 27, 2012 at 2:27 PM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> > On 11/28/12 07:11, Olof Johansson wrote:
> >>
> >> On Tue, Nov 27, 2012 at 11:53 AM, Doug Anderson<dianders@chromium.org>
> >> wrote:
> >>>
> >>> The recent commit "ARM: EXYNOS: add support for EXYNOS5440 SoC" broke
> >>> support for exynos5250 because of_machine_is_compatible() was used too
> >>> early in the boot process.  It also probably meant that the exynos5440
> >>> failed to use the proper iotable.  Switch to use
> >>> of_flat_dt_is_compatible() in both of these cases.
> >>>
> >>> The failure I was seeing in exynos5250 because of this was:
> >>>    Division by zero in kernel.
> >>>    [<80015ed4>] (unwind_backtrace+0x0/0xec) from [<8045c7a4>]
> >>> (dump_stack+0x20/0x24)
> >>>    [<8045c7a4>] (dump_stack+0x20/0x24) from [<80012990>]
> >>> (__div0+0x20/0x28)
> >>>    [<80012990>] (__div0+0x20/0x28) from [<8021ab04>]
(Ldiv0_64+0x8/0x18)
> >>>    [<8021ab04>] (Ldiv0_64+0x8/0x18) from [<80068560>]
> >>> (__clocksource_updatefreq_scale+0x54/0x134)
> >>>    [<80068560>] (__clocksource_updatefreq_scale+0x54/0x134) from
> >>> [<8006865c>] (__clocksource_register_scale+0x1c/0x54)
> >>>    [<8006865c>] (__clocksource_register_scale+0x1c/0x54) from
> >>> [<80612a18>] (exynos_timer_init+0x100/0x1e8)
> >>>    [<80612a18>] (exynos_timer_init+0x100/0x1e8) from [<8060d184>]
> >>> (time_init+0x28/0x38)
> >>>    [<8060d184>] (time_init+0x28/0x38) from [<8060a754>]
> >>> (start_kernel+0x1e0/0x3c8)
> >>>    [<8060a754>] (start_kernel+0x1e0/0x3c8) from [<40008078>]
> (0x40008078)
> >>>
> >>> Signed-off-by: Doug Anderson<dianders@chromium.org>
> >>
> >>
> >> Thanks Doug.
> >>
> >> Kukjin, I'll apply this directly on top of the previous branch in
> >> arm-soc, if that's OK with you.
> >>
> > Sure, go ahead with my ack if you want,
> >
> > Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> >
> > Note, actually there was a fix which uses soc_is_exynos5440() in my
> local
> > :-) I'm not sure which one is better at this moment, but I'm OK on this.
> 
> Ok, applied. Thanks all.
> 
Olof, just note, happens build error with exynos4_defconfig because of
non-DT.

Following can resolve it or we should create null function for
of_get_flat_dt_root() and of_flat_dt_is_compatible()...

8<---------------------------------------
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: ARM: EXYNOS: fix a build error with non-DT for exynos4

This fixes following in case of non-DT:
arch/arm/mach-exynos/common.c: In function 'exynos_init_io':
arch/arm/mach-exynos/common.c:339: error: implicit declaration of function
'of_get_flat_dt_root'
arch/arm/mach-exynos/common.c:342: error: implicit declaration of function
'of_flat_dt_is_compatible'
make[1]: *** [arch/arm/mach-exynos/common.o] Error 1

Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
---
diff --git a/arch/arm/mach-exynos/common.c b/arch/arm/mach-exynos/common.c
index b919f5f..2110091 100644
--- a/arch/arm/mach-exynos/common.c
+++ b/arch/arm/mach-exynos/common.c
@@ -336,12 +336,14 @@ void __init exynos_init_late(void)

 void __init exynos_init_io(struct map_desc *mach_desc, int size)
 {
+#ifdef CONFIG_OF
 	unsigned long root = of_get_flat_dt_root();

 	/* initialize the io descriptors we need for initialization */
 	if (of_flat_dt_is_compatible(root, "samsung,exynos5440"))
 		iotable_init(exynos5440_iodesc,
ARRAY_SIZE(exynos5440_iodesc));
 	else
+#endif
 		iotable_init(exynos_iodesc, ARRAY_SIZE(exynos_iodesc));

 	if (mach_desc)
8<---------------------------------------

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.


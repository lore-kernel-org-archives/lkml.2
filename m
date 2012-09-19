Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab2ISX0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 19:26:38 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:12328 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab2ISX0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 19:26:37 -0400
X-AuditID: cbfee61a-b7f726d000000ec7-c2-505a54abf9e7
From: Kukjin Kim <kgene@kernel.org>
To: "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Dongjin Kim'" <tobetter@gmail.com>
Cc: "'Dongjin Kim'" <dongjin.kim@agreeyamobility.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1344366725-19153-1-git-send-email-dongjin.kim@agreeyamobility.net>
 <CAJuYYwTp00RohqKkF6+4yxq3bqW1O6NWkab29PuyEUPYTjeqgw@mail.gmail.com>
In-reply-to: <CAJuYYwTp00RohqKkF6+4yxq3bqW1O6NWkab29PuyEUPYTjeqgw@mail.gmail.com>
Subject: RE: [PATCH 3/4] arm/dts: exynos4: Add DTS file for ODROID-X
Date: Thu, 20 Sep 2012 08:26:35 +0900
Message-id: <09a201cd96be$35d24de0$a176e9a0$@org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac11GIaCuYAioaKmRJ+OtA5LcQyNSQhpYn6g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t9jQd3VIVEBBlcnmlpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MCwe/shbM4av48ekbWwPjJO4uRk4OCQETid/3HrJC2GISF+6t
	Z+ti5OIQEpjOKHHj5SMoZx6TxOm2syxdjBwcbALKEo1N+iANwgJaEgu3NLGA2CICYRIrfrxm
	BClhFqiUaNpaAdE6jVHi1fxFYAs4BYIl/nZvY4HodZH4cHQVE4jNIqAqse78VrBeXgFDiWNX
	DUHCvAKCEj8m3wMrZwZatX7ncSYIW15i85q3zCDlEgLqEo/+6kJcYCSxff8/qBIRiX0v3jFO
	YBSehWTSLCSTZiGZNAtJywJGllWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwcH9TGoH48oG
	i0OMAhyMSjy8HRJRAUKsiWXFlbmHGCU4mJVEeH/sjQwQ4k1JrKxKLcqPLyrNSS0+xCjNwaIk
	ziv8KTBASCA9sSQ1OzW1ILUIJsvEwSnVwGh8dzPPWXaB497a53YuvXv0y8uU2zULy95GpZkr
	Zmv2XLDpifA9uDewbq9QY1viAfVn6fkZRks+OTQeqJnwbcukpqaahWor/22v3MOqGc/sx8a8
	3O163qvrCb9PCD/tT5rQc1Rk3f9HEsLJhoFx3Ucd5a7bB/pyTTl9I9dhU3Op5uUn1xYv0lZi
	Kc5INNRiLipOBABHWnpsagIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Abraham wrote:
> 
> On 8 August 2012 00:42, Dongjin Kim <tobetter@gmail.com> wrote:
> > This patch create a DTS file for ODROID-X, it desribes PMIC max77686 and
> LED
> > gpios base.
> >
> > Signed-off-by: Dongjin Kim <dongjin.kim@agreeyamobility.net>
> > ---
> >  arch/arm/boot/dts/exynos4412-odroidx.dts |  148
> ++++++++++++++++++++++++++++++
> >  1 file changed, 148 insertions(+)
> >  create mode 100644 arch/arm/boot/dts/exynos4412-odroidx.dts
> >
> > diff --git a/arch/arm/boot/dts/exynos4412-odroidx.dts
> b/arch/arm/boot/dts/exynos4412-odroidx.dts
> > new file mode 100644
> > index 0000000..b0a892b
> > --- /dev/null
> > +++ b/arch/arm/boot/dts/exynos4412-odroidx.dts
> > @@ -0,0 +1,148 @@
> > +/*
> > + * Samsung's Exynos4210 based Origen board device tree source
> > + *
> > + * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
> > + *             http://www.samsung.com
> > + * Copyright (c) 2010-2011 Linaro Ltd.
> > + *             www.linaro.org
> > + *
> > + * Device tree source file for Insignal's Origen board which is based
> on
> > + * Samsung's Exynos4210 SoC.
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > +*/
> > +
> > +/dts-v1/;
> > +/include/ "exynos4412.dtsi"
> > +/include/ "max77686.dtsi"
> > +
> > +/ {
> > +       model = "Hardkernel ODROID-X evaluation board based on
> Exynos4412";
> > +       compatible = "hardkernel,odroidx", "samsung,exynos4412";
> 
> The compatible value "samsung,exynos4412" can be added to the
> compatible list in mach-exynos4-dt.c file. Otherwise, this looks fine.
> 
Dongjin, any updates on this?

K-Gene <kgene@kernel.org>


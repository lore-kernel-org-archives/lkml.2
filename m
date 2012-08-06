Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315Ab2HFRhh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 13:37:37 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:35101 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932155Ab2HFRhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 13:37:35 -0400
MIME-Version: 1.0
In-Reply-To: <1344262254-14648-1-git-send-email-dongjin.kim@agreeyamobility.net>
References: <1344262254-14648-1-git-send-email-dongjin.kim@agreeyamobility.net>
Date: Mon, 6 Aug 2012 23:07:33 +0530
Message-ID: <CAJuYYwSjnQ6z0iUaLCV9guC7yyKH3_pbd1QZe3ELKF-fYNfaqQ@mail.gmail.com>
Subject: Re: [PATCH] ODROID-X: hkdk4412: Add new hardware based on Exynos4412
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Dongjin Kim <tobetter@gmail.com>
Cc: Dongjin Kim <dongjin.kim@agreeyamobility.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Jon Medhurst <tixy@yxit.co.uk>,
        Shawn Guo <shawn.guo@linaro.org>,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 August 2012 19:40, Dongjin Kim <tobetter@gmail.com> wrote:
> The HKDK4412 is the CPU module developed by Hardkernel which is based on
> Exynos 4412.  mach_hkdk4412.c is to run on ODROID-X hardware and Machine ID
> (4289) is registered.
>
> Change-Id: I3af02808c03b9acea916c310390a4904ad92d761
> Signed-off-by: Dongjin Kim <dongjin.kim@agreeyamobility.net>
> ---
>  arch/arm/mach-exynos/Kconfig         |   23 +
>  arch/arm/mach-exynos/Makefile        |    1 +
>  arch/arm/mach-exynos/mach-hkdk4412.c |  979 ++++++++++++++++++++++++++++++++++
>  arch/arm/tools/mach-types            |    1 +
>  4 files changed, 1004 insertions(+)
>  create mode 100644 arch/arm/mach-exynos/mach-hkdk4412.c

How about looking at using device tree option for this board. That
might require additional effort but would be helpful in the long run.

Thanks,
Thomas.

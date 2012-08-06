Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368Ab2HFSQ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 14:16:26 -0400
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:48383
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932114Ab2HFSQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 14:16:24 -0400
X-Forefront-Antispam-Report: CIP:157.56.234.117;KIP:(null);UIP:(null);IPV:NLI;H:SN2PRD0510HT001.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: PS3(z5109h5105h32acnz98dIc89bh1432I4015Izz1202hzz8275ch8275bh8275dhz2fh2a8h668h839h93fhd25hf0ah107ah)
From: Dongjin Kim <Dongjin.Kim@agreeyamobility.net>
To: Thomas Abraham <thomas.abraham@linaro.org>,
        Dongjin Kim <tobetter@gmail.com>
CC: Kukjin Kim <kgene.kim@samsung.com>, Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Jon Medhurst <tixy@yxit.co.uk>,
        Shawn Guo <shawn.guo@linaro.org>,
        =?utf-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: =?utf-8?B?7ZqM7IugOiBbUEFUQ0hdIE9EUk9JRC1YOiBoa2RrNDQxMjogQWRkIG5ldyBo?=
 =?utf-8?Q?ardware_based_on_Exynos4412?=
Thread-Topic: [PATCH] ODROID-X: hkdk4412: Add new hardware based on
 Exynos4412
Thread-Index: AQHNc92ANlJ7ZpF870uQj1SyfcsbLJdNDJaAgAAH5mg=
Date: Mon, 6 Aug 2012 18:16:18 +0000
Message-ID: <A6A3B7488C419F488E5B13FFD03C08AD2F4362EE@SN2PRD0510MB370.namprd05.prod.outlook.com>
References: <1344262254-14648-1-git-send-email-dongjin.kim@agreeyamobility.net>,<CAJuYYwSjnQ6z0iUaLCV9guC7yyKH3_pbd1QZe3ELKF-fYNfaqQ@mail.gmail.com>
In-Reply-To: <CAJuYYwSjnQ6z0iUaLCV9guC7yyKH3_pbd1QZe3ELKF-fYNfaqQ@mail.gmail.com>
Accept-Language: ko-KR, en-US
Content-Language: ko-KR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [125.177.223.167]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: agreeyamobility.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q76IGWYu007079

Hello Tomas,

I am agree with you to look at using device tree and I have some plan for it.
But as of now I am focusing to bring up the hardware itself with mainline kernel and merge into it.
I also need some time to look at the requirement of device tree, because I am not familiar with it yet.

Any advice will be welcomed.

Thanks,
Dongjin.
________________________________________
ë³´ë‚¸ ì‚¬ëŒ: Thomas Abraham [thomas.abraham@linaro.org]
ë³´ë‚¸ ë‚ ì§œ: 2012ë…„ 8ì›” 7ì¼ í™”ìš”ì¼ ì˜¤ì „ 2:37
ë°›ëŠ” ì‚¬ëŒ: Dongjin Kim
ì°¸ì¡°: Dongjin Kim; Kukjin Kim; Russell King; Tony Lindgren; Jon Medhurst; Shawn Guo; Uwe Kleine-KÃ¶nig; linux-arm-kernel@lists.infradead.org; linux-samsung-soc@vger.kernel.org; linux-kernel@vger.kernel.org
ì œëª©: Re: [PATCH] ODROID-X: hkdk4412: Add new hardware based on Exynos4412

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

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

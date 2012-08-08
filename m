Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497Ab2HHClR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 22:41:17 -0400
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:27988
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754477Ab2HHClP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 22:41:15 -0400
X-Forefront-Antispam-Report: CIP:157.56.240.101;KIP:(null);UIP:(null);IPV:NLI;H:BL2PRD0510HT004.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: PS-3(z5109h5105hz98dIc89bh1432I111aIzz1202hzz8275ch8275bh8275dhz2fh2a8h668h839h93fhd25hf0ah107ah)
From: Dongjin Kim <Dongjin.Kim@agreeyamobility.net>
To: Kukjin Kim <kgene.kim@samsung.com>, "'Dongjin Kim'" <tobetter@gmail.com>
CC: "'Russell King'" <linux@arm.linux.org.uk>,
        "'Tony Lindgren'" <tony@atomide.com>,
        "'Jon Medhurst'" <tixy@yxit.co.uk>,
        "'Shawn Guo'" <shawn.guo@linaro.org>,
        =?utf-8?B?J1V3ZSBLbGVpbmUtS8O2bmlnJw==?= 
	<u.kleine-koenig@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: =?utf-8?B?7ZqM7IugOiBbUEFUQ0ggdjJdIE9EUk9JRC1YOiBoa2RrNDQxMjogQWRkIG5l?=
 =?utf-8?Q?w_hardware_based_on_Exynos4412?=
Thread-Topic: [PATCH v2] ODROID-X: hkdk4412: Add new hardware based on
 Exynos4412
Thread-Index: AQHNdM3A2f2tMpnHtUSlurbDHk87wZdPL/4AgAACa2g=
Date: Wed, 8 Aug 2012 02:41:03 +0000
Message-ID: <A6A3B7488C419F488E5B13FFD03C08AD2F43CB39@BL2PRD0510MB363.namprd05.prod.outlook.com>
References: <1344262254-14648-1-git-send-email-dongjin.kim@agreeyamobility.net>
 <1344365401-18591-1-git-send-email-dongjin.kim@agreeyamobility.net>,<0a4301cd750c$cd29d2e0$677d78a0$%kim@samsung.com>
In-Reply-To: <0a4301cd750c$cd29d2e0$677d78a0$%kim@samsung.com>
Accept-Language: ko-KR, en-US
Content-Language: ko-KR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [210.113.108.23]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: agreeyamobility.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q782fPNc019175

Hi,

Thank you for your advice.

And I didn't know non-DT board file will not be merged any more.
Rule is rule, I can manage the file in my git only.

I am very new to send git patches to open community, even I use git on my previous project.
I will pay attention to my next patches if I have more. :)

Thanks again.

Regards,
Dongjin.
________________________________________
ë³´ë‚¸ ì‚¬ëŒ: Kukjin Kim [kgene.kim@samsung.com]
ë³´ë‚¸ ë‚ ì§œ: 2012ë…„ 8ì›” 8ì¼ ìˆ˜ìš”ì¼ ì˜¤ì „ 11:23
ë°›ëŠ” ì‚¬ëŒ: 'Dongjin Kim'
ì°¸ì¡°: Dongjin Kim; 'Russell King'; 'Tony Lindgren'; 'Jon Medhurst'; 'Shawn Guo'; 'Uwe Kleine-KÃ¶nig'; linux-arm-kernel@lists.infradead.org; linux-samsung-soc@vger.kernel.org; linux-kernel@vger.kernel.org
ì œëª©: RE: [PATCH v2] ODROID-X: hkdk4412: Add new hardware based on Exynos4412

Dongjin Kim wrote:
>
Hi,

Basically, we don't add more board file for non-DT for EXYNOS SoCs...

> The HKDK4412 is the CPU module developed by Hardkernel which is based on
> Exynos 4412.  mach_hkdk4412.c is to run on ODROID-X hardware and Machine
> ID
> (4289) is registered.
>
This should be done at the link: http://www.arm.linux.org.uk/developer/machines/ by Russell King.

But I'm not sure whether it is worth to you without this patch for board file in mainline.

> Changes in v2:
>   -. Change regulator's display names
>
> Change-Id: Iea6825a17b2e13f96bc6d892dd5135cad899b5df

No need gerrit Change-Id here.

> Signed-off-by: Dongjin Kim <dongjin.kim@agreeyamobility.net>

If there is no reason, please use same e-mail address in the field of author and sign-off.

Note, if you want to use e-mail 'agreeyamobility.net', just add 'From: Dongjin Kim <dongjin.kim@agreeyamobility.net>', it's ok.

> ---
>  arch/arm/mach-exynos/Kconfig         |   23 +
>  arch/arm/mach-exynos/Makefile        |    1 +
>  arch/arm/mach-exynos/mach-hkdk4412.c |  964
> ++++++++++++++++++++++++++++++++++
>  arch/arm/tools/mach-types            |    1 +
>  4 files changed, 989 insertions(+)
>  create mode 100644 arch/arm/mach-exynos/mach-hkdk4412.c
>

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

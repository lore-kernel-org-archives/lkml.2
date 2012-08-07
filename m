Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619Ab2HGC4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 22:56:13 -0400
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:54632
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932591Ab2HGC4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 22:56:11 -0400
X-Forefront-Antispam-Report: CIP:157.56.234.117;KIP:(null);UIP:(null);IPV:NLI;H:SN2PRD0510HT002.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -14
X-BigFish: PS-14(z5109h5105hz98dI9371Ic89bhe48M1432I41c5Nzz1202hzz8275ch8275dhz2fh2a8h668h839h93fhd25hf0ah107ah)
From: Dongjin Kim <Dongjin.Kim@agreeyamobility.net>
To: Olof Johansson <olof@lixom.net>
CC: Thomas Abraham <thomas.abraham@linaro.org>,
        Dongjin Kim <tobetter@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Jon Medhurst <tixy@yxit.co.uk>,
        Shawn Guo <shawn.guo@linaro.org>,
        =?utf-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: =?utf-8?B?7ZqM7IugOiDtmozsi6A6IO2ajOyLoDogW1BBVENIXSBPRFJPSUQtWDogaGtk?=
 =?utf-8?Q?k4412:_Add_new_hardware_based_on_Exynos4412?=
Thread-Topic: =?utf-8?B?7ZqM7IugOiDtmozsi6A6IFtQQVRDSF0gT0RST0lELVg6IGhrZGs0NDEyOiBB?=
 =?utf-8?Q?dd_new_hardware_based_on_Exynos4412?=
Thread-Index: AQHNc92ANlJ7ZpF870uQj1SyfcsbLJdNDJaAgAAH5miAAAeygIAAd4uIgAANFoCAAAZKYA==
Date: Tue, 7 Aug 2012 02:56:06 +0000
Message-ID: <A6A3B7488C419F488E5B13FFD03C08AD2F4369FF@SN2PRD0510MB370.namprd05.prod.outlook.com>
References: <1344262254-14648-1-git-send-email-dongjin.kim@agreeyamobility.net>
	<CAJuYYwSjnQ6z0iUaLCV9guC7yyKH3_pbd1QZe3ELKF-fYNfaqQ@mail.gmail.com>
	<A6A3B7488C419F488E5B13FFD03C08AD2F4362EE@SN2PRD0510MB370.namprd05.prod.outlook.com>
	<CAOesGMh=6QrCmL4EqnSqTxi1nH+8Wn+x=z9BYq8QJCznH3a=zQ@mail.gmail.com>
	<A6A3B7488C419F488E5B13FFD03C08AD2F43688D@SN2PRD0510MB370.namprd05.prod.outlook.com>,<CAOesGMj6BafLCpZjmtyn_ASbpeic_8E0CdYjQGOf3A4_NHfy=Q@mail.gmail.com>
In-Reply-To: <CAOesGMj6BafLCpZjmtyn_ASbpeic_8E0CdYjQGOf3A4_NHfy=Q@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q772uHJk009638

Hi,

Thank you for your advice.
Fortunately I got ODROID-X hardware earlier and am able to boot with mainline kernel.

I will try to do alternative way first with source code kernel 3.0.15, and hope you review the patch if ready.

Regards,
Dongjin.
________________________________________
ë³´ë‚¸ ì‚¬ëŒ: Olof Johansson [olof@lixom.net]
ë³´ë‚¸ ë‚ ì§œ: 2012ë…„ 8ì›” 7ì¼ í™”ìš”ì¼ ì˜¤ì „ 11:28
ë°›ëŠ” ì‚¬ëŒ: Dongjin Kim
ì°¸ì¡°: Thomas Abraham; Dongjin Kim; Kukjin Kim; Russell King; Tony Lindgren; Jon Medhurst; Shawn Guo; Uwe Kleine-KÃ¶nig; linux-arm-kernel@lists.infradead.org; linux-samsung-soc@vger.kernel.org; linux-kernel@vger.kernel.org
ì œëª©: Re: íšŒì‹ : íšŒì‹ : [PATCH] ODROID-X: hkdk4412: Add new hardware based on Exynos4412

Hi,

On Mon, Aug 6, 2012 at 7:05 PM, Dongjin Kim
<Dongjin.Kim@agreeyamobility.net> wrote:
> Hello,
>
> I am trying to understand what I have to do for device tree.
>
> In order to create dts file for ODROID-X hardware, it seems I may need dts file of EXYNOS4412 SoC.
> But maybe exynos4412.dtsi is not merged yet or not exist, like exynos4210.dtsi or exynos5250.dtsi.
> Obviously it seems not easy to create such a file without SoC datasheet, and I do not have it.
>
> So do I wait for the file to be merged by Samsung or better to create initial dts file cloned from exynos4210.dtsi and modify to have verified nodes with the source/header files?

Ideally they already have one waiting to be submitted, but that might
not be the case. Given that the origenboard design with 4412 is not
yet shipping, I'm guessing the Linaro Samsung engineers might not have
done much work on 4412 yet. Kukjin? Thomas?

> What's your suggestion?

The alternative is to use the data you have available -- i.e. sources
and patches, and craft the device tree from there. The design of 4412
is a derivative from 4210, so that's a good start. Next step would be
to describe the board on top of the SoC, peripherals, etc. Take a look
at how the origen board support was added, and so on.

I ordered an odroid-x several weeks ago but I haven't have a confirmed
shipping date yet. :( I'm not sure how long it'll be before I can help
out, unfortunately.


-Olof

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

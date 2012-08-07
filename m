Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932541Ab2HGC2I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 22:28:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44572 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932243Ab2HGC2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 22:28:04 -0400
MIME-Version: 1.0
X-Originating-IP: [2001:470:1f05:1640:60c9:30:283e:2508]
In-Reply-To: <A6A3B7488C419F488E5B13FFD03C08AD2F43688D@SN2PRD0510MB370.namprd05.prod.outlook.com>
References: <1344262254-14648-1-git-send-email-dongjin.kim@agreeyamobility.net>
	<CAJuYYwSjnQ6z0iUaLCV9guC7yyKH3_pbd1QZe3ELKF-fYNfaqQ@mail.gmail.com>
	<A6A3B7488C419F488E5B13FFD03C08AD2F4362EE@SN2PRD0510MB370.namprd05.prod.outlook.com>
	<CAOesGMh=6QrCmL4EqnSqTxi1nH+8Wn+x=z9BYq8QJCznH3a=zQ@mail.gmail.com>
	<A6A3B7488C419F488E5B13FFD03C08AD2F43688D@SN2PRD0510MB370.namprd05.prod.outlook.com>
Date: Mon, 6 Aug 2012 19:28:03 -0700
Message-ID: <CAOesGMj6BafLCpZjmtyn_ASbpeic_8E0CdYjQGOf3A4_NHfy=Q@mail.gmail.com>
Subject: =?EUC-KR?B?UmU6IMi4vcU6IMi4vcU6IFtQQVRDSF0gT0RST0lELVg6IGhrZGs0NDEyOiBBZGQg?=
	=?EUC-KR?B?bmV3IGhhcmR3YXJlIGJhc2VkIG9uIEV4eW5vczQ0MTI=?=
From: Olof Johansson <olof@lixom.net>
To: Dongjin Kim <Dongjin.Kim@agreeyamobility.net>
Cc: Thomas Abraham <thomas.abraham@linaro.org>,
        Dongjin Kim <tobetter@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Jon Medhurst <tixy@yxit.co.uk>,
        Shawn Guo <shawn.guo@linaro.org>,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

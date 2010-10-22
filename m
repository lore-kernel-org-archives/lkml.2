Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586Ab0JVVmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 17:42:36 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4821 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab0JVVmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 17:42:35 -0400
X-PGP-Universal: processed;
	by hqnvupgp04.nvidia.com on Fri, 22 Oct 2010 14:42:26 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: Lars-Peter Clausen <lars@metafoo.de>,
        Anton Vorontsov <cbouatmailru@gmail.com>
CC: "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        Andrew Chew <AChew@nvidia.com>, "olof@lixom.net" <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 22 Oct 2010 14:41:55 -0700
Subject: RE: [PATCH v2] POWER: Add gpio charger driver
Thread-Topic: [PATCH v2] POWER: Add gpio charger driver
Thread-Index: ActxSB5Yfwvn2FrzShihLF1G4x8GJQA6bKLg
Message-ID: <E88A1D35AF5437468E5B14C7C4BA61C702D3E13A34@HQMAIL01.nvidia.com>
References: <1287663957-30099-1-git-send-email-lars@metafoo.de>
 <1287676501-23254-1-git-send-email-lars@metafoo.de>
 <20101021162617.GA10447@oksana.dev.rtsoft.ru> <4CC07CB4.9060108@metafoo.de>
In-Reply-To: <4CC07CB4.9060108@metafoo.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o9MLgnoX022050

> -----Original Message-----
> From: Lars-Peter Clausen [mailto:lars@metafoo.de]
> Sent: Thursday, October 21, 2010 10:48 AM
> To: Anton Vorontsov
> Cc: Rhyland Klein; broonie@opensource.wolfsonmicro.com; Andrew Chew;
> olof@lixom.net; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v2] POWER: Add gpio charger driver
> 
> Anton Vorontsov wrote:
> > On Thu, Oct 21, 2010 at 05:55:01PM +0200, Lars-Peter Clausen wrote:
> >> This patch adds a simple driver for chargers indicating their online
> status
> >> through a GPIO pin.
> >>
> >> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> >
> > Hm. I'm getting older, it seems. Now can anybody remind me why
> > pda_power.c doesn't work here? ;-)
> >
> > This driver looks like a light-weigh version of pda_power, except
> > that it can do GPIOs directly (instead of is_*_online() callbacks).
> >
> > Can we instead improve pda_power? Like this:
> >
> > 	if (!pdata->is_ac_online && pdata->ac_monitor_gpio)
> > 		pdata->is_ac_online = pda_ac_monitor_gpio;
> >
> > Should look quite cool, I think.
> >
> > (Plus, we might get rid of ac/usb stuff in that driver, and
> > pass enum power_supply_type to the callbacks instead).
> >
> 
> Hi
> 
> Hm... I guess it can be, but on the other hand most platform bus chargers
> type
> devices can be, because the pda_power driver is keep pretty generic with
> custom init,
> status and exit callbacks.
> 
> - Lars


Not sure what the state of this driver is, but I figured I would let you know that I tested
The driver on my platform and it does indeed work in place of my driver. So I am happy with this one :)

-rhyland
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

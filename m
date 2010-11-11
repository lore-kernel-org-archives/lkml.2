Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140Ab0KKA4O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 19:56:14 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2922 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932115Ab0KKA4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 19:56:10 -0500
X-PGP-Universal: processed;
	by hqnvupgp04.nvidia.com on Wed, 10 Nov 2010 16:55:58 -0800
From: Rhyland Klein <rklein@nvidia.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: Lars-Peter Clausen <lars@metafoo.de>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        Andrew Chew <AChew@nvidia.com>, "olof@lixom.net" <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 10 Nov 2010 16:53:12 -0800
Subject: RE: [PATCH v2] POWER: Add gpio charger driver
Thread-Topic: [PATCH v2] POWER: Add gpio charger driver
Thread-Index: Act8SGtQsPsB6sZrSuCdaGKUefx3OgE8jhIQ
Message-ID: <E88A1D35AF5437468E5B14C7C4BA61C702D41B4F4F@HQMAIL01.nvidia.com>
References: <1287663957-30099-1-git-send-email-lars@metafoo.de>
 <1287676501-23254-1-git-send-email-lars@metafoo.de>
 <20101021162617.GA10447@oksana.dev.rtsoft.ru> <4CC07CB4.9060108@metafoo.de>
 <E88A1D35AF5437468E5B14C7C4BA61C702D3E13FB3@HQMAIL01.nvidia.com>
 <20101104174746.GA16349@oksana.dev.rtsoft.ru>
In-Reply-To: <20101104174746.GA16349@oksana.dev.rtsoft.ru>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id oAB0ujlP001252

> From: Anton Vorontsov [mailto:cbouatmailru@gmail.com]
> Sent: Thursday, November 04, 2010 10:48 AM
> To: Rhyland Klein
> Cc: Lars-Peter Clausen; broonie@opensource.wolfsonmicro.com; Andrew Chew;
> olof@lixom.net; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v2] POWER: Add gpio charger driver
> 
> On Thu, Oct 28, 2010 at 02:17:41PM -0700, Rhyland Klein wrote:
> [...]
> > > Hm... I guess it can be, but on the other hand most platform bus
> chargers
> > > type
> > > devices can be, because the pda_power driver is keep pretty generic
> with
> > > custom init,
> > > status and exit callbacks.
> > >
> > > - Lars
> >
> > I didn't see any more discussion on this. Is the plan to integrate
> > the gpio-charger driver as is or to instead try to integrate support
> > for this into pda_power?
> 
> Sorry for the delayed response, and thanks for the pings! ;-)
> 
> The main thing I'm afraid of is duplication. I.e. someday you
> will want debouncing (include/linux/pda_power.h's wait_for_status,
> wait_for_charger parameters) support, regulators support etc.
> 
> And your gpio driver will look very similar to pda_power.
> 
> So I'd vote for adding the GPIO functionality to pda_power, and
> refactoring it if needed.
> 
> Though, if there are strong objections against this idea, I
> can merge the GPIO driver, and let's see how things will evolve.
> 
> Thanks!
> 
> --
> Anton Vorontsov
> email: cbouatmailru@gmail.com
> irc://irc.freenode.net/bd2

My guess, is that since no one has responded, no one is working on integrating the functionality into pda-power?

-rhyland
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333Ab2G0KW5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 06:22:57 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57273 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab2G0KWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 06:22:55 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: Thierry Reding <thierry.reding@avionic-design.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, Arnd Bergmann <arnd@arndb.de>,
        Shawn Guo <shawn.guo@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        =?utf-8?B?RXJpYyBCw6luYXJk?= <eric@eukrea.com>,
        Axel Lin <axel.lin@gmail.com>, Sachin Kamat <sachin.kamat@linaro.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Subject: RE: [GIT PULL] PWM subsystem for v3.6
Thread-Topic: [GIT PULL] PWM subsystem for v3.6
Thread-Index: AQHNa7aToLqM64myvk6AAvt0GsCep5c86m5A
Date: Fri, 27 Jul 2012 10:21:34 +0000
Deferred-Delivery: Fri, 27 Jul 2012 10:21:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3E977B7D@DBDE01.ent.ti.com>
References: <20120726071636.GA28129@avionic-0098.mockup.avionic-design.de>
 <CA+55aFy9JNZyhdTU+btUbBTKsHN1odX1-as=iTC_L9tZr=Oz1w@mail.gmail.com>
 <20120727051054.GA30771@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20120727051054.GA30771@avionic-0098.mockup.avionic-design.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q6RANAk9026169

On Fri, Jul 27, 2012 at 10:40:54, Thierry Reding wrote:
> On Thu, Jul 26, 2012 at 02:11:58PM -0700, Linus Torvalds wrote:
> > On Thu, Jul 26, 2012 at 12:16 AM, Thierry Reding
> > <thierry.reding@avionic-design.de> wrote:
> > >
> > > The new PWM subsystem aims at collecting all implementations of the
> > > legacy PWM API and to eventually replace it completely. The subsystem
> > > has been in development for over half a year now and many drivers have
> > > already been converted. It has been in linux-next for a couple of weeks
> > > and there have been no major issues so I think it is ready for inclusion
> > > in your tree.
> > 
> > For new subsystems like this, I really want ack's from the people who
> > are expected to use it.
> 
> At least the patch that adds me as the maintainer is Acked-by: Sascha
> Hauer, who did the original work, and Arnd Bergmann who was involved in
> the review process. Other people such as Shawn Guo and Mark Brown have
> also been reviewing these patches and new patches have been contributed
> by Eric BÃ©nard, Axel Lin, Sachin Kamat, Alexandre Courbot, Alexandre
> Pereira da Silva and Philip Avinash.
> 
> I'm adding all of them on Cc so they can ack this (I'm assuming acking
> this email will suffice).
> 

I found this framework very useful for supporting eCAP and eHRPWM driver on
TI's AM33xx platforms.

Acked-by: Philip, Avinash <avinashphilip@ti.com>

Avinash
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

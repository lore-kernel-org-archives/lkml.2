Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045Ab2EYGzN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 02:55:13 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:34621 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314Ab2EYGzL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 02:55:11 -0400
MIME-Version: 1.0
In-Reply-To: <20120524161720.GT3710@pengutronix.de>
References: <1337593269-2497-1-git-send-email-u.kleine-koenig@pengutronix.de>
	<1337628827-14484-1-git-send-email-u.kleine-koenig@pengutronix.de>
	<CACRpkdYJyUE-gM+wnOQvqW4Txuf65kEJsUbdJcBhkzRZYCxYDQ@mail.gmail.com>
	<20120524161720.GT3710@pengutronix.de>
Date: Fri, 25 May 2012 08:55:09 +0200
Message-ID: <CACRpkdZDrq3JvQaQN3qzfj2ENrLPoNbAk27oexyivJ+etpvzFg@mail.gmail.com>
Subject: Re: [PATCH v3] leds: Add MAX6956 driver
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 6:17 PM, Uwe Kleine-König
<u.kleine-koenig@pengutronix.de> wrote:
> On Mon, May 21, 2012 at 11:30:28PM +0200, Linus Walleij wrote:

>> The MFD driver decide using platform data whether each
>> line should be used for a LED or GPIO.
>>
>> Is there some problem with this design pattern?
>
> I thought about that, too, but I think it's overkill to create an mfd
> driver.

I have this driver:
drivers/mfd/tps6105x.c
drivers/regulator/tps6105x-regulator.c

It's not much code either but it has this nice split.

Discussing this in the past with Mark Brown we have often come
to the conclusion that having the MFD abstraction for multifunctional
chips is rather nice. But it's partly a question of aesthetics and I'm
not a perfectionist, there are indeed many examples to the contrary.

But this is what I would have done...

BTW: you need to include Andrew Morton in the postings since he's
merging most LED code these days.

Yours,
Linus Walleij

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab1BFNWL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 08:22:11 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48919 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab1BFNWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 08:22:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=e88jyzONsRF9NmAtMu8LN07w8SzEAYPjB5soBXUOaO3285uWo/tufUwQD7xhQu4qep
         SHF7uk1e3tsuUqmdHLqhxCNnYgld6ouIo/ItbK7aKhi+Vy/VfXJ10/0HhQZgDpl02E3t
         yyEqyhmvyarjgBBsaSGo/EixGle1+RL38SW94=
MIME-Version: 1.0
In-Reply-To: <20110131075803.GI9041@pengutronix.de>
References: <1296217283-14531-1-git-send-email-s.hauer@pengutronix.de>
	<20110129213821.0e51dc32@endymion.delvare>
	<20110129215141.GA3493@pengutronix.de>
	<AANLkTi=ppKZ96T3_1nYisHG9705OCHgZqkLnu2f47zq5@mail.gmail.com>
	<20110131075803.GI9041@pengutronix.de>
Date: Sun, 6 Feb 2011 14:22:09 +0100
X-Google-Sender-Auth: 0FMwf1ApcT-O6e8My2_G9BrFKXo
Message-ID: <AANLkTi=nDkuevMqY6v_K_Lkoi6wDowcL7AN_a=tb72t5@mail.gmail.com>
Subject: Re: [RFC] add pwmlib support
From: Linus Walleij <linus.walleij@linaro.org>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: arden jay <arden.jay@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Hemanth V <hemanthv@ti.com>, Wolfram Sang <w.sang@pengutronix.de>,
        Eric Miao <eric.miao@linaro.org>, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Shawn Guo <shawn.guo@freescale.com>, Ben Dooks <ben-linux@fluff.org>,
        Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>,
        Jean Delvare <khali@linux-fr.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/1/31 Sascha Hauer <s.hauer@pengutronix.de>:
> On Sun, Jan 30, 2011 at 11:49:32AM +0800, arden jay wrote:
>> Sorry, I'm confused about this.
>> If it is for backlight control, why it don't go through led_class?
>
> PWMs are not limited to backlight. As Jean pointed out they can be used
> for fans (or more generally motors) aswell. Have a look at
> drivers/leds/leds-pwm.c, it is a user of this pwm API.

Low-frequency PWM is used for vibrators of the type found in
silent mode cellphones, to mention another use case.

Yours,
Linus Walleij

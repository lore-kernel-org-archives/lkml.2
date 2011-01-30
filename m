Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab1A3Dtf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 22:49:35 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:37544 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab1A3Dte convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 22:49:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ent0/nspo1zcqFeJiZR4yNV3+xznaxNIhE/WcZFMVX7LmqiqFE6n0OlxjX657LdC4m
         G4CukYJXwHj3FY46myKEJifS7R3ZyxUkpP+PKFghSLN9lzgmF4m2WI4B4TmrFbJWkELj
         R2DyRwMKvUmYrERahL6zfGSC/bz6sD9mzEjsc=
MIME-Version: 1.0
In-Reply-To: <20110129215141.GA3493@pengutronix.de>
References: <1296217283-14531-1-git-send-email-s.hauer@pengutronix.de>
	<20110129213821.0e51dc32@endymion.delvare>
	<20110129215141.GA3493@pengutronix.de>
Date: Sun, 30 Jan 2011 11:49:32 +0800
Message-ID: <AANLkTi=ppKZ96T3_1nYisHG9705OCHgZqkLnu2f47zq5@mail.gmail.com>
Subject: Re: [RFC] add pwmlib support
From: arden jay <arden.jay@gmail.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Jean Delvare <khali@linux-fr.org>, Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel@vger.kernel.org, Eric Miao <eric.miao@linaro.org>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Hemanth V <hemanthv@ti.com>,
        linux-arm-kernel@lists.infradead.org,
        Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I'm confused about this.
If it is for backlight control, why it don't go through led_class?

Do I miss anything?

2011/1/30 Wolfram Sang <w.sang@pengutronix.de>:
>
>> > code is inspired by gpiolib support and tested using the backlight pwm
>                                                             ^^^^^^^^^
>> So I believe that hwmon drivers are out of scope for pwmlib. Which
>> makes me wonder what you intend to do with pwmlib (back to my first
>> question...) as the only use I know of for PWM signals in computers is
>> for fan control.
>
> It was meant for backlight control (was mentioned very indirectly).
> I also pointed him to Bill's implementation, too.
>
> Regards,
>
>   Wolfram
>
> --
> Pengutronix e.K.                           | Wolfram Sang                |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.9 (GNU/Linux)
>
> iEYEARECAAYFAk1Ei+0ACgkQD27XaX1/VRvjkACeOhJonBEZQX8U+ihKtiMjQT/U
> IfAAoMdZiOrAOvuH1Iv6ZKNYoT+VhhTM
> =ROYN
> -----END PGP SIGNATURE-----
>
>



-- 
cheers,
jay

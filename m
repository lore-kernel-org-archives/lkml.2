Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab1K2OAI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 09:00:08 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:59216 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab1K2OAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 09:00:06 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: MyungJoo Ham <myungjoo.ham@gmail.com>
Subject: Re: [RFC PATCH 0/3] introduce: Multistate Switch Class
Date: Tue, 29 Nov 2011 13:59:58 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Mike Lockwood <lockwood@android.com>,
        Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kalle Komierowski <karl.komierowski@stericsson.com>,
        Johan PALSSON <johan.palsson@stericsson.com>,
        Daniel WILLERUD <daniel.willerud@stericsson.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
References: <CAJ0PZbQBXF1f7F27bkkT_ezFFtFi7kRVbF5WZXn+ZenZj2hT7w@mail.gmail.com> <201111281753.45287.arnd@arndb.de> <CAJ0PZbT8FcCq=6GzLxOhhpRvCbCaJJEhE9_2GXXT4P0XZp6H-w@mail.gmail.com>
In-Reply-To: <CAJ0PZbT8FcCq=6GzLxOhhpRvCbCaJJEhE9_2GXXT4P0XZp6H-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111291359.59103.arnd@arndb.de>
X-Provags-ID: V02:K0:gOxGKkExxRzBTl91osrkfZHr06fAHa9ZOPwANtyjT5V
 d7csikiFoNcnzkzWfeo3/LKjaMaLFmDE4JVepP8vbjSMTT7lio
 MszPzuKclc6lgap9WteICeSE+63caaWU4AiEPhYIABKD/oWzRK
 Tsi9omyq1UqsKTnoCtKQJu16Ygq4q5rjwtwTIXfMtPbZvEBmcN
 mQI+QgzHLXTRGN7gURzHY1y88WBU3Vx46Dr5JqILbi1OC4+IQ7
 90/qHF8vp3+JG2FCf1IIOA/sOKHrHZZFP3WMoSW+BqjxgHvacI
 bBH7f3an4epHCxVLx6idvP24KkUng2yFJagFTWdELG9WQULSjM
 svi0P/S0PdP1I7gNUUH0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 November 2011, MyungJoo Ham wrote:
> For the next iteration, I'm considering the followings. It'd be much
> appreciated if I could get some comments about those beforehand.
>
> 2. move the location from /drivers/misc to an independent location.
> /drivers/switch? /drivers/multistate-switch? /drivers/msc?
> /drivers/mswitch? ...

Moving out of drivers/misc is a good idea. I don't have a strong
preference for any of the alternatives, but would probably pick
drivers/mswitch. drivers/switch is too generic, since we have lots
of things that are called a switch already, and drivers/multistate-switch
is much longer than any of the other alternatives. "msc" in turn
seems a bit too short and is not a well-established acronym yet.

	Arnd

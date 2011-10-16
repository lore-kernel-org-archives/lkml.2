Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589Ab1JPUWU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 16:22:20 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64073 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab1JPUWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 16:22:19 -0400
MIME-Version: 1.0
In-Reply-To: <CAPTzV15nEaE7kyH9XR36hTdg4xDRDsnnpTdqQ+2HSCEAQX=LvA@mail.gmail.com>
References: <1317629862-13549-1-git-send-email-linus.walleij@stericsson.com>
	<CAPTzV16bKaHxoyWEv1H8HGyY_CZhY9orXAuWA-wa0yb2NZ5UcA@mail.gmail.com>
	<CACRpkdY3scxhAw8dKENq=u0GNpSrkdpe5vKCemG7EWGvmFYxQg@mail.gmail.com>
	<CAPTzV15nEaE7kyH9XR36hTdg4xDRDsnnpTdqQ+2HSCEAQX=LvA@mail.gmail.com>
Date: Sun, 16 Oct 2011 22:22:18 +0200
X-Google-Sender-Auth: GLSfNolsCMM6fSvIt_YXcXZ055E
Message-ID: <CAKnu2MqLWmK023ZffczAsiN2cbf32nCjrjTb-inJk79TxmN42w@mail.gmail.com>
Subject: Re: [PATCH 1/2] drivers: create a pin control subsystem v9
From: Linus Walleij <linus.walleij@linaro.org>
To: Chanho Park <parkch98@gmail.com>
Cc: Stephen Warren <swarren@nvidia.com>, Sascha Hauer <s.hauer@pengutronix.de>,
        Barry Song <21cnbao@gmail.com>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Joe Perches <joe@perches.com>, Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Lee Jones <lee.jones@linaro.org>, David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org,
        Stijn Devriendt <highguy@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/14 Chanho Park <parkch98@gmail.com>:

> A gpio base number of gpio_range0 is 0 and pin base number is also 0.
> Converting gpio-pin number is no problem about the gpio_range0.
> A gpio base number of gpio_range1 is 32 but pin base number is 40(not 32).

Aha, I understand now, sorry I'm too slow in the head. :-/

Can you make a patch on top of the stuff that is currently
in linux-next adding the pin_base that you need?

I don't think there is any hurry of getting this in, but we sure
need to have it along with the first driver having this problem,
which I guess could be your driver.

Yours,
Linus Walleij

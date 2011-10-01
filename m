Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab1JAKja (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 06:39:30 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48380 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754998Ab1JAKjW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 06:39:22 -0400
MIME-Version: 1.0
In-Reply-To: <CACxGe6v19pZ0i-+ksYZbG2ZvGT30UkXEHTzpZMBTB4RNUV5bnA@mail.gmail.com>
References: <1317211419-18472-1-git-send-email-linus.walleij@stericsson.com>
	<20110930020754.GK12606@ponder.secretlab.ca>
	<CACRpkdYyyqB6=5M8reqgwpMxXJz5ttXWyOav6K58dQ0CrxwCNA@mail.gmail.com>
	<CACxGe6v19pZ0i-+ksYZbG2ZvGT30UkXEHTzpZMBTB4RNUV5bnA@mail.gmail.com>
Date: Sat, 1 Oct 2011 12:39:21 +0200
Message-ID: <CAKnu2MpQ8Wvd4TF8Ge=o8ACyEoaEY8TcvOSdT1w6zfYiSKFUiw@mail.gmail.com>
Subject: Re: [PATCH] drivers: create a pin control subsystem v8
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Stephen Warren <swarren@nvidia.com>, Sascha Hauer <s.hauer@pengutronix.de>,
        Barry Song <21cnbao@gmail.com>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Lee Jones <lee.jones@linaro.org>, David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org,
        Stijn Devriendt <highguy@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/30 Grant Likely <grant.likely@secretlab.ca>:

> I'm not convinced that the sysfs approach is
> actually the right interface here (I'm certainly not a fan of the gpio
> sysfs i/f), and I'd rather not be putting in unneeded stuff until the
> userspace i/f is hammered out.

Actually, thinking about it I cannot see what would be wrong
with /dev/gpio0 & friends in the first place.

Using sysfs as swiss army knife for custom I/O does not
seem like it would be long-term viable so thanks for this
observation, and I think we need /dev/gpio* put on some
mental roadmap somewhere.

Yours,
Linus Walleij

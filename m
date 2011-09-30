Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649Ab1I3RU5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 13:20:57 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:32962 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499Ab1I3RU4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 13:20:56 -0400
MIME-Version: 1.0
In-Reply-To: <CACxGe6v19pZ0i-+ksYZbG2ZvGT30UkXEHTzpZMBTB4RNUV5bnA@mail.gmail.com>
References: <1317211419-18472-1-git-send-email-linus.walleij@stericsson.com>
	<20110930020754.GK12606@ponder.secretlab.ca>
	<CACRpkdYyyqB6=5M8reqgwpMxXJz5ttXWyOav6K58dQ0CrxwCNA@mail.gmail.com>
	<CACxGe6v19pZ0i-+ksYZbG2ZvGT30UkXEHTzpZMBTB4RNUV5bnA@mail.gmail.com>
Date: Fri, 30 Sep 2011 19:20:56 +0200
Message-ID: <CACRpkdZxxLdJQEkG--5Uf8DX+-00yOecb_NMpf0QSpP8u5hR4w@mail.gmail.com>
Subject: Re: [PATCH] drivers: create a pin control subsystem v8
From: Linus Walleij <linus.walleij@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>, Barry Song <21cnbao@gmail.com>,
        Lee Jones <lee.jones@linaro.org>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Stijn Devriendt <highguy@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 7:07 PM, Grant Likely <grant.likely@secretlab.ca> wrote:

> [Me]
>> That is not the reason it's there actually, what we have
>> discussed on the mailing list is getting sysfs entries for the same
>> reason gpiolib registers a class: handle pin control from userspace,
>>(...)
>
> Sure, but you don't need the bus yet.  It can be added when it is
> actually needed.  I'm not convinced that the sysfs approach is
> actually the right interface here (I'm certainly not a fan of the gpio
> sysfs i/f), and I'd rather not be putting in unneeded stuff until the
> userspace i/f is hammered out.

OK I buy that, I will post a v9 without bus...

Thanks!
Linus Walleij

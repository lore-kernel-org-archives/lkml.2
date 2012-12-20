Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab2LTJqe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 04:46:34 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:56957 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab2LTJqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 04:46:11 -0500
MIME-Version: 1.0
In-Reply-To: <50D2D91B.8010203@ti.com>
References: <1354791127-20545-1-git-send-email-peter.ujfalusi@ti.com>
 <1354791127-20545-4-git-send-email-peter.ujfalusi@ti.com> <20121219170737.E5DB13E0C56@localhost>
 <50D2D91B.8010203@ti.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 20 Dec 2012 09:45:50 +0000
X-Google-Sender-Auth: A4FY6TQ9q_qmGbpSmYpqC9j4-qw
Message-ID: <CACxGe6tBoyp3oXJP-uoDxHnP2YPJn2E-f1CToqpp20nqapOiJQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] gpio: twl4030: TODO comment to remove the PWMA/B
 (LEDA/B) handling
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 9:23 AM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> On 12/19/2012 06:07 PM, Grant Likely wrote:
>> On Thu, 6 Dec 2012 11:52:07 +0100, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
>>> This GPIO driver should not configure anything else then GPIOs.
>>>
>>> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
>>
>> I'm not sure if this is the right direction. I actually have no problem
>> with a single driver that registers itself with multiple interfaces (ie.
>> GPIO and PWM) if it makes sense for it to do so. I suspec that a lot of
>> the multifunction device drivers break things up more than is strictly
>> necessary.
>
> We have PWM drivers for these IPs. As you remember this is the reason I
> started to work on the gpio-pwm driver so we can have cleaner, more generic
> way to map a PWM as a gpio. I really don't like the idea of having the same
> PWM code sitting in various places in the kernel just because it was easier to
> hack it like that rather then to make an effort for a clean implementation.
> The PWM handling in the gpio-twl4030 driver is a prime example of this IMHO.
> It is just a shortcut, nothing else.

Ah, right. (there's nothing wrong with my memory, it's just short)  :-p

g.

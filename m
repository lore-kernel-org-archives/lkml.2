Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab2KTSm5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 13:42:57 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:35381 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab2KTSmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 13:42:55 -0500
MIME-Version: 1.0
In-Reply-To: <50AA23C4.1000706@ti.com>
References: <1352799313-21019-1-git-send-email-peter.ujfalusi@ti.com>
	<CACRpkdayZK2sPXJW=COFi7C=P5=fbi-q7UukWbQ8dheaJ=bjAA@mail.gmail.com>
	<50A9F335.80107@ti.com>
	<CACRpkdbvXFtHoOXThUrT4Z+8nO_HJCFq-May+4zaOsNv-886LA@mail.gmail.com>
	<50AA23C4.1000706@ti.com>
Date: Tue, 20 Nov 2012 19:42:52 +0100
Message-ID: <CACRpkda6s2_76_GAWk3u5zEvRjjtE07wSah7orym_=19vJvmRA@mail.gmail.com>
Subject: Re: [PATCH] gpio: twl4030: Use only TWL4030_MODULE_LED for LED configuration
From: Linus Walleij <linus.walleij@linaro.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Sascha Hauer <kernel@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 1:19 PM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> On 11/19/2012 11:40 AM, Linus Walleij wrote:
>> So what we're dealing with is: a LED-specific PWM, being used
>> as a PWM with eternal dutycycle and then being used as GPIO.
>>
>> Well, we get to deal with it ... :-/
>
> gpio/gpio-pwm driver?

Yeah something like that, but such a driver would need some huge
boilerplate saying that this approach isn't entirely sound.

Yours,
Linus Walleij

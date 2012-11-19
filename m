Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab2KSMXL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 07:23:11 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:58534 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab2KSMXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 07:23:10 -0500
Message-ID: <50AA24A2.2040902@ti.com>
Date: Mon, 19 Nov 2012 13:22:58 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121105 Thunderbird/16.0.1
MIME-Version: 1.0
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] gpio: twl4030: Use only TWL4030_MODULE_LED for LED configuration
References: <1352799313-21019-1-git-send-email-peter.ujfalusi@ti.com> <CACRpkdayZK2sPXJW=COFi7C=P5=fbi-q7UukWbQ8dheaJ=bjAA@mail.gmail.com> <50A9F335.80107@ti.com> <CACRpkdbvXFtHoOXThUrT4Z+8nO_HJCFq-May+4zaOsNv-886LA@mail.gmail.com> <20121119105759.GU10369@pengutronix.de>
In-Reply-To: <20121119105759.GU10369@pengutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha,

On 11/19/2012 11:57 AM, Sascha Hauer wrote:
> Either I'm misinterpreting you or you didn't have a look in the tree.
> Actually drivers/leds/leds-pwm.c already exists.
>>
>> Sounds correct, Sascha?
> 
> Yes, the twl4030 pwm should go to drivers/pwm/pwm-twl4030.c.

I have already done the generic PWM drivers for the two type of PWMs (named
PWM, and the LED PWMs):
https://lkml.org/lkml/2012/11/8/219

They are happily using leds-pwm and backlight-pwm on my working tree.
I also sent cleanup and DT support for leds-pwm:
https://lkml.org/lkml/2012/11/12/222

-- 
Péter

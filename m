Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab2L2MDX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 07:03:23 -0500
Received: from antcom.de ([188.40.178.216]:59678 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099Ab2L2MDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 07:03:21 -0500
Message-ID: <50DEDB99.5080701@antcom.de>
Date: Sat, 29 Dec 2012 13:01:29 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121122 Icedove/10.0.11
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, highguy@gmail.com,
        broonie@opensource.wolfsonmicro.com, daniel-gl@gmx.net,
        rmallon@gmail.com, sr@denx.de, wg@grandegger.com,
        tru@work-microwave.de, mark.rutland@arm.com
Subject: Re: [PATCH 0/6 v12] gpio: Add block GPIO
References: <1356281376-25853-1-git-send-email-stigge@antcom.de> <20121229102017.GA7360@game.jcrosoft.org>
In-Reply-To: <20121229102017.GA7360@game.jcrosoft.org>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 29/12/12 11:20, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 17:49 Sun 23 Dec     , Roland Stigge wrote:
>> This set of patches adds:
>>
>> * Block GPIO API to gpiolib
>> * Sysfs support for GPIO API, to provide userland access
>> * Device interface for userland access (alternative to sysfs)
>> * Devicetree support to instantiate GPIO blocks via DT
>> * Example implementations in several gpio drivers since they need
>>   special accessor functions for block wise GPIO access (only for some
>>   selected drivers since the feature is optional and not suitable for
>>   all GPIO hardware)
>> * Fix for race condition in gpiolib on device creation
>>
>> Signed-off-by: Roland Stigge <stigge@antcom.de>
>> Tested by: Wolfgang Grandegger <wg@grandegger.com>
>> --
>>
>> Testing branch available at: git://git.antcom.de/linux-2.6.git blockgpio
>>
>> Changes since v11:
>> * Removed support for at91, since this one is currently in the migration
>>   process to pinctrl implementation
> already done for 3.8
> 
> in Linus tree

Good, thanks for the note! So we include support for block GPIO in
pinctrl-at91.c now.

I guess the redundant code in arch/arm/mach-at91/gpio.c will be removed?

Thanks,

Roland

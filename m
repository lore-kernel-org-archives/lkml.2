Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496Ab2LTIHZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 03:07:25 -0500
Received: from ngcobalt02.manitu.net ([217.11.48.102]:46627 "EHLO
	ngcobalt02.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab2LTIHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 03:07:18 -0500
X-manitu-Original-Sender-IP: 88.217.87.81
X-manitu-Original-Receiver-Name: ngcobalt02.manitu.net
Message-ID: <50D2C731.1080009@grandegger.com>
Date: Thu, 20 Dec 2012 09:07:13 +0100
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: Roland Stigge <stigge@antcom.de>, gregkh@linuxfoundation.org,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de, highguy@gmail.com,
        broonie@opensource.wolfsonmicro.com, daniel-gl@gmx.net,
        rmallon@gmail.com, sr@denx.de, tru@work-microwave.de,
        mark.rutland@arm.com
Subject: Re: [PATCH 6/6 v11] gpio: Add block gpio to several gpio drivers
References: <1355952138-20459-1-git-send-email-stigge@antcom.de> <1355952138-20459-7-git-send-email-stigge@antcom.de> <20121220070805.GQ23971@game.jcrosoft.org>
In-Reply-To: <20121220070805.GQ23971@game.jcrosoft.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2012 08:08 AM, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 22:22 Wed 19 Dec     , Roland Stigge wrote:
>> This patch adds block GPIO support to several gpio drivers.
>>
>> This implements block GPIO only for some selected drivers since block GPIO is
>> an optional feature which may not be suitable for every GPIO hardware. (With
>> automatic fallback to the single GPIO functions if not available in a driver.)
>>
>> Signed-off-by: Roland Stigge <stigge@antcom.de>
>>
>> ---
>>  arch/arm/mach-at91/gpio.c         |   33 +++++++++++++++
> as said on the previous version the mach-at91 is deprecated for this platform
> and boards
> 
> you MUST updatethe drivers/pinctrl/pinctrl-at91
> 
> nack on at91 untill this is done

I suggest to drop the hunk for the AT91 for the moment and wait until
the block gpio interface is accepted. Then we can add the block gpio
enhancement to the GPIO drivers in arch/... not only for the AT91...
also because they have to go through different sub-systems maintainers.

Wolfgang.

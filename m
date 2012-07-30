Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773Ab2G3GyE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 02:54:04 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47911 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253Ab2G3GyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 02:54:01 -0400
Message-ID: <50162F70.2050900@linaro.org>
Date: Mon, 30 Jul 2012 07:53:36 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 05/18] ASoC: Ux500: Enable ux500 MSP driver for Device
 Tree
References: <1343393162-11938-1-git-send-email-lee.jones@linaro.org> <1343393162-11938-6-git-send-email-lee.jones@linaro.org> <20120729204218.GI4384@opensource.wolfsonmicro.com>
In-Reply-To: <20120729204218.GI4384@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/07/12 21:42, Mark Brown wrote:
> On Fri, Jul 27, 2012 at 01:45:49PM +0100, Lee Jones wrote:
>
>> +	if (of_get_property(np, "stericsson,use-pinctrl", NULL))
>> +		msp->use_pinctrl = true;
>> +	else
>> +		msp->use_pinctrl = false;
>
> I don't recall seeing any response to my query about this on the first
> iteration.  Please don't just ignore review comments.

It wasn't intentional. I must have missed it before.

> This doesn't seem particularly sane...  why is this conditional?

It's conditional because only MSP1 and MSP3 have pinctrl support.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

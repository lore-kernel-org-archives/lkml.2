Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321Ab2G3Hcr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 03:32:47 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51611 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab2G3Hcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 03:32:46 -0400
Message-ID: <5016389B.4020003@linaro.org>
Date: Mon, 30 Jul 2012 08:32:43 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 13/18] ARM: ux500: Add ux500 PCM to DB8500 Device Tree
References: <1343393162-11938-1-git-send-email-lee.jones@linaro.org> <1343393162-11938-14-git-send-email-lee.jones@linaro.org> <20120729205001.GK4384@opensource.wolfsonmicro.com>
In-Reply-To: <20120729205001.GK4384@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/07/12 21:50, Mark Brown wrote:
> On Fri, Jul 27, 2012 at 01:45:57PM +0100, Lee Jones wrote:
>> Nothing special here. We're only providing a compatible string
>> to ensure the driver is probed using a Device Tree boot.
>
>> +		pcm: ux500-pcm {
>> +			compatible = "stericsson,ux500-pcm";
>> +		};
>> +
>
> One of two things is wrong here.  Either you've not provided any
> information about the hardware so the driver won't be able to work out
> what to talk to or you've not provided any data so you're registering a
> purely virtual Linux-internal device via the device tree.
>
> Once more, the idea here is to describe the hardware not to dump Linux's
> internal data structures into the device tree.

We use it register the driver for probe()ing. In the same way we do for 
the PMU and Regulators. All three of which actually belong to a 
different hardware block. Do you know of a better way to register those 
devices?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

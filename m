Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489Ab2G3HfW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 03:35:22 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47764 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab2G3HfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 03:35:21 -0400
Message-ID: <50163936.1050901@linaro.org>
Date: Mon, 30 Jul 2012 08:35:18 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 17/18] ARM: ux500: Add all encompassing Sound node to
 DB8500 Device Tree
References: <1343393162-11938-1-git-send-email-lee.jones@linaro.org> <1343393162-11938-18-git-send-email-lee.jones@linaro.org> <20120729205227.GL4384@opensource.wolfsonmicro.com>
In-Reply-To: <20120729205227.GL4384@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/07/12 21:52, Mark Brown wrote:
> On Fri, Jul 27, 2012 at 01:46:01PM +0100, Lee Jones wrote:
>
>>   arch/arm/boot/dts/db8500.dtsi |    8 ++++++++
>
> This is a generic DT include file but...
>
>> +		sound {
>> +			compatible = "stericsson,snd-soc-mop500";
>> +
>> +			stericsson,platform-pcm-dma = <&pcm>;
>> +			stericsson,cpu-dai = <&msp1 &msp3>;
>> +			stericsson,audio-codec = <&codec>;
>> +		};
>
> ...this is clearly the board-specific setup for the system, showing how
> the CPU and CODEC are hooked up.  This should therefore be in the DT for
> whatever board this is you're working on.

I don't think it's board specific. I believe this is the setup on all 
db8500 platforms. I'm happy to be told I'm wrong here, in which case I 
can move it to the board specific files.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

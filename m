Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab2G3OcO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 10:32:14 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36289 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270Ab2G3OcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 10:32:12 -0400
Message-ID: <50169AE8.4020601@linaro.org>
Date: Mon, 30 Jul 2012 15:32:08 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 01/18] Documentation: Describe the ux500 realated audio
 related DT nodes
References: <1343393162-11938-1-git-send-email-lee.jones@linaro.org> <1343393162-11938-2-git-send-email-lee.jones@linaro.org> <20120729203106.GD4384@opensource.wolfsonmicro.com> <50163A09.8060203@linaro.org> <20120730134804.GE4468@opensource.wolfsonmicro.com>
In-Reply-To: <20120730134804.GE4468@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/07/12 14:48, Mark Brown wrote:
> On Mon, Jul 30, 2012 at 08:38:49AM +0100, Lee Jones wrote:
>> On 29/07/12 21:31, Mark Brown wrote:
>>> On Fri, Jul 27, 2012 at 01:45:45PM +0100, Lee Jones wrote:
>
>>>> +   - Machine Driver : "stericsson,snd-soc-mop500"
>>>> +   - CPU-side DAI   : "stericsson,ux500-msp-i2s"
>>>> +   - DMA (platform) : "stericsson,ux500-pcm"
>>>> +   - Audio CODEC    : "stericsson,ab8500-codec"
>
>>> What is this a binding document for?  It looks like the binding for a
>>> machine driver...
>
>> No, it's a binding document for all of the ux500 driver and CODEC
>> blocks. Do you really want me to split it all up? I think the only
>> component which could be sanely split-out is the ab8500-codec, which
>> could (should?) live in [1].
>
> Yes, of course!  Each device will have a separate binding with different
> requirements.
>
>> These properties are relevant for some, but not all of the
>> components above, hence why the are listed at 'optional properties'.
>
> Which is part of the problem here, it makes it much harder to tell what
> you need to do for the individual devices.

Once again, I'll split them out, but I think there are people talking 
about documentation consolidation, as it's going to become very messy, 
very quickly if we keep adding new files for each device. Soon the 
Documentation directory will be as large as the driver base. :)

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

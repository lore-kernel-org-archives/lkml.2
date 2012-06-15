Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758Ab2FOLoF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 07:44:05 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48676 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756682Ab2FOLoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 07:44:01 -0400
Message-ID: <4FDB1FFD.7040204@linaro.org>
Date: Fri, 15 Jun 2012 12:43:57 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linus.walleij@stericsson.com, arnd@arndb.de,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 09/14] i2c: Add Device Tree support to the Nomadik I2C
 driver
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org> <1339428307-3850-10-git-send-email-lee.jones@linaro.org> <CACRpkdaMDbH4NkiHRLAfbJZ_j4QXbwg94bvaWsdYRPH+dSfc8Q@mail.gmail.com> <4FD6F0E8.5040606@linaro.org> <CACRpkdYxiT-0x4aetMxB2x8SkB+Mmy8rk8uSzgU_anemSayhMw@mail.gmail.com> <4FD83AAD.2010701@linaro.org> <CACRpkdZC8E6izDpdnWy6DMjOdA6KsqTaPoaq9pErWoNW0Ewytw@mail.gmail.com> <4FD88761.9050703@linaro.org> <20120614183636.GB30185@sirena.org.uk> <4FDA341C.8010501@linaro.org> <20120615103233.GA19046@n2100.arm.linux.org.uk>
In-Reply-To: <20120615103233.GA19046@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/06/12 11:32, Russell King - ARM Linux wrote:
> On Thu, Jun 14, 2012 at 07:57:32PM +0100, Lee Jones wrote:
>> On 14/06/12 19:36, Mark Brown wrote:
>>> On Wed, Jun 13, 2012 at 01:28:17PM +0100, Lee Jones wrote:
>>>
>>>> Device Tree. However, we have just as much control by keeping them
>>>> in separate structs in the C file and selecting the right one using
>>>> the compatible sting.
>>>
>>> You're not understanding Linus' point.  The compatible string isn't
>>> useful here because properties like the maximum clock rate of the bus
>>> depend on the board design, not the silicon.  The controller may be
>>> perfectly happy to run at a given rate but other devices on the bus or
>>> the electrical engineering of the PCB itself may restrict this further.
>>
>> And you're not understanding mine. ;)
>>
>> You can have multiple compatible strings for a single driver. Which one
>> you reference from the Device Tree will dictate which group of settings
>> are used, including variation of clock rates.
>
> However, if you list these settings separately, rather than selecting them
> based on a compatible string, it means when other board designs come along,
> you don't have to modify the kernel code to provide yet another compatible
> to settings translation in the code - you can keep all that information
> entirely within DT with no kernel code mods.
>
> I thought that was partly the point of DT...

Right. See my most recent emails on the subject. :)

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

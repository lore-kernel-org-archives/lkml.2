Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab2LLKLw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 05:11:52 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:35828 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753820Ab2LLKLu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 05:11:50 -0500
Message-ID: <50C85850.7010906@ti.com>
Date: Wed, 12 Dec 2012 11:11:28 +0100
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Javier Martinez Canillas <martinez.javier@gmail.com>
CC: Tony Lindgren <tony@atomide.com>, <grant.likely@secretlab.ca>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Ezequiel Garcia <elezegarcia@gmail.com>,
        Enrico Butera <ebutera@gmail.com>,
        Matthias Brugger <matthias.bgg@googlemail.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/3] ARM/dts: omap3: Add DT support for IGEP devices
References: <1354538503-22671-1-git-send-email-javier.martinez@collabora.co.uk> <CAAwP0s2qXuJzwEh-AVORbPApr6XT0JAfsFjrxKDvXArqYk0qXQ@mail.gmail.com>
In-Reply-To: <CAAwP0s2qXuJzwEh-AVORbPApr6XT0JAfsFjrxKDvXArqYk0qXQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Javier,

On 12/12/2012 09:25 AM, Javier Martinez Canillas wrote:
> On Mon, Dec 3, 2012 at 1:41 PM, Javier Martinez Canillas
> <javier.martinez@collabora.co.uk> wrote:
>> IGEP technology devices are TI OMAP3 SoC based industrial embedded
>> and computer-on-module boards. This patch-set adds initial device
>> tree support for these devices.
>>
>> The device trees allows to boot from an MMC and are working all the
>> components that already have device tree support on OMAP3 SoCs:
>>
>> - MMC/SD
>> - UARTs
>> - GPIO LEDs
>> - TWL4030 codec audio
>> - pinmux/pinconf pinctrl
>>
>> Some peripheral are still not working such as Flash storage and
>> Ethernet but support for these will also be included once the
>> OMAP GPMC device tree binding patches land on mainline.
>>
>> This is a v3 of the patch-set that solves issues pointed out by
>> Enric Balletbo and Benoit Cousson.
>>
>> The patch-set is composed of the following patches:
>>
>> [PATCH v3 1/3] ARM/dts: omap3: Add generic DT support for IGEP devices
>> [PATCH v3 2/3] ARM/dts: omap3: Add support for IGEPv2 board
>> [PATCH v3 3/3] ARM/dts: omap3: Add support for IGEP COM Module
>>
>> Best regards,
>> Javier
>> --
> 
> Hi Benoit and Tony,
> 
> Any comments on these?

Nope, that's fine. I'll applied the series for 3.9.

Thanks,
Benoit



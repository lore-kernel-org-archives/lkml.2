Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab2LCKtw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 05:49:52 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:54133 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754119Ab2LCKtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 05:49:50 -0500
Message-ID: <50BC83BE.2020202@ti.com>
Date: Mon, 3 Dec 2012 11:49:34 +0100
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
CC: Tony Lindgren <tony@atomide.com>, <grant.likely@secretlab.ca>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Ezequiel Garcia <elezegarcia@gmail.com>,
        Enrico Butera <ebutera@gmail.com>,
        Matthias Brugger <matthias.bgg@googlemail.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] ARM/dts: omap3: Add DT support for IGEP devices
References: <1354270137-31538-1-git-send-email-javier.martinez@collabora.co.uk>
In-Reply-To: <1354270137-31538-1-git-send-email-javier.martinez@collabora.co.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Javier,

On 11/30/2012 11:08 AM, Javier Martinez Canillas wrote:
> IGEP technology devices are TI OMAP3 SoC based industrial embedded
> and computer-on-module boards. This patch-set adds initial device
> tree support for these devices.
> 
> The device tree allows to boot from an MMC/SD and are working all
> the components that already have device tree support on OMAP3 SoCs:

That's cool to have one more board DT converted.

That series looks good to me, I just have a comment on the DT mux stuff.

Regards,
Benoit

> 
> - MMC/SD
> - UARTs
> - GPIO LEDs
> - TWL4030 codec audio
> - pinmux/pinconf pinctrl
> 
> Some peripheral are still not working such as Flash storage and
> Ethernet but support for these will also be included once the
> OMAP GPMC device tree binding patches hit mainline.
> 
> This is a v2 of the patch-set that solves issues pointed out by
> Enric Balletbo and it is composed of the following patches:
> 
> [PATCH v2 1/3] ARM/dts: omap3: Add generic DT support for IGEP devices
> [PATCH v2 2/3] ARM/dts: omap3: Add support for IGEPv2 board
> [PATCH v2 3/3] ARM/dts: omap3: Add support for IGEP COM Module
> 
> Best regards,
> Javier
> 


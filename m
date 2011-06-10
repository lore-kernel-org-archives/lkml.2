Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479Ab1FJA2j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 20:28:39 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:37336 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975Ab1FJA2g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 20:28:36 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-127.messagelabs.com!1307665716!16042387!1
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.180]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Ryan Mallon <rmallon@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Andre Renaud <andre@bluewatersys.com>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Victor <avictor.za@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Anton Vorontsov <cbou@mail.ru>,
        Paul Mundt <lethal@linux-sh.org>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "trivial@kernel.org" <trivial@kernel.org>
Date: Thu, 9 Jun 2011 19:28:34 -0500
Subject: RE: [PATCH trival/tree-wide] Change Ryan Mallon's email address
 across the kernel
Thread-Topic: [PATCH trival/tree-wide] Change Ryan Mallon's email address
 across the kernel
Thread-Index: Acwm+tXyIwV5eRlqSTKxH0u/EYcDBQACaCHg
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F3820B86BF@AUSP01VMBX24.collaborationhost.net>
References: <1307661170-9325-1-git-send-email-rmallon@gmail.com>
In-Reply-To: <1307661170-9325-1-git-send-email-rmallon@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 09, 2011 4:13 PM, Ryan Mallon wrote:
>
> I no longer work at Bluewater Systems. Update my email address accordingly.
>
> Signed-off-by: Ryan Mallon <rmallon@gmail.com>
> Cc: Andre Renaud <andre@bluewatersys.com>
> Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Andrew Victor <avictor.za@gmail.com>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Anton Vorontsov <cbou@mail.ru>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: Liam Girdwood <lrg@ti.com>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: trivial@kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---

Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>

Ryan,

There will probable be some merge conflicts with this.

> MAINTAINERS                            |    2 +-
> arch/arm/mach-at91/board-snapper9260.c |    2 +-
> arch/arm/mach-ep93xx/dma-m2p.c         |    2 +-

This file is gone after Mika's DMA patches which are already in linux-next.

> arch/arm/mach-ep93xx/gpio.c            |    2 +-

This file has been moved and renamed.  There are also a number of patches
already applied to it in linux-next.

> arch/arm/mach-ep93xx/simone.c          |    4 ++--
> arch/arm/mach-ep93xx/snappercl15.c     |    4 ++--
> drivers/mtd/devices/sst25l.c           |    4 ++--

There are a couple patches to this file in linux-next.

> drivers/power/ds2782_battery.c         |    4 ++--
> drivers/video/ep93xx-fb.c              |    2 +-
> sound/soc/ep93xx/ep93xx-i2s.c          |    4 ++--
> sound/soc/ep93xx/ep93xx-pcm.c          |    4 ++--
> sound/soc/ep93xx/snappercl15.c         |    4 ++--

The others should be ok.  Maybe you should rebase this patch against
linux-next?

Regards,
Hartley
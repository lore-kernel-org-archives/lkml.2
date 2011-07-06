Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838Ab1GFTpx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 15:45:53 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:52457 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753865Ab1GFTpw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 15:45:52 -0400
From: =?ISO-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>
To: <alsa-devel@alsa-project.org>
CC: "Girdwood, Liam" <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Balbi, Felipe" <balbi@ti.com>,
        "Lopez Cruz, Misael" <misael.lopez@ti.com>
Subject: Re: [alsa-devel] [PATCH v3 0/5] MFD/input/ASoC: twl6040: irq registration changes
Date: Wed, 6 Jul 2011 22:45:37 +0300
Message-ID: <2691573.u38zO5bac0@barack>
User-Agent: KMail/4.6.0 (Linux/2.6.39-gentoo; KDE/4.6.4; x86_64; ; )
In-Reply-To: <1309895376-17446-1-git-send-email-peter.ujfalusi@ti.com>
References: <1309895376-17446-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel, Dmitry,

would you be able to take a look at this series?

Thank you,
Péter

On Tuesday 05 July 2011 21:49:31 Ujfalusi, Peter wrote:
> Hello,
> 
> Changes since v2:
> - Fix the check in the slaves driver for the validity of the received irq
> - Mark Brown's ack added to patch 3
> 
> Intro mail froim v1:
> As Samuel, and Felipe requested for the twl6040 MFD series:
> http://marc.info/?l=linux-kernel&m=130978512225430&w=2
> http://marc.info/?l=linux-omap&m=130978403224218&w=2
> 
> This is the update to remove the obfuscation around the threaded irq request
> in the twl6040 driver and it's slaves.
> 
> With this change the slaves uses directly the threaded irq request, and the
> core driver passes the irq number for the slaves to use (configured runtime,
> so machine drivers do not need to be updated).
> 
> Regards,
> Peter
> 
> PS: for the remaining comments from Samuel I have changed the series, since
> the requested change was small.
> I'm not intended to send the series again, unless it is requested (again the
> change from v6 is minimal - few lines has been removed/replaced).
> 
> ---
> Peter Ujfalusi (5):
>   MFD: twl6040: Use resource to provide irq number for slaves
>   input: twl6040-vibra: Do not use wrapper for irq request
>   ASoC: twl6040: Do not use wrapper for irq request
>   MFD: twl6040: Demand valid interrupt configuration
>   MFD: twl6040: Remove wrapper for threaded irq request
> 
>  drivers/input/misc/twl6040-vibra.c |   17 ++++++---
>  drivers/mfd/twl6040-core.c         |   69
> ++++++++++++++++++++++++----------- drivers/mfd/twl6040-irq.c          |  
> 16 +--------
>  include/linux/mfd/twl6040.h        |   22 -----------
>  sound/soc/codecs/twl6040.c         |   19 +++++++---
>  5 files changed, 74 insertions(+), 69 deletions(-)


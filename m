Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab1GFFri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 01:47:38 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47826 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab1GFFrh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 01:47:37 -0400
From: =?ISO-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: alsa-devel@alsa-project.org, "Girdwood, Liam" <lrg@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Lopez Cruz, Misael" <misael.lopez@ti.com>
Subject: Re: [alsa-devel] [PATCH 0/6] ASoC/MFD: twl6040: PLL handling changes
Date: Wed, 6 Jul 2011 08:47:25 +0300
Message-ID: <1413350.0mreIEaYWF@barack>
User-Agent: KMail/4.6.0 (Linux/2.6.39-gentoo; KDE/4.6.4; x86_64; ; )
In-Reply-To: <1309773958-14608-1-git-send-email-peter.ujfalusi@ti.com>
References: <1309773958-14608-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On Monday 04 July 2011 12:05:52 Ujfalusi, Peter wrote:
> Hello,
> 
> The following series depends on the v6 of twl6040 MFD series.
> 
> The aim is to simplify the PLL handling for twl6040:
> - Move the PLL selection control to the codec driver from machine driver
> - Sample rate constraint simplification for selected PLL
> - Avoid multiple, duplicated PLL configuration, which can slow down the
> audio startup.
> - Harmonize the PLL ID usage among the drivers, so we avoid redundancy.
> 
> I have generated this series on top of l-o/devel-cleanup branch + my
> previous twl6040 MFD/Input/ASoC v6 series, since it depends on the changes
> introduced there.
> Is it OK, if Tony will be taking this as well to avoid cross tree merge
> issues? I can put the series on top of my previous series, and offer Tony a
> pull link.

would you be able to check patch 5 in this series?

Thank you,
Péter

> 
> Regards,
> Peter
> 
> ---
> Peter Ujfalusi (6):
>   ASoC: twl6040: Use neutral name for power mode text/enum
>   ASoC: twl6040: Move PLL selection to codec driver
>   ASoC: twl6040: Simplify sample rate constraint handling
>   ASoC: twl6040: Configure PLL only once
>   MFD: twl6040: Remove enum for PLL tracking
>   ASoC: twl6040: No need to convert the PLL ID
> 
>  drivers/mfd/twl6040-core.c  |   26 +++---
>  include/linux/mfd/twl6040.h |   17 ++---
>  sound/soc/codecs/twl6040.c  |  182
> ++++++++++++++++++++++--------------------- sound/soc/codecs/twl6040.h  |  
>  1 +
>  sound/soc/omap/sdp4430.c    |   47 +----------
>  5 files changed, 118 insertions(+), 155 deletions(-)


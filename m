Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182Ab1IPJTz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 05:19:55 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:53408 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750942Ab1IPJTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 05:19:54 -0400
Subject: Re: [PATCH 00/17] ASoC: twl6040: Cleanups and fixes
From: Liam Girdwood <lrg@ti.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: Dmitry Torokhov <dtor@mail.ru>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Misael Lopez Cruz <misael.lopez@ti.com>
In-Reply-To: <1316090379-30760-1-git-send-email-peter.ujfalusi@ti.com>
References: <1316090379-30760-1-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Sep 2011 10:19:49 +0100
Message-ID: <1316164789.3229.4.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-15 at 15:39 +0300, Peter Ujfalusi wrote:
> Hello,
> 
> The first four patch of this series (the MFD/Input patches) has been already
> sent to upstream to the relevant lists, but I wanted to include here as well,
> since I have dependency on that series later on.
> If it is OK with you, it would be best to merge these MFD/Input changes through
> the audio tree for 3.2.
> 
> Code cleanup, and fixes for the twl6040 codec driver.
> Main changes:
> - reg_cache has been rested to chip defaults
> - codec initialization changes
> - Correction for the Earphone path
> - AUX L/R output support
> - Headset/Handsfree control name changes
> - Headset DC offset workaround
> 

All Acked-by: Liam Girdwood <lrg@ti.com>

Samuel, IIRC we have a dependency on MFD. Do you mind if this goes via
ASoC ?

Thanks

Liam


> Regards,
> Peter
> 
> I have excluded the linux-input list (but kept Dmitry) - to not spam them.
> 
> ---
> Peter Ujfalusi (17):
>   MFD: twl6040: Remove global pointer for platform_device
>   MFD: twl6040: Add accessor for revision ID
>   Input: twl6040-vibra: Use accessor to get revision information
>   MFD: twl6040: Fix power on GPIO handling
>   ASoC: twl6040: Chip initialization cleanup
>   ASoC: twl6040: Use chip defaults in the initial reg_cache
>   ASoC: twl6040: Lower the initial gains
>   ASoC: twl6040: Fix comments for register names
>   ASoC: twl6040: Remove strings "NULL" from DAPM route
>   ASoC: twl6040: Introduce SW only shadow register
>   ASoC: twl6040: Earphone path correction
>   ASoC: twl6040: Use consistent names for Handsfree path
>   ASoC: twl6040: Use consistent names for Headset path
>   ASoC: twl6040: Support for AUX L/R output
>   ASoC: twl6040/sdp4430: Change legacy DAI name
>   ASoC/MFD: twl6040: Combine bit definitions for Headset control
>     registers
>   ASoC: twl6040: Workaround for headset DC offset caused pop noise
> 
>  drivers/input/misc/twl6040-vibra.c |    2 +-
>  drivers/mfd/twl6040-core.c         |   38 ++--
>  include/linux/mfd/twl6040.h        |   22 +--
>  sound/soc/codecs/twl6040.c         |  367 +++++++++++++++++++-----------------
>  sound/soc/omap/sdp4430.c           |    2 +-
>  5 files changed, 218 insertions(+), 213 deletions(-)
> 



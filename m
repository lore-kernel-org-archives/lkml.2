Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab1CBN2q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 08:28:46 -0500
Received: from smtp.nokia.com ([147.243.128.26]:57357 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754161Ab1CBN2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 08:28:44 -0500
Message-ID: <4D6E45EE.2000605@nokia.com>
Date: Wed, 02 Mar 2011 15:28:14 +0200
From: Peter Ujfalusi <peter.ujfalusi@nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110103 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Ilkka Koskinen <ilkka.koskinen@nokia.com>
CC: tony@atomide.com, sameo@linux.intel.com,
        broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 0/2] twl4030_codec cleanup
References: <1299072246-26402-1-git-send-email-ilkka.koskinen@nokia.com>
In-Reply-To: <1299072246-26402-1-git-send-email-ilkka.koskinen@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/11 15:24, Ilkka Koskinen wrote:
> This series of patches removes duplicate audio_mclk fields from
> twl4030_codec driver.
> 
> The patches have been compiled on sound-2.6/for-2.6.39 branch.
> I haven't tested them on any target board though.
> 
> Ilkka Koskinen (2):
>   omap: Remove unnecessary twl4030_codec_audio settings from board
>     files
>   mfd: twl4030_codec: Remove unused and duplicate audio_mclk fields
> 
>  arch/arm/mach-omap2/board-3430sdp.c          |    4 +---
>  arch/arm/mach-omap2/board-devkit8000.c       |    4 +---
>  arch/arm/mach-omap2/board-igep0020.c         |    4 +---
>  arch/arm/mach-omap2/board-omap3beagle.c      |    4 +---
>  arch/arm/mach-omap2/board-omap3evm.c         |    4 +---
>  arch/arm/mach-omap2/board-omap3pandora.c     |    4 +---
>  arch/arm/mach-omap2/board-omap3stalker.c     |    4 +---
>  arch/arm/mach-omap2/board-omap3touchbook.c   |    4 +---
>  arch/arm/mach-omap2/board-overo.c            |    4 +---
>  arch/arm/mach-omap2/board-zoom-peripherals.c |    4 +---
>  include/linux/i2c/twl.h                      |    2 --
>  11 files changed, 10 insertions(+), 32 deletions(-)
> 

Thanks Ilkka!
This was in my to do list, now I can remove this item.

All:
Acked-by: Peter Ujfalusi <peter.ujfalusi@nokia.com>

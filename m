Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505Ab0KYKrw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 05:47:52 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53676 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab0KYKrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 05:47:51 -0500
Subject: Re: [PATCH 0/8] ASoC: fix resource leak in error paths
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org, Jon Smirl <jonsmirl@gmail.com>,
        Sergey Lapin <slapin@ossfans.org>,
        Sedji Gaouaou <sedji.gaouaou@atmel.com>,
        Jaswinder Singh Brar <jassi.brar@samsung.com>,
        Mika Westerberg <mika.westerberg@iki.fi>,
        Sascha Hauer <s.hauer@pengutronix.de>
In-Reply-To: <1290668785.30158.7.camel@mola>
References: <1290668785.30158.7.camel@mola>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Nov 2010 10:47:47 +0000
Message-ID: <1290682067.3302.14.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-25 at 15:06 +0800, Axel Lin wrote:
> This serial of patches fix resource leak in error paths.
> 
> Axel Lin (8):
>   ASoC: efika-audio-fabric: fix resource leak in efika_fabric_init
>     error path
>   ASoC: pcm030-audio-fabric: fix resource leak in pcm030_fabric_init
>     error path
>   ASoC: snd-soc-afeb9260: remove unneeded platform_device_del in error
>     path
>   ASoC: sam9g20_wm8731: fix resource leak in at91sam9g20ek_init error
>     path
>   ASoC: smdk_wm9713: fix resource leak in smdk_init error path
>   ASoC: simone: fix resource leak in simone_init error path
>   ASoC: imx-ssi: fix resource leak
>   ASoC: phycore-ac97: fix resource leak
> 
>  sound/soc/atmel/sam9g20_wm8731.c    |    5 ++++-
>  sound/soc/atmel/snd-soc-afeb9260.c  |    1 -
>  sound/soc/ep93xx/simone.c           |   18 ++++++++++--------
>  sound/soc/fsl/efika-audio-fabric.c  |    1 +
>  sound/soc/fsl/pcm030-audio-fabric.c |    1 +
>  sound/soc/imx/imx-ssi.c             |   15 +++++++++++----
>  sound/soc/imx/phycore-ac97.c        |   28 +++++++++++++++++++++-------
>  sound/soc/samsung/smdk_wm9713.c     |   17 ++++++++++-------
>  8 files changed, 58 insertions(+), 28 deletions(-)
> 
All

Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk


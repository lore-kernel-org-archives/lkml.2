Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934910Ab1JFGwx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 02:52:53 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41407 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758163Ab1JFGws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 02:52:48 -0400
Subject: Re: [PATCH 00/10] Convert wm8xxx codec drivers to use
 snd_soc_cache_sync
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mike Arthur <linux@wolfsonmicro.com>, Richard Purdie <rpurdie@rpsys.net>,
        Jonathan Cameron <jic23@cam.ac.uk>, Kenneth Kiraly <kiraly@lab126.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
In-Reply-To: <1317881417.13399.1.camel@phoenix>
References: <1317881417.13399.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Oct 2011 14:52:40 +0800
Message-ID: <1317883960.13399.17.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry. I just found we need to set codec->cache_sync = 1 in
SND_SOC_BIAS_OFF. Otherwise, snd_soc_cache_sync won't sync work.

Will send a v2 soon.

Axel

於 四，2011-10-06 於 14:10 +0800，Axel Lin 提到：
> This serial converts the wm8xxx codec drivers to use snd_soc_cache_sync.
> I don't have these hardware, but I assume Mark has all these hardware.
> These patches are UNTESTED. I'd appreciate if someone can test them.
> (Current code is broken anyway, thus we need convert to use new API. )
> 
> Axel Lin (10):
>   ASoC: wm8510: Convert to snd_soc_cache_sync
>   ASoC: wm8711: Convert to snd_soc_cache_sync
>   ASoC: wm8731: Convert to snd_soc_cache_sync
>   ASoC: wm8750: Convert to snd_soc_cache_sync
>   ASoC: wm8776: Convert to snd_soc_cache_sync
>   ASoC: wm8940: Convert to snd_soc_cache_sync
>   ASoC: wm8960: Convert to snd_soc_cache_sync
>   ASoC: wm8971: Convert to snd_soc_cache_sync
>   ASoC: wm8974: Convert to snd_soc_cache_sync
>   ASoC: wm8988: Convert to snd_soc_cache_sync
> 
>  sound/soc/codecs/wm8510.c |   30 ++++++++++++++++++----------
>  sound/soc/codecs/wm8711.c |   19 +++++++----------
>  sound/soc/codecs/wm8731.c |   29 ++++++++++++++++-----------
>  sound/soc/codecs/wm8750.c |   32 +++++++++++++++++-------------
>  sound/soc/codecs/wm8776.c |   33 ++++++++++++++++++-------------
>  sound/soc/codecs/wm8940.c |   46 +++++++++++++++++++++-----------------------
>  sound/soc/codecs/wm8960.c |   37 +++++++++++++++++++++++++----------
>  sound/soc/codecs/wm8971.c |   32 +++++++++++++++++++-----------
>  sound/soc/codecs/wm8974.c |   29 +++++++++++++++++----------
>  sound/soc/codecs/wm8988.c |   32 +++++++++++++++++-------------
>  10 files changed, 185 insertions(+), 134 deletions(-)
> 



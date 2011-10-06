Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218Ab1JFKOp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 06:14:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39921 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757131Ab1JFKOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 06:14:44 -0400
Date: Thu, 6 Oct 2011 11:14:42 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Mike Arthur <linux@wolfsonmicro.com>,
        Richard Purdie <rpurdie@rpsys.net>, Jonathan Cameron <jic23@cam.ac.uk>,
        Kenneth Kiraly <kiraly@lab126.com>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH 00/10] Convert wm8xxx codec drivers to use
 snd_soc_cache_sync
Message-ID: <20111006101440.GB14518@opensource.wolfsonmicro.com>
References: <1317881417.13399.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317881417.13399.1.camel@phoenix>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 06, 2011 at 02:10:17PM +0800, Axel Lin wrote:
> This serial converts the wm8xxx codec drivers to use snd_soc_cache_sync.
> I don't have these hardware, but I assume Mark has all these hardware.
> These patches are UNTESTED. I'd appreciate if someone can test them.
> (Current code is broken anyway, thus we need convert to use new API. )

Axel, when submitting patches please don't fish e-mail addresses out of
the code - use the git logs to find out who's working on the driver.
This seems to be a fairly big source of bouncing e-mails in your CC
lists.

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
> -- 
> 1.7.4.1
> 
> 
> 

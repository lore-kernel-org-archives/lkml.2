Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab1HJGNe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 02:13:34 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:37749 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751284Ab1HJGNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 02:13:33 -0400
Message-ID: <4E422120.6060607@metafoo.de>
Date: Wed, 10 Aug 2011 08:11:44 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110702 Icedove/3.0.11
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        device-drivers-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH 2/4] ASoC: Add ADAU1373 codec support
References: <1312948364-2587-1-git-send-email-lars@metafoo.de> <1312948364-2587-2-git-send-email-lars@metafoo.de>
In-Reply-To: <1312948364-2587-2-git-send-email-lars@metafoo.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2011 05:52 AM, Lars-Peter Clausen wrote:
> This patch adds support for the Analog Devices ADAU1373 audio codec.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  include/sound/adau1373.h    |   22 +
>  sound/soc/codecs/Kconfig    |    3 +
>  sound/soc/codecs/Makefile   |    2 +
>  sound/soc/codecs/adau1373.c | 1374 +++++++++++++++++++++++++++++++++++++++++++
>  sound/soc/codecs/adau1373.h |   29 +
>  5 files changed, 1430 insertions(+), 0 deletions(-)
>  create mode 100644 include/sound/adau1373.h
>  create mode 100644 sound/soc/codecs/adau1373.c
>  create mode 100644 sound/soc/codecs/adau1373.h
> 
> [...]
> diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
> index 665d924..bac0edb 100644
> --- a/sound/soc/codecs/Kconfig
> +++ b/sound/soc/codecs/Kconfig
> @@ -139,6 +139,9 @@ config SND_SOC_ADAU1701
>  	select SIGMA
>  	tristate
>  
> +config SND_SOC_ADAU1373
> +	tristate
> +

Forgot to add it to SND_SOC_ALL_CODECS. Will be in v2.

>  config SND_SOC_ADAV80X
>  	tristate
>  
> [...]

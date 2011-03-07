Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab1CGMYO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 07:24:14 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58839 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751041Ab1CGMYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 07:24:09 -0500
Date: Mon, 7 Mar 2011 12:24:08 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Jassi Brar <jassi.brar@samsung.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] ASoC: neo1973_wm8753: Move lm4857 specefic code to
 its own module
Message-ID: <20110307122407.GH13471@opensource.wolfsonmicro.com>
References: <1299481500-5481-1-git-send-email-lars@metafoo.de>
 <1299481500-5481-2-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299481500-5481-2-git-send-email-lars@metafoo.de>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 08:04:55AM +0100, Lars-Peter Clausen wrote:

> index 82a4630..37035e6 100644
> --- a/sound/soc/codecs/Kconfig
> +++ b/sound/soc/codecs/Kconfig
> @@ -347,6 +347,9 @@ config SND_SOC_WM9713
>  	tristate
>  
>  # Amp
> +config SND_SOC_LM4857
> +	tristate
> +
>  config SND_SOC_MAX9877
>  	tristate

This should also add LM4857 to SND_SOC_ALL_CODECS.  I'll fix that
incrementally.

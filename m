Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899Ab0GNPHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 11:07:43 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:42597 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab0GNPHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 11:07:41 -0400
Subject: Re: [PATCH] wm8727: add a missing return in wm8727_platform_probe
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Tejun Heo <tj@kernel.org>, Neil Jones <neil.jones@imgtec.com>,
        alsa-devel@alsa-project.org
In-Reply-To: <1279105051.2290.5.camel@phoenix>
References: <1279105051.2290.5.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Jul 2010 15:59:57 +0100
Message-ID: <1279119597.3080.120.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-14 at 18:57 +0800, Axel Lin wrote:
> otherwise the error path will always be executed.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  sound/soc/codecs/wm8727.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/sound/soc/codecs/wm8727.c b/sound/soc/codecs/wm8727.c
> index 1072621..9d1df26 100644
> --- a/sound/soc/codecs/wm8727.c
> +++ b/sound/soc/codecs/wm8727.c
> @@ -127,6 +127,8 @@ static __devinit int wm8727_platform_probe(struct platform_device *pdev)
>  		goto err_codec;
>  	}
>  
> +	return 0;
> +
>  err_codec:
>  	snd_soc_unregister_codec(codec);
>  err:

Both

Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk


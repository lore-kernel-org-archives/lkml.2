Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab1EHOK1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 10:10:27 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38314 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368Ab1EHOKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 10:10:25 -0400
Subject: Re: [PATCH] SOC: UDA134x: Remove POWER_OFF_ON_STANDBY define.
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Marek Belisko <marek.belisko@open-nandra.com>
Cc: tiwai@suse.de, perex@perex.cz, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com
In-Reply-To: <1304426792-23540-1-git-send-email-marek.belisko@open-nandra.com>
References: <1304426792-23540-1-git-send-email-marek.belisko@open-nandra.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 08 May 2011 15:10:21 +0100
Message-ID: <1304863821.3246.4.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-03 at 14:46 +0200, Marek Belisko wrote:
> Define POWER_OFF_ON_STANDBY cause trobles when trying to get some
> sound from codec because code for bias setup was not compiled
> (define wasn't defined). This define was removed in commit:
> cc3202f5 but again introduced by commit: f0fba2ad1 which then
> completely break codec functionality so remove it again.
> 
> Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
> ---
>  sound/soc/codecs/uda134x.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/sound/soc/codecs/uda134x.c b/sound/soc/codecs/uda134x.c
> index 48ffd40..a7b8f30 100644
> --- a/sound/soc/codecs/uda134x.c
> +++ b/sound/soc/codecs/uda134x.c
> @@ -601,9 +601,7 @@ static struct snd_soc_codec_driver soc_codec_dev_uda134x = {
>  	.reg_cache_step = 1,
>  	.read = uda134x_read_reg_cache,
>  	.write = uda134x_write,
> -#ifdef POWER_OFF_ON_STANDBY
>  	.set_bias_level = uda134x_set_bias_level,
> -#endif
>  };
>  
>  static int __devinit uda134x_codec_probe(struct platform_device *pdev)

Acked-by: Liam Girdwood <lrg@ti.com>


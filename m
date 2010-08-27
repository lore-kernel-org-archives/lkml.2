Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab0H0MZI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 08:25:08 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35759 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515Ab0H0MZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 08:25:04 -0400
Subject: Re: [PATCH] ASoC: soc-core: fix debugfs_pop_time file permissions
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1282876467.9142.2.camel@mola>
References: <1282876467.9142.2.camel@mola>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Aug 2010 13:25:00 +0100
Message-ID: <1282911900.3025.7.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-27 at 10:34 +0800, Axel Lin wrote:
> I think this is a typo, debugfs_pop_time should not be executable.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  sound/soc/soc-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
> index 65352c7..42542e0 100644
> --- a/sound/soc/soc-core.c
> +++ b/sound/soc/soc-core.c
> @@ -249,7 +249,7 @@ static void soc_init_codec_debugfs(struct snd_soc_codec *codec)
>  		printk(KERN_WARNING
>  		       "ASoC: Failed to create codec register debugfs file\n");
>  
> -	codec->debugfs_pop_time = debugfs_create_u32("dapm_pop_time", 0744,
> +	codec->debugfs_pop_time = debugfs_create_u32("dapm_pop_time", 0644,
>  						     codec->debugfs_codec_root,
>  						     &codec->pop_time);
>  	if (!codec->debugfs_pop_time)

Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk


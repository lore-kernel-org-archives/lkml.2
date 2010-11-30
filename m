Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817Ab0K3LWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 06:22:53 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63136 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755672Ab0K3LWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 06:22:52 -0500
Subject: Re: [PATCH] ASoC: Fix compile error for s6000-i2s.c by adding a
 missing ';' character
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, dg@emlix.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
In-Reply-To: <1291081553.18485.3.camel@mola>
References: <1291081553.18485.3.camel@mola>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Nov 2010 11:22:48 +0000
Message-ID: <1291116168.3293.5.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-30 at 09:45 +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> I don't have toolchain to compile s6000, I'm not able to put the error message in the commit log.
> But I know this patch indeed fixes a compile error.
> 
>  sound/soc/s6000/s6000-i2s.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/sound/soc/s6000/s6000-i2s.c b/sound/soc/s6000/s6000-i2s.c
> index 8778faa..3052f64 100644
> --- a/sound/soc/s6000/s6000-i2s.c
> +++ b/sound/soc/s6000/s6000-i2s.c
> @@ -434,7 +434,7 @@ static struct snd_soc_dai_driver s6000_i2s_dai = {
>  		.rate_max = 1562500,
>  	},
>  	.ops = &s6000_i2s_dai_ops,
> -}
> +};
>  
>  static int __devinit s6000_i2s_probe(struct platform_device *pdev)
>  {

I think Daniel was first so I've acked his patch for this.

Thanks

Liam 

-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760108Ab0GQRpk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 13:45:40 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65154 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760097Ab0GQRpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 13:45:38 -0400
Subject: Re: [PATCH 13/15] sound/soc: davinci: check kzalloc() result (typo)
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Peter Ujfalusi <peter.ujfalusi@nokia.com>,
        Miguel Aguilar <miguel.aguilar@ridgerun.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
In-Reply-To: <1279296977-25267-1-git-send-email-segooon@gmail.com>
References: <1279296977-25267-1-git-send-email-segooon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 17 Jul 2010 18:45:33 +0100
Message-ID: <1279388733.3070.5.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-16 at 20:16 +0400, Kulikov Vasiliy wrote:
> The code checks 'davinci_vc' after kzalloc() and do not checks
> 'davinci_vcif_dev' that kzalloc() result is assigned to. It seems that
> it is a typo (autocompletion?).
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> ---
>  sound/soc/davinci/davinci-vcif.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/sound/soc/davinci/davinci-vcif.c b/sound/soc/davinci/davinci-vcif.c
> index 9aa980d..4867853 100644
> --- a/sound/soc/davinci/davinci-vcif.c
> +++ b/sound/soc/davinci/davinci-vcif.c
> @@ -203,7 +203,7 @@ static int davinci_vcif_probe(struct platform_device *pdev)
>  	int ret;
>  
>  	davinci_vcif_dev = kzalloc(sizeof(struct davinci_vcif_dev), GFP_KERNEL);
> -	if (!davinci_vc) {
> +	if (!davinci_vcif_dev) {
>  		dev_dbg(&pdev->dev,
>  			"could not allocate memory for private data\n");
>  		return -ENOMEM;

13,14 & 15

Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk


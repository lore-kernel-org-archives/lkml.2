Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab0K2LIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 06:08:50 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63209 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab0K2LIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 06:08:49 -0500
Subject: Re: [PATCH 1/2] ASoC: Add missing dev_set_drvdata in
 mpc8610_hpcd_probe
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Timur Tabi <timur@freescale.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
In-Reply-To: <1291013698.19113.1.camel@mola>
References: <1291013698.19113.1.camel@mola>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Nov 2010 11:08:39 +0000
Message-ID: <1291028919.3299.137.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-29 at 14:54 +0800, Axel Lin wrote:
> Otherwise, calling dev_get_drvdata in mpc8610_hpcd_remove returns NULL.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  sound/soc/fsl/mpc8610_hpcd.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/sound/soc/fsl/mpc8610_hpcd.c b/sound/soc/fsl/mpc8610_hpcd.c
> index 0d7dcf1..7d7847a 100644
> --- a/sound/soc/fsl/mpc8610_hpcd.c
> +++ b/sound/soc/fsl/mpc8610_hpcd.c
> @@ -498,6 +498,7 @@ static int mpc8610_hpcd_probe(struct platform_device *pdev)
>  		dev_err(&pdev->dev, "platform device add failed\n");
>  		goto error;
>  	}
> +	dev_set_drvdata(&pdev->dev, sound_device);
>  
>  	of_node_put(codec_np);
>  

All

Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk


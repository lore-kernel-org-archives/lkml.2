Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107Ab1JJG5A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 02:57:00 -0400
Received: from bitmer.com ([213.157.87.50]:47015 "EHLO bitmer.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694Ab1JJG47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 02:56:59 -0400
Message-ID: <4E929724.4070708@bitmer.com>
Date: Mon, 10 Oct 2011 09:56:36 +0300
From: Jarkko Nikula <jarkko.nikula@bitmer.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20111005 Icedove/3.1.15
MIME-Version: 1.0
To: Michael Opdenacker <michael.opdenacker@linaro.org>
CC: lrg@ti.com, broonie@opensource.wolfsonmicro.com, perex@perex.cz,
        tiwai@suse.de, linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] omap: sound: fix checkpatch.pl error
References: <1318223228-15671-1-git-send-email-michael.opdenacker@linaro.org> <1318223228-15671-3-git-send-email-michael.opdenacker@linaro.org>
In-Reply-To: <1318223228-15671-3-git-send-email-michael.opdenacker@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2011 08:07 AM, Michael Opdenacker wrote:
> Signed-off-by: Michael Opdenacker<michael.opdenacker@linaro.org>
> ---
>   sound/soc/omap/omap-mcbsp.c |    3 +--
>   1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/sound/soc/omap/omap-mcbsp.c b/sound/soc/omap/omap-mcbsp.c
> index 1391ea0..30325fb 100644
> --- a/sound/soc/omap/omap-mcbsp.c
> +++ b/sound/soc/omap/omap-mcbsp.c
> @@ -606,8 +606,7 @@ static int mcbsp_dai_probe(struct snd_soc_dai *dai)
>   	return 0;
>   }
>
> -static struct snd_soc_dai_driver omap_mcbsp_dai =
> -{
> +static struct snd_soc_dai_driver omap_mcbsp_dai = {

Acked-by: Jarkko Nikula <jarkko.nikula@bitmer.com>

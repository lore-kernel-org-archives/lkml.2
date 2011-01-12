Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932756Ab1ALAyJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 19:54:09 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47395 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756400Ab1ALAyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 19:54:03 -0500
Subject: Re: [PATCH] ASoC: tpa6130a2: Fix compiler warning
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Peter Ujfalusi <peter.ujfalusi@nokia.com>
Cc: alsa-devel@alsa-project.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1293527779-32580-1-git-send-email-peter.ujfalusi@nokia.com>
References: <1293527779-32580-1-git-send-email-peter.ujfalusi@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Jan 2011 00:53:58 +0000
Message-ID: <1294793638.3338.482.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-28 at 11:16 +0200, Peter Ujfalusi wrote:
> sound/soc/codecs/tpa6130a2.c: In function 'tpa6130a2_add_controls':
> sound/soc/codecs/tpa6130a2.c:342: warning: unused variable 'dapm'
> 
> Introduced by commit 39646871a47fd8808c08de0ce7d7ca8393af2805 ("ASoC:
> tpa6130a2: Replace DAPM code with direct interface").
> 
> The DAPM code has been removed from the driver, but the
> dapm struct remained.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@nokia.com>
> ---
>  sound/soc/codecs/tpa6130a2.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/sound/soc/codecs/tpa6130a2.c b/sound/soc/codecs/tpa6130a2.c
> index 0a99f31..1f1ac81 100644
> --- a/sound/soc/codecs/tpa6130a2.c
> +++ b/sound/soc/codecs/tpa6130a2.c
> @@ -339,7 +339,6 @@ EXPORT_SYMBOL_GPL(tpa6130a2_stereo_enable);
>  int tpa6130a2_add_controls(struct snd_soc_codec *codec)
>  {
>  	struct	tpa6130a2_data *data;
> -	struct snd_soc_dapm_context *dapm = &codec->dapm;
>  
>  	if (tpa6130a2_client == NULL)
>  		return -ENODEV;

Applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk


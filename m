Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab0IFKcg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 06:32:36 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50244 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab0IFKcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 06:32:35 -0400
Subject: Re: [PATCH 1/1] SOUND: wm8753, remove dead code
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Jiri Slaby <jslaby@suse.cz>
Cc: tiwai@suse.de, alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Liam Girdwood <lg@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@suse.cz>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1283605929-15961-1-git-send-email-jslaby@suse.cz>
References: <1283605929-15961-1-git-send-email-jslaby@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Sep 2010 11:32:30 +0100
Message-ID: <1283769150.3078.15.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-09-04 at 15:12 +0200, Jiri Slaby wrote:
> There is adangling code in wm8753_probe which is never executed.
> Remove it.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Liam Girdwood <lg@opensource.wolfsonmicro.com>
> Cc: Takashi Iwai <tiwai@suse.de>
> Cc: Jaroslav Kysela <perex@suse.cz>
> ---
>  sound/soc/codecs/wm8753.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/sound/soc/codecs/wm8753.c b/sound/soc/codecs/wm8753.c
> index 4844232..4a945d3 100644
> --- a/sound/soc/codecs/wm8753.c
> +++ b/sound/soc/codecs/wm8753.c
> @@ -1600,9 +1600,6 @@ static int wm8753_probe(struct snd_soc_codec *codec)
>  	wm8753_add_widgets(codec);
>  
>  	return 0;
> -
> -	run_delayed_work(&codec->delayed_work);
> -	return ret;
>  }
>  
>  /* power down chip */

Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk


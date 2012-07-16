Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab2GPW5A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 18:57:00 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51649 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab2GPW46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 18:56:58 -0400
MIME-Version: 1.0
In-Reply-To: <1342477026-8376-1-git-send-email-marex@denx.de>
References: <1342477026-8376-1-git-send-email-marex@denx.de>
Date: Mon, 16 Jul 2012 15:56:57 -0700
Message-ID: <CAA9_cmcWaj_KWLz1m0sxCJNihVuGMQsbP53=1cPiEBBWiei7bg@mail.gmail.com>
Subject: Re: [PATCH V2] [SCSI] async: Fixup arguments of async_synchronize_full_domain
 in alsa-soc
From: Dan Williams <dan.j.williams@gmail.com>
To: Marek Vasut <marex@denx.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        James Bottomley <JBottomley@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2012 at 3:17 PM, Marek Vasut <marex@denx.de> wrote:
[..]
>  sound/soc/soc-dapm.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> V2: CC proper people, hopefully proper mailing list
>     Adjust the patch subject with proper tags
>
> diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
> index eded657..e491eb0 100644
> --- a/sound/soc/soc-dapm.c
> +++ b/sound/soc/soc-dapm.c
> @@ -1572,7 +1572,7 @@ static int dapm_power_widgets(struct snd_soc_dapm_context *dapm, int event)
>         struct snd_soc_dapm_context *d;
>         LIST_HEAD(up_list);
>         LIST_HEAD(down_list);
> -       LIST_HEAD(async_domain);
> +       ASYNC_DOMAIN_EXCLUSIVE(async_domain);
>         enum snd_soc_bias_level bias;
>

Thanks.  This was folded into the resend that was submitted week [1]

Regards,
Dan

[1]: http://marc.info/?l=linux-scsi&m=134188683322951&w=2

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226Ab1DMHjK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 03:39:10 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48840 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757096Ab1DMHjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 03:39:08 -0400
Subject: Re: [alsa-devel] [PATCH 1/5] ASoC: Make struct snd_soc_card's
 dapm_widgets and dapm_routes const
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
In-Reply-To: <1302629465-21315-1-git-send-email-lars@metafoo.de>
References: <1302629465-21315-1-git-send-email-lars@metafoo.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Apr 2011 08:39:02 +0100
Message-ID: <1302680342.3600.10.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-12 at 19:31 +0200, Lars-Peter Clausen wrote:
> Those should not be modified (and are not) by the core code, so make them const.
> This also makes them consistent with the same members of snd_soc_codec.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  include/sound/soc.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/sound/soc.h b/include/sound/soc.h
> index 435cb83..cb6b18b 100644
> --- a/include/sound/soc.h
> +++ b/include/sound/soc.h
> @@ -755,9 +755,9 @@ struct snd_soc_card {
>  	/*
>  	 * Card-specific routes and widgets.
>  	 */
> -	struct snd_soc_dapm_widget *dapm_widgets;
> +	const struct snd_soc_dapm_widget *dapm_widgets;
>  	int num_dapm_widgets;
> -	struct snd_soc_dapm_route *dapm_routes;
> +	const struct snd_soc_dapm_route *dapm_routes;
>  	int num_dapm_routes;
>  
>  	struct work_struct deferred_resume_work;

Patch 1,3,4 & 5 

Acked-by: Liam Girdwood <lrg@ti.com>


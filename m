Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932790Ab0JEM1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 08:27:46 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48969 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab0JEM1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 08:27:45 -0400
Subject: Re: [PATCH] sound/soc/nuc900: remove duplicated include
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Nicolas Kaiser <nikai@nikai.net>
Cc: Wan ZongShun <mcuos.com@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <20101005141140.0276dc14@absol.kitzblitz>
References: <20101005141140.0276dc14@absol.kitzblitz>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Oct 2010 13:27:42 +0100
Message-ID: <1286281662.3111.97.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-05 at 14:11 +0200, Nicolas Kaiser wrote:
> Remove duplicated include.
> 
> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
> ---
>  sound/soc/nuc900/nuc900-ac97.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/sound/soc/nuc900/nuc900-ac97.c b/sound/soc/nuc900/nuc900-ac97.c
> index caa7c90..265a950 100644
> --- a/sound/soc/nuc900/nuc900-ac97.c
> +++ b/sound/soc/nuc900/nuc900-ac97.c
> @@ -20,7 +20,6 @@
>  #include <sound/pcm.h>
>  #include <sound/initval.h>
>  #include <sound/soc.h>
> -#include <linux/device.h>
>  #include <linux/clk.h>
>  
>  #include <mach/mfp.h>

Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk


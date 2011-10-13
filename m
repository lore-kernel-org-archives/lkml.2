Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab1JMQUE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 12:20:04 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50167 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755978Ab1JMQUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 12:20:01 -0400
Date: Thu, 13 Oct 2011 17:19:59 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        "kuninori.morimoto.gx" <kuninori.morimoto.gx@renesas.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH v2 2/9] ASoC: da7210: Add support for line
 input and mic
Message-ID: <20111013161959.GI5193@opensource.wolfsonmicro.com>
References: <1318514644.12107.472.camel@matrix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318514644.12107.472.camel@matrix>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 07:34:04PM +0530, Ashish Chavan wrote:
>  	} else {
> -		/* Volume 7 */
> -		snd_soc_update_bits(codec, DA7210_MIC_L, 0x7, 0x7);
> -		snd_soc_update_bits(codec, DA7210_MIC_R, 0x7, 0x7);
> -
> -		/* Enable Mic */
> -		snd_soc_update_bits(codec, DA7210_INMIX_L, 0x1F, 0x1);
> -		snd_soc_update_bits(codec, DA7210_INMIX_R, 0x1F, 0x1);
> +		/* Enable Mic,AUX1 and AUX2 */
> +		snd_soc_update_bits(codec, DA7210_INMIX_L, 0x1F, 0xD);
> +		snd_soc_update_bits(codec, DA7210_INMIX_R, 0x1F, 0xD);

So, I did mention that the DAPM patch should come first when I reviewed
your previous series...

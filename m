Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab1JLOtn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 10:49:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41760 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751633Ab1JLOtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 10:49:42 -0400
Date: Wed, 12 Oct 2011 15:49:40 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg@ti.com, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        kuninori.morimoto.gx@renesas.com, linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH 1/9] ASoC: da7210: Add support for line out
 and DAC
Message-ID: <20111012144940.GN3647@opensource.wolfsonmicro.com>
References: <1318431375.12107.398.camel@matrix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318431375.12107.398.camel@matrix>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 08:26:15PM +0530, Ashish Chavan wrote:

> +	SOC_DOUBLE_R_TLV("DAC Playback Volume",
> +			 DA7210_DAC_L, DA7210_DAC_R,
> +			 0, 0x77, 1, dac_gain_tlv),

Digital Playback Volume.

> +	/* Set default DAC gain */
> +	snd_soc_write(codec, DA7210_DAC_L, DA7210_DFLT_DAC_GAIN);
> +	snd_soc_write(codec, DA7210_DAC_R, DA7210_DFLT_DAC_GAIN);

No, use chip defaults.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746Ab0FNQKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 12:10:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40841 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753790Ab0FNQKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 12:10:37 -0400
Date: Mon, 14 Jun 2010 17:10:34 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Huewe <PeterHuewe@gmx.de>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-sh@vger.kernel.org,
       Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       Kuninori Morimoto <morimoto.kuninori@renesas.com>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] soc/sh: Fix I2C dependency for SND_FSI_AK4642
Message-ID: <20100614161034.GF14604@rakim.wolfsonmicro.main>
References: <201006141739.42346.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006141739.42346.PeterHuewe@gmx.de>
X-Cookie: I brake for chezlogs!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 05:39:41PM +0200, Peter Huewe wrote:

>  	bool "FSI-AK4642 sound support"
>  	depends on SND_SOC_SH4_FSI
>  	select SND_SOC_AK4642
> +	select I2C

I'd have thought a depends was more appropriate.  Arguably you want to
depend on the SH I2C driver since the driver is useless without the
relevant I2C controller.

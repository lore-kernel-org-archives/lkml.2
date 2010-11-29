Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab0K2LSP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 06:18:15 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63658 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab0K2LSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 06:18:14 -0500
Subject: Re: [PATCH 0/5] Fix compile error and missing
 spin_unlock_irqrestore for NUC900 SoC audio
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Wan ZongShun <mcuos.com@gmail.com>, alsa-devel@alsa-project.org
In-Reply-To: <1291023491.22911.1.camel@mola>
References: <1291023491.22911.1.camel@mola>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Nov 2010 11:18:10 +0000
Message-ID: <1291029490.3299.148.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-29 at 17:38 +0800, Axel Lin wrote:
> This serial fixes compile error and missing spin_unlock_irqrestore for NUC900 SoC audio.
> 
> Regards,
> Axel
> 
> Axel Lin (5):
>   ASoC: Fix compile error for nuc900-ac97.c
>   ASoC: Fix prototype for nuc900_ac97_probe and nuc900_ac97_remove
>   ASoC: Fix compile error for nuc900-pcm.c
>   ASoC: Fix missing spin_unlock_irqrestore
>   ASoC: Remove unneeded !! operations while checking return value of
>     nuc900_checkready
> 
>  sound/soc/nuc900/nuc900-ac97.c  |   15 +++++++--------
>  sound/soc/nuc900/nuc900-audio.h |    2 ++
>  sound/soc/nuc900/nuc900-pcm.c   |   11 ++++++-----
>  3 files changed, 15 insertions(+), 13 deletions(-)
> 

All

Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk


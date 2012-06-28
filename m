Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab2F1MSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 08:18:22 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50263 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842Ab2F1MSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 08:18:21 -0400
Date: Thu, 28 Jun 2012 13:18:16 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Lars-Peter Clausen <lars@metafoo.de>, alsa-devel@alsa-project.org,
        swarren@nvidia.com, linux-kernel@vger.kernel.org,
        Laxman Dewangan <ldewangan@nvidia.com>, lrg@ti.com
Subject: Re: [alsa-devel] [PATCH] ASoC: snd_dmaengine: add common api for
 pcm_mmap
Message-ID: <20120628121816.GB21029@sirena.org.uk>
References: <1340866886-24432-1-git-send-email-ldewangan@nvidia.com>
 <4FEC3B70.5030902@metafoo.de>
 <s5hobo3zl79.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hobo3zl79.wl%tiwai@suse.de>
X-Cookie: You can't cheat the phone company.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2012 at 02:15:38PM +0200, Takashi Iwai wrote:
> Lars-Peter Clausen wrote:

> > to the ALSA core. Now that there is a generic dma_mmap_writecombine it may
> > make sense to integrate this with snd_pcm_lib_default_mmap.

> Agreed.

> Also, it must be portable.  So far, only ARM has
> dma_mmap_writecombine(), thus the build on other arch would fail as
> is.

Oh, dear - this means we don't actually have a generic API at all.  Is
there any effort being made to make this generally available?

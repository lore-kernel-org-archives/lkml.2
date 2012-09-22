Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454Ab2IVPKG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 11:10:06 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37076 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751784Ab2IVPKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 11:10:03 -0400
Date: Sat, 22 Sep 2012 11:09:58 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Ricardo Neri <ricardo.neri@ti.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH v3 03/15] dmaengine: Add flags parameter to
 dmaengine_prep_dma_cyclic()
Message-ID: <20120922150957.GH4495@opensource.wolfsonmicro.com>
References: <1347624358-25582-1-git-send-email-peter.ujfalusi@ti.com>
 <1347624358-25582-4-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347624358-25582-4-git-send-email-peter.ujfalusi@ti.com>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 03:05:46PM +0300, Peter Ujfalusi wrote:
> With this parameter added to dmaengine_prep_dma_cyclic() the API will be in
> sync with other dmaengine_prep_*() functions.
> The dmaengine_prep_dma_cyclic() function primarily used by audio for cyclic
> transfer required by ALSA, we use the from audio to ask dma drivers to
> suppress interrupts (if DMA_PREP_INTERRUPT is cleared) when it is supported
> on the platform.

Are you sure this was generated against for-3.7?  There's fuzz against
dmaengine.h and git can't find the blobs to do resolution.  Anyway, I
applied this and the rest of the series.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab2IQKDG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 06:03:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:26391 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753402Ab2IQKDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 06:03:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,434,1344236400"; 
   d="scan'208";a="222956331"
Subject: Re: [PATCH v3 03/15] dmaengine: Add flags parameter to
 dmaengine_prep_dma_cyclic()
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, Dan Williams <djbw@fb.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, alsa-devel@alsa-project.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Ricardo Neri <ricardo.neri@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <1347624358-25582-4-git-send-email-peter.ujfalusi@ti.com>
References: <1347624358-25582-1-git-send-email-peter.ujfalusi@ti.com>
	 <1347624358-25582-4-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Sep 2012 15:28:59 +0530
Message-ID: <1347875939.1943.147.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-14 at 15:05 +0300, Peter Ujfalusi wrote:
> With this parameter added to dmaengine_prep_dma_cyclic() the API will
> be in
> sync with other dmaengine_prep_*() functions.
> The dmaengine_prep_dma_cyclic() function primarily used by audio for
> cyclic
> transfer required by ALSA, we use the from audio to ask dma drivers to
> suppress interrupts (if DMA_PREP_INTERRUPT is cleared) when it is
> supported
> on the platform.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> CC: Lars-Peter Clausen <lars@metafoo.de>
> --- 
Acked-by: Vinod Koul <vinod.koul@linux.intel.com>


-- 
~Vinod


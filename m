Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab2IQKE1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 06:04:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:11557 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752Ab2IQKEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 06:04:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,434,1344236400"; 
   d="scan'208";a="222956625"
Subject: Re: [PATCH v3 05/15] dmaengine: omap-dma: Add support to suppress
 interrupts in cyclic mode
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
In-Reply-To: <1347624358-25582-6-git-send-email-peter.ujfalusi@ti.com>
References: <1347624358-25582-1-git-send-email-peter.ujfalusi@ti.com>
	 <1347624358-25582-6-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Sep 2012 15:30:21 +0530
Message-ID: <1347876021.1943.149.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-14 at 15:05 +0300, Peter Ujfalusi wrote:
> When requested (DMA_PREP_INTERRUPT is cleared in flags) disable all
> DMA
> interrupts for the channel. In this mode user space does not expect
> periodic reports from kernel about the progress of the audio stream.
> PulseAudio for example support this type of mode.
Acked-by: Vinod Koul <vinod.koul@linux.intel.com>

-- 
~Vinod


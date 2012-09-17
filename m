Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab2IQKDo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 06:03:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:54796 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432Ab2IQKDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 06:03:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,434,1344236400"; 
   d="scan'208";a="206052447"
Subject: Re: [PATCH v3 04/15] dmaengine: Pass flags via
 device_prep_dma_cyclic() callback
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, Dan Williams <djbw@fb.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, alsa-devel@alsa-project.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Ricardo Neri <ricardo.neri@ti.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Vista Silicon <javier.martin@vista-silicon.com>,
        Barry Song <baohua.song@csr.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Zhangfei Gao <zhangfei.gao@marvell.com>
In-Reply-To: <1347624358-25582-5-git-send-email-peter.ujfalusi@ti.com>
References: <1347624358-25582-1-git-send-email-peter.ujfalusi@ti.com>
	 <1347624358-25582-5-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Sep 2012 15:29:27 +0530
Message-ID: <1347875967.1943.148.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-14 at 15:05 +0300, Peter Ujfalusi wrote:
> Change the parameter list of device_prep_dma_cyclic() so the DMA
> drivers
> can receive the flags coming from clients.
> This feature can be used during audio operation to disable all audio
> related interrupts when the DMA_PREP_INTERRUPT is cleared from the
> flags.
Acked-by: Vinod Koul <vinod.koul@linux.intel.com>

-- 
~Vinod


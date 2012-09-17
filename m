Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab2IQDSB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 23:18:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:56152 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753318Ab2IQDR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 23:17:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,432,1344236400"; 
   d="scan'208";a="205806015"
Subject: Re: [PATCH v3 02/15] dmaengine: omap: Add support for pause/resume
 in cyclic dma mode
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, Dan Williams <djbw@fb.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Ricardo Neri <ricardo.neri@ti.com>,
        Lars-Peter Clausen <lars@metafoo.de>
In-Reply-To: <1347624358-25582-3-git-send-email-peter.ujfalusi@ti.com>
References: <1347624358-25582-1-git-send-email-peter.ujfalusi@ti.com>
	 <1347624358-25582-3-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Sep 2012 08:43:57 +0530
Message-ID: <1347851637.1943.125.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-14 at 15:05 +0300, Peter Ujfalusi wrote:
> -       /* FIXME: not supported by platform private API */
> -       return -EINVAL;
> +       /* Pause/Resume only allowed with cyclic mode */
> +       if (!c->cyclic)
> +               return -EINVAL; 
This is not a dma restriction right?

-- 
~Vinod


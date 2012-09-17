Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab2IQJzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 05:55:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:38569 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984Ab2IQJzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 05:55:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,434,1344236400"; 
   d="scan'208";a="193832702"
Subject: Re: [alsa-devel] [PATCH v3 00/15] ASoC: OMAP: Convert to use
 dmaengine
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: alsa-devel@alsa-project.org, Lars-Peter Clausen <lars@metafoo.de>,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Tony Lindgren <tony@atomide.com>, Ricardo Neri <ricardo.neri@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Dan Williams <djbw@fb.com>, Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>
In-Reply-To: <5056E300.809@ti.com>
References: <1347624358-25582-1-git-send-email-peter.ujfalusi@ti.com>
	 <1347851866.1943.126.camel@vkoul-udesk3>  <5056E300.809@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Sep 2012 15:21:41 +0530
Message-ID: <1347875501.1943.142.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-17 at 11:44 +0300, Peter Ujfalusi wrote:
> Hi Vinod,
> 
> On 09/17/2012 06:17 AM, Vinod Koul wrote:
> > On Fri, 2012-09-14 at 15:05 +0300, Peter Ujfalusi wrote:
> >> Hello,
> > 
> > dmaengine parts look good to me. How do you want to get this merged,
> > dmaengine or ASoC tree?
> 
> Thank you, I would prefer it to go via ASoC if it is not a problem. It is
> possible to separate the dmaengine core related patches and the patches for
> the OMAP drivers but I think it is better to keep them together so we can have
> them in a same tree for testing it further.
Sure I think this is better way to do.

-- 
~Vinod


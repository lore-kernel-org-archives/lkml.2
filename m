Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab2FTNpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 09:45:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:55558 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755922Ab2FTNpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 09:45:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="160039893"
Subject: Re: [PATCH v2 1/3] dmaengine: Add wrapper for device_tx_status
 callback
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Liam Girdwood <lrg@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Ola Lilja <ola.o.lilja@stericsson.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Mika Westerberg <mika.westerberg@iki.fi>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20120620130958.GN3978@opensource.wolfsonmicro.com>
References: <1339438302-12417-1-git-send-email-lars@metafoo.de>
	 <1340189662.1927.1648.camel@vkoul-udesk3> <4FE1BE79.5080903@metafoo.de>
	 <20120620130958.GN3978@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jun 2012 19:07:45 +0530
Message-ID: <1340199465.1927.1658.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-20 at 14:09 +0100, Mark Brown wrote:
> On Wed, Jun 20, 2012 at 02:13:45PM +0200, Lars-Peter Clausen wrote:
> 
> > There is a compile time dependency between the patches, so this patch should
> > go through the ASoC tree as well, or we'll have to wait another release
> > before the ASoC patches can be applied.
> 
> Yes, I was just going to say that - are you OK with me applying these
> Vinod?

Ah spoke too soon.

Please go ahead :)

-- 
~Vinod


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458Ab1LWQcy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 11:32:54 -0500
Received: from mga03.intel.com ([143.182.124.21]:21416 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754288Ab1LWQct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 11:32:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="50130685"
Subject: Re: [PATCH 5/5] ASoC: mxs: correct 'direction' of
 device_prep_dma_cyclic
From: Vinod Koul <vinod.koul@intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: alsa-devel@alsa-project.org, Dong Aisheng <dong.aisheng@linaro.org>,
        linux-kernel@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        Liam Girdwood <lrg@ti.com>, linux-arm-kernel@lists.infradead.org
In-Reply-To: <20111223162826.GA28036@opensource.wolfsonmicro.com>
References: <1323791286-29574-1-git-send-email-shawn.guo@linaro.org>
	 <1323848866-19768-1-git-send-email-shawn.guo@linaro.org>
	 <1324656420.1633.15.camel@vkoul-udesk3>
	 <20111223162826.GA28036@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Dec 2011 22:02:50 +0530
Message-ID: <1324657970.1633.22.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-23 at 16:28 +0000, Mark Brown wrote:
> On Fri, Dec 23, 2011 at 09:37:00PM +0530, Vinod Koul wrote:
> 
> > Has this been applied in soc tree? I don't see it in linux-next or do
> > you want this to go thru slave-dma?
> 
> I reverted it, it needs to go with the commit that introduces the new
> API otherwise it breaks bisection.
Okay thanks,

Those are is in my next so I will apply this one to my next as well.

-- 
~Vinod


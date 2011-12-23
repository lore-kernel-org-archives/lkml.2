Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426Ab1LWQ2e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 11:28:34 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42420 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754072Ab1LWQ2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 11:28:30 -0500
Date: Fri, 23 Dec 2011 16:28:27 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Shawn Guo <shawn.guo@linaro.org>, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org, Dong Aisheng <dong.aisheng@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 5/5] ASoC: mxs: correct 'direction' of
 device_prep_dma_cyclic
Message-ID: <20111223162826.GA28036@opensource.wolfsonmicro.com>
References: <1323791286-29574-1-git-send-email-shawn.guo@linaro.org>
 <1323848866-19768-1-git-send-email-shawn.guo@linaro.org>
 <1324656420.1633.15.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324656420.1633.15.camel@vkoul-udesk3>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 23, 2011 at 09:37:00PM +0530, Vinod Koul wrote:

> Has this been applied in soc tree? I don't see it in linux-next or do
> you want this to go thru slave-dma?

I reverted it, it needs to go with the commit that introduces the new
API otherwise it breaks bisection.

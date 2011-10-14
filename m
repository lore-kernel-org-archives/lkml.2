Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456Ab1JNTi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 15:38:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43467 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753444Ab1JNTiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 15:38:25 -0400
Date: Fri, 14 Oct 2011 20:38:24 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Barry Song <21cnbao@gmail.com>, alsa-devel@alsa-project.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 1/2] ASoC: ad193x: Fix define of AD193X_PLL_INPUT_MASK
Message-ID: <20111014193823.GM2931@opensource.wolfsonmicro.com>
References: <1318582919.19976.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318582919.19976.1.camel@phoenix>
X-Cookie: Chess tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 05:01:59PM +0800, Axel Lin wrote:
> Current code defines AD193X_PLL_INPUT_MASK as (~0x6) which is quite
> different from other MASK defines.
> To make it consistent with other mask defines, define AD193X_PLL_INPUT_MASK
> as 0x6 and change the code accordingly.
> I think this change improves the readability.

Applied, thanks.  For the ADI drivers please CC Lars-Peter.  Lars-Peter,
could you please send a MAINTAINERS update if you've not done so already
via some other tree?

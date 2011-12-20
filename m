Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab1LTC6N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 21:58:13 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:8359 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab1LTC6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 21:58:10 -0500
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Tue, 20 Dec 2011 11:07:13 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Shawn Guo <shawn.guo@linaro.org>, <alsa-devel@alsa-project.org>,
        Dong Aisheng <dong.aisheng@linaro.org>, Liam Girdwood <lrg@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH 5/5] ASoC: mxs: correct 'direction' of
 device_prep_dma_cyclic
Message-ID: <20111220030712.GC2995@S2101-09.ap.freescale.net>
References: <1323791286-29574-1-git-send-email-shawn.guo@linaro.org>
 <1323848866-19768-1-git-send-email-shawn.guo@linaro.org>
 <20111220005100.GJ2860@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111220005100.GJ2860@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 12:51:01AM +0000, Mark Brown wrote:
> On Wed, Dec 14, 2011 at 03:47:46PM +0800, Shawn Guo wrote:
> > The commit 49920bc (dmaengine: add new enum dma_transfer_direction)
> > changes the type of parameter 'direction' of device_prep_dma_cyclic
> > from dma_data_direction to dma_transfer_direction.
> 
> Applied, thanks.
> 
> With patches like this you really need to supply more context - knowing
> which release the commit you're talking about appears in is useful for
> exammple,

This patch only applies to -next, as the offending patch only sits on
-next.

> as is having some hint as to what the rest of the series is
> (does this patch depend on any of the earlier patches, and if not why is
> it part of a series).

The reason it's in the series is that they are addressing the same
problem.

-- 
Regards,
Shawn


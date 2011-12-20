Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab1LTAvG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 19:51:06 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59397 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752824Ab1LTAvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 19:51:04 -0500
Date: Tue, 20 Dec 2011 00:51:01 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Liam Girdwood <lrg@ti.com>, Dong Aisheng <dong.aisheng@linaro.org>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 5/5] ASoC: mxs: correct 'direction' of
 device_prep_dma_cyclic
Message-ID: <20111220005100.GJ2860@opensource.wolfsonmicro.com>
References: <1323791286-29574-1-git-send-email-shawn.guo@linaro.org>
 <1323848866-19768-1-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323848866-19768-1-git-send-email-shawn.guo@linaro.org>
X-Cookie: You'll be sorry...
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 03:47:46PM +0800, Shawn Guo wrote:
> The commit 49920bc (dmaengine: add new enum dma_transfer_direction)
> changes the type of parameter 'direction' of device_prep_dma_cyclic
> from dma_data_direction to dma_transfer_direction.

Applied, thanks.

With patches like this you really need to supply more context - knowing
which release the commit you're talking about appears in is useful for
exammple, as is having some hint as to what the rest of the series is
(does this patch depend on any of the earlier patches, and if not why is
it part of a series).

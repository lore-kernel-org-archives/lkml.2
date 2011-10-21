Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab1JUI4i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 04:56:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41478 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753739Ab1JUI4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 04:56:37 -0400
Date: Fri, 21 Oct 2011 09:56:35 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Zeng Zhaoming <zhaoming.zeng@freescale.com>,
        Wolfram Sang <w.sang@pengutronix.de>, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: Use SGTL5000_LINREG_VDDD_MASK instead of hardcoded
 mask value
Message-ID: <20111021085635.GD3513@opensource.wolfsonmicro.com>
References: <1319107769.8866.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319107769.8866.3.camel@phoenix>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 06:49:29PM +0800, Axel Lin wrote:
> We have defined SGTL5000_LINREG_VDDD_MASK in sgtl5000.h,
> use it instead of hardcoded (0x1 << 4) - 1 for the mask.

Applied, thanks.

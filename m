Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab1HVW3l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 18:29:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43305 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753912Ab1HVW3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 18:29:39 -0400
Date: Mon, 22 Aug 2011 23:29:37 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: soc-core: use GFP_KERNEL flag for kmalloc  in
 snd_soc_cnew
Message-ID: <20110822222935.GA30609@opensource.wolfsonmicro.com>
References: <1313809425.4691.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313809425.4691.3.camel@phoenix>
X-Cookie: You will be run over by a beer truck.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 20, 2011 at 11:03:44AM +0800, Axel Lin wrote:
> GFP_ATOMIC is not needed here, use GFP_KERNEL instead.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied, thanks.

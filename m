Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab1HVWaH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 18:30:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43336 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754139Ab1HVWaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 18:30:03 -0400
Date: Mon, 22 Aug 2011 23:30:01 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Julia Lawall <julia@diku.dk>
Cc: Liam Girdwood <lrg@ti.com>, kernel-janitors@vger.kernel.org,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Timur Tabi <timur@freescale.com>, Axel Lin <axel.lin@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 1/2] sound/soc/fsl/p1022_ds.c: add missing of_node_put
Message-ID: <20110822223000.GD30609@opensource.wolfsonmicro.com>
References: <1313823721-16930-1-git-send-email-julia@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313823721-16930-1-git-send-email-julia@diku.dk>
X-Cookie: You will be run over by a beer truck.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 20, 2011 at 09:02:00AM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> dma_channel_np has been accessed at this point, so decrease its reference
> count before leaving the function.

Applied, thanks.

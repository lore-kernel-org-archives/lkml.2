Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab1HVWah (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 18:30:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43374 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753980Ab1HVWaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 18:30:35 -0400
Date: Mon, 22 Aug 2011 23:30:31 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Timur Tabi <timur@freescale.com>
Cc: kernel-janitors@vger.kernel.org, lrg@ti.com, perex@perex.cz, tiwai@suse.de,
        grant.likely@secretlab.ca, alsa-devel@alsa-project.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, julia@diku.dk
Subject: Re: [PATCH] [v2] sound/soc/fsl/fsl_dma.c: add missing of_node_put
Message-ID: <20110822223031.GF30609@opensource.wolfsonmicro.com>
References: <1314022961-27513-1-git-send-email-timur@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314022961-27513-1-git-send-email-timur@freescale.com>
X-Cookie: You will be run over by a beer truck.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 09:22:41AM -0500, Timur Tabi wrote:
> of_parse_phandle increments the reference count of np, so this should be
> decremented before trying the next possibility.
> 
> Since we don't actually use np, we can decrement the reference count
> immediately.

Applied, thanks.

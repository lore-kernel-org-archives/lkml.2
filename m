Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab1HVWaW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 18:30:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43352 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754136Ab1HVWaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 18:30:19 -0400
Date: Mon, 22 Aug 2011 23:30:16 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Julia Lawall <julia@diku.dk>
Cc: Timur Tabi <timur@freescale.com>, kernel-janitors@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Grant Likely <grant.likely@secretlab.ca>,
        alsa-devel@alsa-project.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 2/2] sound/soc/fsl/mpc8610_hpcd.c: add missing of_node_put
Message-ID: <20110822223016.GE30609@opensource.wolfsonmicro.com>
References: <1313823721-16930-2-git-send-email-julia@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313823721-16930-2-git-send-email-julia@diku.dk>
X-Cookie: You will be run over by a beer truck.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 20, 2011 at 09:02:01AM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> The first change is to add an of_node_put, since codec_np has previously
> been allocated.  The rest of the patch reorganizes the error handling code
> so the only code executed is that which is needed.

Applied, thanks.

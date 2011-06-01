Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759420Ab1FASVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 14:21:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54766 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751490Ab1FASVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 14:21:17 -0400
Date: Wed, 1 Jun 2011 19:21:14 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Julia Lawall <julia@diku.dk>
Cc: Liam Girdwood <lrg@ti.com>, kernel-janitors@vger.kernel.org,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Wan ZongShun <mcuos.com@gmail.com>, Axel Lin <axel.lin@gmail.com>,
        Timur Tabi <timur@freescale.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/10] sound/soc/nuc900/nuc900-ac97.c: add missing clk_put
Message-ID: <20110601182114.GC16396@opensource.wolfsonmicro.com>
References: <1306948213-20767-2-git-send-email-julia@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306948213-20767-2-git-send-email-julia@diku.dk>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 01, 2011 at 07:10:05PM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> This goto is after the call to clk_get, so it should go to the label that
> includes a call to clk_put.

Applied, thanks.  Please do try to use subject lines for your patches
consistent with the code you're submitting against.

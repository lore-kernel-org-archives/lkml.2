Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab2IJH7S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 03:59:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51762 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750900Ab2IJH7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 03:59:16 -0400
Date: Mon, 10 Sep 2012 15:58:41 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: Yunfan Zhang <yfzhang@marvell.com>, Liam Girdwood <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: fan53555: remove vsel_max not used
Message-ID: <20120910075838.GE6749@opensource.wolfsonmicro.com>
References: <4737A960563B524DA805CA602BE04B3064CC590795@SC-VEXCH2.marvell.com>
 <CAF+7xWky1N=LHd01aiewEVEhNNLNnuBHHqCBsTHhVd_SbPMjaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF+7xWky1N=LHd01aiewEVEhNNLNnuBHHqCBsTHhVd_SbPMjaA@mail.gmail.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 11:53:55AM +0800, Axel Lin wrote:
> 2012/9/10 Yunfan Zhang <yfzhang@marvell.com>:
> > The max voltage will be bounded by min_uV, uV_step and n_voltages, so
> > remove it to avoid confusing.

Applied, thanks.

> Acked-by: Axel Lin <axel.lin@gmail.com>

I think you meant to say Reviewed-by here - Acked mostly just means that
you're OK with the patch being applied, it's not really saying anything
strong about the patch having been properly reviewed.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751226Ab2BVFl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 00:41:27 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44570 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab2BVFl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 00:41:26 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of shawn.guo@linaro.org designates 10.50.135.37 as permitted sender) smtp.mail=shawn.guo@linaro.org
Date: Wed, 22 Feb 2012 13:54:46 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@stericsson.com>, B29396@freescale.com,
        s.hauer@pengutronix.de, dongas86@gmail.com, thomas.abraham@linaro.org,
        tony@atomide.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 11/20] pinctrl: Downgrade pinctrl_get warning when no
 maps are found
Message-ID: <20120222055443.GA21820@S2101-09.ap.freescale.net>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
 <1329720360-23227-12-git-send-email-swarren@nvidia.com>
 <CACRpkdbpBZqUUwxwF8o8P1P9yknY7SRSzGmYsa3kQ1JH=QNJ7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbpBZqUUwxwF8o8P1P9yknY7SRSzGmYsa3kQ1JH=QNJ7A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 02:51:55PM +0100, Linus Walleij wrote:
> On Mon, Feb 20, 2012 at 7:45 AM, Stephen Warren <swarren@nvidia.com> wrote:
> 
> > This may be perfectly legitimate. An IP block may get re-used
> > across SoCs. Not all of those SoCs may need pinmux settings for the
> > IP block, e.g. if one SoC dedicates pins to that function but
> > another doesn't. The driver won't know this, and will always
> > attempt to set up the pinmux. The mapping table defines whether any
> > HW programming is actually needed.
> >
> > Signed-off-by: Stephen Warren <swarren@nvidia.com>
> 
> This is equivalent to providing dummy pincontrollers as was on my
> TODO for a while admittedly.
> 
> For consistency with regulators it would maybe be better to have
> optional dummy pin controllers but after thinking a bit about it
> I think this is more helpful, so I applied it anyway.
> 
> However I would invite more opinions...
> 
I do not have an opinion on how we do it, and my opinion is just we
need to have it.  So, 

Acked-by: Shawn Guo <shawn.guo@linaro.org>

-- 
Regards,
Shawn

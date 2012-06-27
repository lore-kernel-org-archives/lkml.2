Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757753Ab2F0Ruw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 13:50:52 -0400
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:53394 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753225Ab2F0Ruv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 13:50:51 -0400
Date: Wed, 27 Jun 2012 10:50:37 -0700
From: Mike Turquette <mturquette@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        broonie@opensource.wolfsonmicro.com, rnayak@ti.com,
        viresh.kumar@linaro.org, amit.kucheria@linaro.org,
        linus.walleij@stericsson.com, shawn.guo@freescale.com,
        mkl@pengutronix.de, sr@denx.de, pawel.moll@arm.com,
        maxime.ripard@free-electrons.com, linux@arm.linux.org.uk,
        arnd.bergmann@linaro.org, olof@lixom.net
Subject: Re: linux-next: adding the common clk tree
Message-ID: <20120627175037.GF22766@gmail.com>
References: <20120626015551.GW4402@gmail.com>
 <20120626132502.7584f6acbfc23bdc3d6a8f8e@canb.auug.org.au>
 <20120626230503.GA4402@gmail.com>
 <20120628002925.dd144b4782398042593b6b47@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120628002925.dd144b4782398042593b6b47@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20120628-00:29, Stephen Rothwell wrote:
> Hi Mike,
> 
> On Tue, 26 Jun 2012 16:05:03 -0700 Mike Turquette <mturquette@ti.com> wrote:
> >
> > So please let me know if I still have the concept wrong and I'll change
> > things up.  Otherwise my clk-next fulfils all of the guidelines you've
> > mentioned below for inclusion into linux-next.
> 
> OK, that all seems to be fine.  I would make one suggestion: that you
> create the clk-next branch like this:
> 
> git checkout clk-next
> git reset --hard clk-3.x
> git merge clk-fixes
> git am patches/clk/next/incoming/*.patch
> 
> or maybe just merge clk-fixes directly into clk-3.x when necessary or
> from time to time and base clk-next just in clk-3.x.

Using clk-3.x as a base for clk-next sounds fine to me.  I'll use the
approach you outlined above.

Thanks much,
Mike

> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au



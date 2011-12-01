Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab1LAScP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 13:32:15 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42410 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756086Ab1LAScO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 13:32:14 -0500
Date: Thu, 1 Dec 2011 18:32:11 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: "Turquette, Mike" <mturquette@ti.com>, linux@arm.linux.org.uk,
        linus.walleij@stericsson.com, patches@linaro.org,
        shawn.guo@freescale.com, magnus.damm@gmail.com,
        linux-kernel@vger.kernel.org, amit.kucheria@linaro.org,
        richard.zhao@linaro.org, grant.likely@secretlab.ca, dsaxena@linaro.org,
        eric.miao@linaro.org, sboyd@quicinc.com, skannan@quicinc.com,
        linaro-dev@lists.linaro.org, jeremy.kerr@canonical.com,
        linux-omap@vger.kernel.org, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, arnd.bergmann@linaro.org
Subject: Re: [PATCH v3 3/5] clk: introduce the common clock framework
Message-ID: <20111201183211.GC18120@opensource.wolfsonmicro.com>
References: <1321926047-14211-1-git-send-email-mturquette@linaro.org>
 <1321926047-14211-4-git-send-email-mturquette@linaro.org>
 <alpine.DEB.2.00.1111291619110.6289@utopia.booyaka.com>
 <CAJOA=zM4vcyTt_RBEVm6JxmzW-Dna0gpuWda7ytq_mqFSuXw9g@mail.gmail.com>
 <alpine.DEB.2.00.1111302308280.6289@utopia.booyaka.com>
 <20111201144205.GA2103@sirena.org.uk>
 <alpine.DEB.2.00.1112011124221.6289@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1112011124221.6289@utopia.booyaka.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 11:30:16AM -0700, Paul Walmsley wrote:

> So for example, if you had a driver that did:

> c = clk_get(dev, clk_name);
> clk_enable(c);
> clk_set_rate(c, clk_rate);

> and c was currently not enabled by any other driver on the system, and 
> nothing else had called clk_block_rate_change(c), then the rate change 
> would be allowed to proceed.  (modulo any notifier activity, etc.)  

> So clk_{allow,block}_rate_change() was simply intended to allow or 
> restrict other users of the same clock, not the current user.

Ah, sorry!  I'd totally misunderstood what you were proposing.

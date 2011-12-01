Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab1LAWEM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 17:04:12 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56875 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343Ab1LAWEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 17:04:11 -0500
Date: Thu, 1 Dec 2011 22:03:37 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paul Walmsley <paul@pwsan.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Turquette, Mike" <mturquette@ti.com>, linus.walleij@stericsson.com,
        patches@linaro.org, shawn.guo@freescale.com, magnus.damm@gmail.com,
        linux-kernel@vger.kernel.org, amit.kucheria@linaro.org,
        richard.zhao@linaro.org, grant.likely@secretlab.ca, dsaxena@linaro.org,
        eric.miao@linaro.org, sboyd@quicinc.com, skannan@quicinc.com,
        linaro-dev@lists.linaro.org, jeremy.kerr@canonical.com,
        linux-omap@vger.kernel.org, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, arnd.bergmann@linaro.org
Subject: Re: [PATCH v3 3/5] clk: introduce the common clock framework
Message-ID: <20111201220337.GE19739@n2100.arm.linux.org.uk>
References: <1321926047-14211-1-git-send-email-mturquette@linaro.org> <1321926047-14211-4-git-send-email-mturquette@linaro.org> <alpine.DEB.2.00.1111291619110.6289@utopia.booyaka.com> <CAJOA=zM4vcyTt_RBEVm6JxmzW-Dna0gpuWda7ytq_mqFSuXw9g@mail.gmail.com> <alpine.DEB.2.00.1111302308280.6289@utopia.booyaka.com> <20111201144205.GA2103@sirena.org.uk> <alpine.DEB.2.00.1112011124221.6289@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1112011124221.6289@utopia.booyaka.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 11:30:16AM -0700, Paul Walmsley wrote:
> The intention behind the clk_{allow,block}_rate_change() proposal was to 
> allow the current user of the clock to change its rate without having to 
> call clk_{allow,block}_rate_change(), if that driver was the sole user of 
> the clock.

And how does a driver know that?

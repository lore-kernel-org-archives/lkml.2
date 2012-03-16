Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761187Ab2CPK35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 06:29:57 -0400
Received: from www.linutronix.de ([62.245.132.108]:45125 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760375Ab2CPK3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 06:29:55 -0400
Date: Fri, 16 Mar 2012 11:29:49 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Walleij <linus.walleij@linaro.org>
cc: Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, Mike Turquette <mturquette@ti.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        Paul Walmsley <paul@pwsan.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Richard Zhao <richard.zhao@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v7 1/3] Documentation: common clk API
In-Reply-To: <CACRpkdbXq7zX_XrvAOJc7U6=T0Aaoq+U9_GmZS4fVmVd_arC7A@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1203161129010.2466@ionos>
References: <1331878280-2758-1-git-send-email-mturquette@linaro.org> <1331878280-2758-2-git-send-email-mturquette@linaro.org> <CACRpkdbXq7zX_XrvAOJc7U6=T0Aaoq+U9_GmZS4fVmVd_arC7A@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1403493154-1331893790=:2466"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1403493154-1331893790=:2466
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Fri, 16 Mar 2012, Linus Walleij wrote:

> On Fri, Mar 16, 2012 at 7:11 AM, Mike Turquette <mturquette@linaro.org> wrote:
> 
> > Provide documentation for the common clk structures and APIs.  This code
> > can be found in drivers/clk/ and include/linux/clk*.h.
> 
> Acked-by: Linus Wallej <linus.walleij@linaro.org>
> For this three-piece v7 patchset.
> 
> It already does magnitudes more advanced stuff than what I need
> so I'm pretty pleased, any remaining details can surely be ironed out
> in-tree.

Ack. We really need to get that in now and sort out the details in
tree otherwise we will never finish that thing.

Thanks,

	tglx
--8323328-1403493154-1331893790=:2466--

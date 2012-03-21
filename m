Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648Ab2CUGdH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 02:33:07 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5912 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890Ab2CUGdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 02:33:06 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6655"; a="172026760"
Message-ID: <82f47abcdd341a5071f8c0a178d52310.squirrel@www.codeaurora.org>
In-Reply-To: <CAJOA=zNteC+24oWpqkQJRnL8oqAJe2NcsjHNLbJb1MGN--VEsw@mail.gmail.com>
References: <CAJOA=zN2cSSpM92oRnW0RyU_ZzyoQ=jthc-fAkf-P3z37uWt7w@mail.gmail.com>
    <1332214706-675-1-git-send-email-skannan@codeaurora.org>
    <20120320071957.GH3852@pengutronix.de>
    <348585ed29fb3ff171267c03658e6c0d.squirrel@www.codeaurora.org>
    <CAJOA=zO=wp9oyuBZONk2oCRYdWU1c4qanKJik-8-sFg51p27MQ@mail.gmail.com>
    <4F693DD8.7070305@codeaurora.org>
    <CAJOA=zNteC+24oWpqkQJRnL8oqAJe2NcsjHNLbJb1MGN--VEsw@mail.gmail.com>
Date: Tue, 20 Mar 2012 23:33:05 -0700 (PDT)
Subject: Re: [PATCH 1/2] clk: Fix error handling in fixed clock hardware 
     type register fn
From: "Saravana Kannan" <skannan@codeaurora.org>
To: "Turquette, Mike" <mturquette@ti.com>
Cc: "Saravana Kannan" <skannan@codeaurora.org>,
        "Sascha Hauer" <s.hauer@pengutronix.de>,
        "Andrew Lunn" <andrew@lunn.ch>,
        "Grant Likely" <grant.likely@secretlab.ca>,
        "Jamie Iles" <jamie@jamieiles.com>,
        "Jeremy Kerr" <jeremy.kerr@canonical.com>,
        "Magnus Damm" <magnus.damm@gmail.com>,
        "Deepak Saxena" <dsaxena@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        "Arnd Bergman" <arnd.bergmann@linaro.org>,
        linux-arm-msm@vger.kernel.org, "Rob Herring" <rob.herring@calxeda.com>,
        "Russell King" <linux@arm.linux.org.uk>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Richard Zhao" <richard.zhao@linaro.org>,
        "Shawn Guo" <shawn.guo@freescale.com>,
        "Paul Walmsley" <paul@pwsan.com>,
        "Linus Walleij" <linus.walleij@stericsson.com>,
        "Mark Brown" <broonie@opensource.wolfsonmicro.com>,
        "Stephen Boyd" <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        "Amit Kucheria" <amit.kucheria@linaro.org>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, March 20, 2012 10:45 pm, Turquette, Mike wrote:
> IIRC, that discussion was with respect to the .parent member of struct
> clk.  It was decided that having .parent = NULL does not imply that a
> clock is a root clock, but instead we rely on the CLK_IS_ROOT flag.  I
> can't think of any other instance where a NULL clk when returned from
> a registration function would be useful.

I wasn't referring to a discussion with regards to this patch series. I'm
referring to what I believe was a discussion with Russell King on whether
a NULL from clk_get() should be considered a clock and whether it should
be usable as a "clock" with the clock APIs. That's the reason clk_get()
returns -ENOENT instead of NULL.

-Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.



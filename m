Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030Ab1BWCt3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 21:49:29 -0500
Received: from adelie.canonical.com ([91.189.90.139]:37416 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab1BWCt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 21:49:28 -0500
From: Jeremy Kerr <jeremy.kerr@canonical.com>
To: "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 1/2] Add a common struct clk
Date: Wed, 23 Feb 2011 10:49:17 +0800
User-Agent: KMail/1.13.5 (Linux/2.6.35-25-generic; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenchmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, Dima Zavin <dmitriyz@google.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>, Russell King <linux@arm.linux.org.uk>
References: <1298256658.861611.43913489619.0.gpush@pororo> <1298256658.862188.178150188637.1.gpush@pororo> <20110222201725.GF22310@pengutronix.de>
In-Reply-To: <20110222201725.GF22310@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102231049.17466.jeremy.kerr@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

> > +static inline void clk_common_init(struct clk *clk) { }
> > +
> > +/*
> > + * For !CONFIG_USE_COMMON_STRUCT_CLK, we don't enforce any atomicity
> > + * requirements for clk_enable/clk_disable, so the prepare and unprepare
> > + * functions are no-ops
> > + */
> > +int clk_prepare(struct clk *clk) { return 0; }
> > +void clk_unprepare(struct clk *clk) { }
> 
> these should be static inline.  Otherwise these functions end up in many
> files and so provoke a build failure.

Ugh, brown paper bag time. Thanks for that, I'll update this patch.

Cheers,


Jeremy

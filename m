Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472Ab2CDO1J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 09:27:09 -0500
Received: from londo.lunn.ch ([80.238.139.98]:52404 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969Ab2CDO1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 09:27:07 -0500
Date: Sun, 4 Mar 2012 15:26:48 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Mike Turquette <mturquette@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>, patches@linaro.org,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@ti.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        Paul Walmsley <paul@pwsan.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jamie Iles <jamie@jamieiles.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v5 4/4] clk: basic clock hardware types
Message-ID: <20120304142648.GB11546@lunn.ch>
References: <1330763341-3437-1-git-send-email-mturquette@linaro.org>
 <1330763341-3437-5-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330763341-3437-5-git-send-email-mturquette@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +#define DEFINE_CLK_GATE(_name, _parent_name, _parent_ptr,	\
> +				_flags, _reg, _bit_idx,		\
> +				_gate_flags, _lock)		\
> +	static struct clk _name;				\
> +	static char *_name##_parent_names[] = {			\
> +		_parent_name,					\
> +	};							\
> +	static struct clk *_name##_parents[] = {		\
> +		_parent_ptr,					\
> +	};							\
> +	static struct clk_gate _name##_hw = {			\
> +		.hw = {						\
> +			.clk = &_name,				\
> +		},						\
> +		.reg = _reg,					\
> +		.bit_idx = _bit_idx,				\
> +		.flags = _gate_flags				\

Hi Mike

Looks like a , is missing here after _gate_flags.

      Andrew

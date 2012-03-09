Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab2CICei (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 21:34:38 -0500
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:47905
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752365Ab2CICeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 21:34:37 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzzz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Fri, 9 Mar 2012 10:34:19 +0800
From: Richard Zhao <richard.zhao@freescale.com>
To: Mike Turquette <mturquette@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Paul Walmsley <paul@pwsan.com>, <linaro-dev@lists.linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>, <patches@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Magnus Damm <magnus.damm@gmail.com>, <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>, Andrew Lunn <andrew@lunn.ch>,
        Shawn Guo <shawn.guo@freescale.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        <linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@ti.com>
Subject: Re: [PATCH v5 0/4] common clk framework
Message-ID: <20120309023418.GF3261@b20223-02.ap.freescale.net>
References: <1330763341-3437-1-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1330763341-3437-1-git-send-email-mturquette@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mike,

The main interface for clk implementer is to register clocks dynamically.
I think it highly depends on clk DT bindings. From the patch Grant sent
out, it looks like he doesn't like one node per clk. So how do we
register clocks dynamically? You have any sample code?

Thanks
Richard


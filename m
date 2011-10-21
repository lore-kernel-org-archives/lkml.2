Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab1JUJAs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 05:00:48 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:36806
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753907Ab1JUJAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 05:00:46 -0400
X-SpamScore: 4
X-BigFish: VS4(z1039oz98dKzz1202hzzz2dh87h2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 0,13,
X-FB-DOMAIN-IP-MATCH: fail
Date: Fri, 21 Oct 2011 17:00:07 +0800
From: Richard Zhao <richard.zhao@linaro.org>
To: Mike Turquette <mturquette@ti.com>
CC: <linux-kernel@vger.kernel.org>, <paul@pwsan.com>,
        <linaro-dev@lists.linaro.org>, <linus.walleij@stericsson.com>,
        <patches@linaro.org>, <eric.miao@linaro.org>,
        <broonie@opensource.wolfsonmicro.com>, <magnus.damm@gmail.com>,
        <amit.kucheria@linaro.org>, <grant.likely@secretlab.ca>,
        <dsaxena@linaro.org>, <arnd.bergmann@linaro.org>,
        <shawn.guo@freescale.com>, <skannan@quicinc.com>,
        <linux@arm.linux.org.uk>, <jeremy.kerr@canonical.com>,
        <tglx@linutronix.de>, <linux-arm-kernel@lists.infradead.org>,
        <sboyd@quiinc.com>
Subject: Re: [PATCH v2 1/7] clk: Add a generic clock infrastructure
Message-ID: <20111021090005.GA12133@b20223-02.ap.freescale.net>
References: <1316730422-20027-1-git-send-email-mturquette@ti.com>
 <1316730422-20027-2-git-send-email-mturquette@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1316730422-20027-2-git-send-email-mturquette@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 03:26:56PM -0700, Mike Turquette wrote:
> +/* For USE_COMMON_STRUCT_CLK, these are provided in clk.c, but not exported
> + * through other headers; we don't want them used anywhere but here. */
> +#ifdef CONFIG_USE_COMMON_STRUCT_CLK
change to CONFIG_GENERIC_CLK?
> +extern int __clk_get(struct clk *clk);
> +extern void __clk_put(struct clk *clk);
clk.c does not define it.
> +#endif

Thanks
Richard 


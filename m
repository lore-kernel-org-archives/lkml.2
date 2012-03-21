Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276Ab2CUFqt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 01:46:49 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:49061 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756123Ab2CUFqa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 01:46:30 -0400
MIME-Version: 1.0
In-Reply-To: <CAJOA=zOZ=XNwhEwUSD34AERi+f8fnMqG9EmS5hxCx+2u8qnkgw@mail.gmail.com>
References: <1331878280-2758-1-git-send-email-mturquette@linaro.org>
	<1331878280-2758-3-git-send-email-mturquette@linaro.org>
	<20120320140220.GE32469@S2101-09.ap.freescale.net>
	<CAJOA=zOZ=XNwhEwUSD34AERi+f8fnMqG9EmS5hxCx+2u8qnkgw@mail.gmail.com>
Date: Wed, 21 Mar 2012 13:46:28 +0800
Message-ID: <CAAQ0ZWRyowjHvR0_T-cA8UmbMNpo6yd6OLJ_HPh4foVULF0Tyg@mail.gmail.com>
Subject: Re: [PATCH v7 2/3] clk: introduce the common clock framework
From: Shawn Guo <shawn.guo@linaro.org>
To: "Turquette, Mike" <mturquette@ti.com>
Cc: Paul Walmsley <paul@pwsan.com>, Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@stericsson.com>, patches@linaro.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Saravana Kannan <skannan@codeaurora.org>, linaro-dev@lists.linaro.org,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 March 2012 07:46, Turquette, Mike <mturquette@ti.com> wrote:
...
> As mentioned above, you'll still need to check for CLK_SET_RATE_PARENT
> in your .round_rate implementation with __clk_get_flags(hw->clk).
>
For my particular case, the clk is PLL with fixed rate clk
(oscillator) as parent.  It's known that flag CLK_SET_RATE_PARENT will
never be set for this type of clks.

> Did you want to send a formal patch or just have me absorb this into
> the fixes I'm brewing already?  I've already fixed the potential null
> ptr dereferences in clk_calc_new_rates, but that's no big deal.
>
The code was attached for better discussion, and I would leave the
formal patch to you.

Regards,
Shawn

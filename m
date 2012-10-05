Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab2JEBNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 21:13:30 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:53453 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307Ab2JEBN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 21:13:28 -0400
Date: Fri, 5 Oct 2012 10:13:24 +0900
From: Simon Horman <horms@verge.net.au>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Brown <davidb@codeaurora.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <kernel@pengutronix.de>,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tony Lindgren <tony@atomide.com>,
        Viresh Kumar <viresh.linux@gmail.com>
Subject: Re: [PATCH] ARM: Push selects for TWD/SCU into machine entries
Message-ID: <20121005011324.GB17182@verge.net.au>
References: <1349340644-13937-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349340644-13937-1-git-send-email-sboyd@codeaurora.org>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 01:50:44AM -0700, Stephen Boyd wrote:
> The TWD and SCU configs are selected by default as long as
> SCORPIONMP is false and/or MCT is false. Implementing the logic
> this way certainly saves lines in the Kconfig but it precludes
> those machines which select SCORPIONMP or MCT from participating
> in the single zImage effort because when those machines are
> combined with other SMP capable machines the TWD and SCU are no
> longer selected.
> 
> Push the select out to the machine entries so that we can compile
> these machines together and still select the appropriate configs.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> Cc: David Brown <davidb@codeaurora.org>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Sascha Hauer <kernel@pengutronix.de>
> Cc: Shiraz Hashim <shiraz.hashim@st.com>
> Cc: Simon Horman <horms@verge.net.au>
> Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
> Cc: Stephen Warren <swarren@wwwdotorg.org>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Viresh Kumar <viresh.linux@gmail.com>
> ---

The shmobile portion of this change seems fine to me.

Acked-by: Simon Horman <horms@verge.net.au>

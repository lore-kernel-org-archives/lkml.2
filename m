Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992682Ab2JYUeW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 16:34:22 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8510 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935649Ab2JYUeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 16:34:20 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6876"; a="1849433"
Date: Thu, 25 Oct 2012 13:34:03 -0700
From: David Brown <davidb@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <kernel@pengutronix.de>,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCHv2] ARM: Push selects for TWD/SCU into machine entries
Message-ID: <20121025203403.GA20767@codeaurora.org>
References: <1351099475-29349-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351099475-29349-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 10:24:35AM -0700, Stephen Boyd wrote:
> The TWD and SCU configs are selected by default as long as
> MSM_SCORPIONMP is false and/or MCT is false. Implementing the
> logic this way certainly saves lines in the Kconfig but it
> precludes those machines which select MSM_SCORPIONMP or MCT from
> participating in the single zImage effort because when those
> machines are combined with other SMP capable machines the TWD and
> SCU are no longer selected by default.
> 
> Push the select out to the machine entries so that we can compile
> these machines together and still select the appropriate configs.

>  arch/arm/mach-msm/Kconfig      | 7 ++-----

Acked-by: David Brown <davidb@codeaurora.org>

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

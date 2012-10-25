Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760025Ab2JYSFH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 14:05:07 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10433 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab2JYSFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 14:05:05 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6876"; a="1860632"
Message-ID: <50897F39.9030702@codeaurora.org>
Date: Thu, 25 Oct 2012 11:04:41 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Brown <davidb@codeaurora.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <kernel@pengutronix.de>,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Tony Lindgren <tony@atomide.com>, "arm@kernel.org" <arm@kernel.org>
Subject: Re: [PATCHv2] ARM: Push selects for TWD/SCU into machine entries
References: <1351099475-29349-1-git-send-email-sboyd@codeaurora.org> <50882B6E.5020103@wwwdotorg.org>
In-Reply-To: <50882B6E.5020103@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/12 10:54, Stephen Warren wrote:
> Where will this patch be merged?
>
> It probably won't happen for 3.8, but that config fragment will move to
> arch/arm/mach-tegra/Kconfig when Tegra enables single zImage support, I
> believe. So, it'd be good to make sure this patch gets merged somewhere
> that could be used as a baseline for other arm-soc branches if needed,
> to avoid merge conflicts.

I was hoping this could go through the arm-soc tree for the 3.8 merge
window.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab2DLEaR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 00:30:17 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:56135 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752675Ab2DLEaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 00:30:16 -0400
Message-ID: <4F8659DA.4030305@st.com>
Date: Thu, 12 Apr 2012 09:58:10 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
Cc: "arnd.bergmann@linaro.org" <arnd.bergmann@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Andrew Lunn <andrew@lunn.ch>, Rajendra Nayak <rnayak@ti.com>,
        spear-devel <spear-devel@list.st.com>
Subject: Re: [PATCH 01/13] clk: core: correct clk_set_rate kerneldoc
References: <1334192572-12499-1-git-send-email-mturquette@linaro.org> <1334192572-12499-2-git-send-email-mturquette@linaro.org>
In-Reply-To: <1334192572-12499-2-git-send-email-mturquette@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/12/2012 6:32 AM, Mike Turquette wrote:
> - * If clk has the CLK_SET_RATE_GATE flag set and it is enabled this call
> - * will fail; only when the clk is disabled will it be able to change
> - * its rate.

Why is CLK_SET_RATE_GATE removed? I already sent a patch to fix clk_set_rate()
for this. And i think it should be required.

-- 
viresh

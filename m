Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab2DMWXk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 18:23:40 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:52972 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751979Ab2DMWXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 18:23:38 -0400
MIME-Version: 1.0
In-Reply-To: <4F8659DA.4030305@st.com>
References: <1334192572-12499-1-git-send-email-mturquette@linaro.org>
 <1334192572-12499-2-git-send-email-mturquette@linaro.org> <4F8659DA.4030305@st.com>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Fri, 13 Apr 2012 15:23:16 -0700
Message-ID: <CAJOA=zMHGO6N2q=StogU3envVBt23o-2Od70gtdRkQG_Ku7=CA@mail.gmail.com>
Subject: Re: [PATCH 01/13] clk: core: correct clk_set_rate kerneldoc
To: Viresh Kumar <viresh.kumar@st.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Rajendra Nayak <rnayak@ti.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        spear-devel <spear-devel@list.st.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        Shawn Guo <shawn.guo@freescale.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        "arnd.bergmann@linaro.org" <arnd.bergmann@linaro.org>,
        Richard Zhao <richard.zhao@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 9:28 PM, Viresh Kumar <viresh.kumar@st.com> wrote:
> On 4/12/2012 6:32 AM, Mike Turquette wrote:
>> - * If clk has the CLK_SET_RATE_GATE flag set and it is enabled this call
>> - * will fail; only when the clk is disabled will it be able to change
>> - * its rate.
>
> Why is CLK_SET_RATE_GATE removed? I already sent a patch to fix clk_set_rate()
> for this. And i think it should be required.

I removed it from the documentation since it was not present in the
code.  I was originally targeting this for an -rc and I was trying to
limit the changes purely to fixes and cleanups, not new features.

I haven't finished digging through all of the responses yet, so my
goal for where these patches are headed might change.

Regards,
Mike

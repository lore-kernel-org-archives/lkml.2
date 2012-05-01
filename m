Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758499Ab2EASEE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 14:04:04 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29227 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758427Ab2EASEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 14:04:00 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6698"; a="186596780"
Message-ID: <4FA0258D.8020807@codeaurora.org>
Date: Tue, 01 May 2012 11:03:57 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:12.0) Gecko/20120420 Thunderbird/12.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Shawn Guo <shawn.guo@linaro.org>, "Turquette, Mike" <mturquette@ti.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Grant Likely <grant.likely@secretlab.ca>, h@pengutronix.de,
        Jamie Iles <jamie@jamieiles.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Arnd Bergman <arnd.bergmann@linaro.org>, linux-arm-msm@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Zhao <richard.zhao@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>, Paul Walmsley <paul@pwsan.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Amit Kucheria <amit.kucheria@linaro.org>
Subject: Re: [PATCH] clk: Use a separate struct for holding init data.
References: <1335419936-10881-1-git-send-email-skannan@codeaurora.org> <4F98EB10.2000505@codeaurora.org> <20120426084201.GF17184@pengutronix.de> <4d67387a86d99cbb4e2acf68d3588b1c.squirrel@www.codeaurora.org> <20120426095135.GG17184@pengutronix.de> <4F9EE84C.90106@codeaurora.org> <CAJOA=zNCagT6GaeHi_jq7-LU9P-SfJZ8PA9bo-oeswjC0tHyYA@mail.gmail.com> <4F9F1659.1010804@codeaurora.org> <20120501081103.GC2194@S2101-09.ap.freescale.net> <20120501091334.GG15541@lunn.ch> <20120501170001.GB4089@opensource.wolfsonmicro.com>
In-Reply-To: <20120501170001.GB4089@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2012 10:00 AM, Mark Brown wrote:
> On Tue, May 01, 2012 at 11:13:34AM +0200, Andrew Lunn wrote:
>
>> I agree with you as well, it is frustrating. Could we agree, that once
>> this patch is in, we freeze the core until the start of the next
>> cycle. We use the remainder of this cycle for porting platforms to the
>> generic clock framework.
>
> Or merge the platforms then do framework changes incrementally, updating
> the platforms as we go (which is the normal pattern for maintaining a
> framework...).  I see we've already got SPEAr merged.

Sorry for the annoyance I seem to have caused. I too have been trying to 
get this in for a while before the other platforms started using the new 
framework. Not everyone was free at the same time and it's taken longer 
that I would have wished for.

I did my best to limit the changes that would be needed without making 
my patch useless. Appreciate your understanding.

Regards,
Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

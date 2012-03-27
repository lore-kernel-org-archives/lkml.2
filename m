Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828Ab2C0W1i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 18:27:38 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46428 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332Ab2C0W1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 18:27:36 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6662"; a="176346556"
Message-ID: <4F723ED7.7010800@codeaurora.org>
Date: Tue, 27 Mar 2012 15:27:35 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: "Turquette, Mike" <mturquette@ti.com>
CC: Sascha Hauer <s.hauer@pengutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Grant Likely <grant.likely@secretlab.ca>,
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
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH 2/2] clk: Move init fields from clk to clk_hw
References: <CAJOA=zN2cSSpM92oRnW0RyU_ZzyoQ=jthc-fAkf-P3z37uWt7w@mail.gmail.com> <1332214706-675-1-git-send-email-skannan@codeaurora.org> <1332214706-675-2-git-send-email-skannan@codeaurora.org> <20120320072018.GC32469@S2101-09.ap.freescale.net> <cbd6490459b9fd68875fec4a7c7de073.squirrel@www.codeaurora.org> <20120320094031.GI3852@pengutronix.de> <20120320141811.GF32469@S2101-09.ap.freescale.net> <20120320181050.GN3852@pengutronix.de> <4F68E34A.70207@codeaurora.org> <20120320231242.GP3852@pengutronix.de> <CAJOA=zOGTW7OqACWgJQW6HSPLVev+apdNhv4vNXjHTcp=7N+uQ@mail.gmail.com> <4F694484.1030706@codeaurora.org> <4F714397.6080608@codeaurora.org> <CAJOA=zOq=kYfZUEnnQT_D4w=Kpp5n7R=k9oOCrxF59P5W-nw-w@mail.gmail.com>
In-Reply-To: <CAJOA=zOq=kYfZUEnnQT_D4w=Kpp5n7R=k9oOCrxF59P5W-nw-w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2012 11:49 AM, Turquette, Mike wrote:
> On Mon, Mar 26, 2012 at 9:35 PM, Saravana Kannan<skannan@codeaurora.org>  wrote:
>> Mike,
>>
>> (*nudge*) (*nudge*)
>
> Hi Saravana,
>
> I spent some time mulling over the ideas this weekend and I agree that
> we have 3 types of data, so having the three structs makes some sense.
>   I'm checking this patch out more earnestly today.
>

Thanks Mike. The patch has a few things to clean up. I would be glad to 
send out a cleaned up patch once we have an approximate consensus on 
what to copy/not copy.

Thanks,
Saravana

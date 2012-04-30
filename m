Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349Ab2D3Wqv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 18:46:51 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52225 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756846Ab2D3Wqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 18:46:50 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6697"; a="184106963"
Message-ID: <4F9F1659.1010804@codeaurora.org>
Date: Mon, 30 Apr 2012 15:46:49 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:12.0) Gecko/20120420 Thunderbird/12.0
MIME-Version: 1.0
To: "Turquette, Mike" <mturquette@ti.com>
CC: Sascha Hauer <s.hauer@pengutronix.de>, Andrew Lunn <andrew@lunn.ch>,
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
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Amit Kucheria <amit.kucheria@linaro.org>
Subject: Re: [PATCH] clk: Use a separate struct for holding init data.
References: <1335419936-10881-1-git-send-email-skannan@codeaurora.org> <4F98EB10.2000505@codeaurora.org> <20120426084201.GF17184@pengutronix.de> <4d67387a86d99cbb4e2acf68d3588b1c.squirrel@www.codeaurora.org> <20120426095135.GG17184@pengutronix.de> <4F9EE84C.90106@codeaurora.org> <CAJOA=zNCagT6GaeHi_jq7-LU9P-SfJZ8PA9bo-oeswjC0tHyYA@mail.gmail.com>
In-Reply-To: <CAJOA=zNCagT6GaeHi_jq7-LU9P-SfJZ8PA9bo-oeswjC0tHyYA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2012 03:19 PM, Turquette, Mike wrote:
> On Mon, Apr 30, 2012 at 12:30 PM, Saravana Kannan
> <skannan@codeaurora.org>  wrote:
>> Mike, Shawn, Paul, Rob,
>>
>> Comments? Can we pull this in?
>
> Saravana,
>
> I will test this a bit more thoroughly tomorrow and get back to you.
>
> Thanks,
> Mike

Thanks Mike!

I'm still hoping a Ack/Nack for the general idea from the others.

-Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

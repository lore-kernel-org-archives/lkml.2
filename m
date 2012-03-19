Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032530Ab2CSS4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 14:56:36 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:43771 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031907Ab2CSS4e convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 14:56:34 -0400
MIME-Version: 1.0
In-Reply-To: <4F6404C2.7000506@codeaurora.org>
References: <1331878280-2758-1-git-send-email-mturquette@linaro.org>
 <1331878280-2758-3-git-send-email-mturquette@linaro.org> <4F6404C2.7000506@codeaurora.org>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Mon, 19 Mar 2012 11:56:11 -0700
Message-ID: <CAJOA=zP1HHqBNS4V2dN=Q9oOcOErQj8W__fB_qRyZeNLBk7VJg@mail.gmail.com>
Subject: Re: [PATCH v7 2/3] clk: introduce the common clock framework
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>, Paul Walmsley <paul@pwsan.com>,
        Linus Walleij <linus.walleij@stericsson.com>, patches@linaro.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Richard Zhao <richard.zhao@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Deepak Saxena <dsaxena@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>, linaro-dev@lists.linaro.org,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 8:28 PM, Saravana Kannan <skannan@codeaurora.org> wrote:
> On 03/15/2012 11:11 PM, Mike Turquette wrote:
>>
>> The common clock framework defines a common struct clk useful across
>> most platforms as well as an implementation of the clk api that drivers
>> can use safely for managing clocks.
>>
>> The net result is consolidation of many different struct clk definitions
>> and platform-specific clock framework implementations.
>>
>> This patch introduces the common struct clk, struct clk_ops and an
>> implementation of the well-known clock api in include/clk/clk.h.
>> Platforms may define their own hardware-specific clock structure and
>> their own clock operation callbacks, so long as it wraps an instance of
>> struct clk_hw.
>>
>> See Documentation/clk.txt for more details.
>>
>> This patch is based on the work of Jeremy Kerr, which in turn was based
>> on the work of Ben Herrenschmidt.
>>
>> Signed-off-by: Mike Turquette<mturquette@linaro.org>
>> Signed-off-by: Mike Turquette<mturquette@ti.com>
>> Reviewed-by: Thomas Gleixner<tglx@linutronix.de>
>> Tested-by: Andrew Lunn<andrew@lunn.ch>
>> Reviewed-by: Rob Herring<rob.herring<at>  calxeda.com>
>> Cc: Russell King<linux@arm.linux.org.uk>
>> Cc: Jeremy Kerr<jeremy.kerr@canonical.com>
>> Cc: Arnd Bergman<arnd.bergmann@linaro.org>
>> Cc: Paul Walmsley<paul@pwsan.com>
>> Cc: Shawn Guo<shawn.guo@freescale.com>
>> Cc: Sascha Hauer<s.hauer@pengutronix.de>
>> Cc: Richard Zhao<richard.zhao@linaro.org>
>> Cc: Saravana Kannan<skannan@codeaurora.org>
>> Cc: Magnus Damm<magnus.damm@gmail.com>
>> Cc: Mark Brown<broonie@opensource.wolfsonmicro.com>
>> Cc: Linus Walleij<linus.walleij@stericsson.com>
>> Cc: Stephen Boyd<sboyd@codeaurora.org>
>> Cc: Amit Kucheria<amit.kucheria@linaro.org>
>> Cc: Deepak Saxena<dsaxena@linaro.org>
>> Cc: Grant Likely<grant.likely@secretlab.ca>
>> ---
>
>
> Mike,
>
> Thanks for the patches! Glad to see that it's finally getting in! I sent a
> request for a minor change as a reply to the v5 series (since it had more
> context). Can you please take a look at that and let me know if you can send
> out a v8 or a patch on top of this to do that?

Hi Saravana,

I'm not sending a v8 series since Arnd has taken in v7 for the 3.4 merge window.

I'm formulating a reply to your v5 queries, but I'm not done looking
at the implications of the initializer stuff.  Lets keep the technical
discussion in that thread for now.

Regards,
Mike

>
> Thanks,
> Saravana
>
> --
> Sent by an employee of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

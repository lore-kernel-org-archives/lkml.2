Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965480Ab2CPLO1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 07:14:27 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40382 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab2CPLOZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 07:14:25 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1203161129010.2466@ionos>
References: <1331878280-2758-1-git-send-email-mturquette@linaro.org>
	<1331878280-2758-2-git-send-email-mturquette@linaro.org>
	<CACRpkdbXq7zX_XrvAOJc7U6=T0Aaoq+U9_GmZS4fVmVd_arC7A@mail.gmail.com>
	<alpine.LFD.2.02.1203161129010.2466@ionos>
Date: Fri, 16 Mar 2012 13:14:20 +0200
Message-ID: <CAP245DXV5oE+-y+PQCcSM016h-J+UgTi1efmdrcyeQge4k1Cfw@mail.gmail.com>
Subject: Re: [PATCH v7 1/3] Documentation: common clk API
From: Amit Kucheria <amit.kucheria@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        Mike Turquette <mturquette@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, Mike Turquette <mturquette@ti.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Paul Walmsley <paul@pwsan.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Richard Zhao <richard.zhao@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 12:29 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Fri, 16 Mar 2012, Linus Walleij wrote:
>
>> On Fri, Mar 16, 2012 at 7:11 AM, Mike Turquette <mturquette@linaro.org> wrote:
>>
>> > Provide documentation for the common clk structures and APIs.  This code
>> > can be found in drivers/clk/ and include/linux/clk*.h.
>>
>> Acked-by: Linus Wallej <linus.walleij@linaro.org>
>> For this three-piece v7 patchset.
>>
>> It already does magnitudes more advanced stuff than what I need
>> so I'm pretty pleased, any remaining details can surely be ironed out
>> in-tree.
>
> Ack. We really need to get that in now and sort out the details in
> tree otherwise we will never finish that thing.
>

Thomas, Russell, Arnd,

Can we shoe-horn this thing into 3.4 (it is a bit late, i know) so
that platform ports can gather speed? Several people are waiting for a
somewhat stable version before starting their ports.

And what is the path into mainline - will Russell carry it or Arnd
(with Russell's blessing)?

Regards,
Amit

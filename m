Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161471Ab2CPVki (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 17:40:38 -0400
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:57151 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932382Ab2CPVkh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 17:40:37 -0400
MIME-Version: 1.0
In-Reply-To: <201203162057.58706.arnd@arndb.de>
References: <1331878280-2758-1-git-send-email-mturquette@linaro.org>
 <CAP245DXV5oE+-y+PQCcSM016h-J+UgTi1efmdrcyeQge4k1Cfw@mail.gmail.com>
 <201203161218.05125.arnd.bergmann@linaro.org> <201203162057.58706.arnd@arndb.de>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Fri, 16 Mar 2012 14:40:11 -0700
Message-ID: <CAJOA=zNL2WeMzrEBRw_2OeYRfwHjxUjSJLgHzrWzFXR9Yvsvug@mail.gmail.com>
Subject: Re: [PATCH v7 1/3] Documentation: common clk API
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, linaro-dev@lists.linaro.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Saravana Kannan <skannan@codeaurora.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>, patches@linaro.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Zhao <richard.zhao@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>, Paul Walmsley <paul@pwsan.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 1:57 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 16 March 2012, Arnd Bergmann wrote:
>> >
>> > Can we shoe-horn this thing into 3.4 (it is a bit late, i know) so
>> > that platform ports can gather speed? Several people are waiting for a
>> > somewhat stable version before starting their ports.
>> >
>> > And what is the path into mainline - will Russell carry it or Arnd
>> > (with Russell's blessing)?
>>
>> I would suggest putting it into a late/* branch of arm-soc so it finally
>> gets some linux-next exposure, and then sending it in the second week of the
>> merge window.
>>
>> Russell, please let me know if you want to carry it instead or if you
>> have found any last-minute show stoppers in the code.
>
> FWIW, it's in arm-soc now, and it's the last thing I  put in there
> for v3.4. From now on until v3.4-rc1, feature patches can only get
> removed from arm-soc, not added.

Thanks Arnd.

Regards,
Mike

>
>        Arnd

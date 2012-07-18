Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab2GRHfh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 03:35:37 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59371 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab2GRHf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 03:35:26 -0400
Message-ID: <50066739.4010206@linaro.org>
Date: Wed, 18 Jul 2012 08:35:21 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Wolfram Sang <w.sang@pengutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alessandro Rubini <rubini@gnudd.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: linux-next: manual merge of the arm-soc tree with the i2c-embedded
 tree
References: <5003FB7C.4030509@linaro.org> <20120717130650.GB27595@sirena.org.uk> <500568D9.10805@linaro.org> <20120717133550.GC4477@opensource.wolfsonmicro.com> <50057058.2060002@linaro.org> <20120717142222.GE4477@opensource.wolfsonmicro.com> <50057C1A.80606@linaro.org> <20120717152001.GF4477@opensource.wolfsonmicro.com>
In-Reply-To: <20120717152001.GF4477@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/07/12 16:20, Mark Brown wrote:
> On Tue, Jul 17, 2012 at 03:52:10PM +0100, Lee Jones wrote:
> 
>> I think it would be okay to take the 3 patches due for the v3.6
>> merge window, which target the nmk-i2c driver. If any consolidation
>> happens in the mean-time/future I will personally do the work to
>> bring the nmk-i2c into line to use any generic bindings which
>> result.
> 
>> No one else is ever going to use these vendor specific bindings, so
>> I'm sure no issues will arise. It also means that we have a fully
>> enabled driver which is capable of receiving a new configuration via
>> minor changes to the dts, which is important for the current (only)
>> user of this driver for an upcoming project.
> 
> So, this is pretty much what vendors always say about this stuff...

I agree, but in this instance it really does stand to reason.

1. No unified bindings currently exist.
2. I don't have time to create them.
3. It will probably take quite a bit of time for someone else to get round to creating them.
4. The bindings I'm proposing are siloed by vendor and driver, so will cause no harm.
5. I've already volunteered to move them over to the unified ones once created.
6. These allow support for the driver to work with DT, at the moment it does not.

Personally, I think there is more to be gained by applying the (working) vendor specific bindings to the vendor specific driver until some more consolidated ones appear.

> Looking at what's specified in the platform data in the current kernel
> it seems like there's a mixture of things in there that are board and
> silicon specific.  We've got parameters like the the speed mode and
> timeout which are reasonably board specific but we've also got things
> like the FIFO sizes which shouldn't be at all board specific and slsu
> which really looks like it's something that that the driver ought to be
> able to figure out for itself.
> 


-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515 
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog



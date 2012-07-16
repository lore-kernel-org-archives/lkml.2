Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142Ab2GPLbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 07:31:18 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57351 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab2GPLbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 07:31:13 -0400
Message-ID: <5003FB7C.4030509@linaro.org>
Date: Mon, 16 Jul 2012 12:31:08 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: Linus Walleij <linus.walleij@linaro.org>,
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
References: <20120710164130.f38e4d1673f925ddb13914c9@canb.auug.org.au> <20120712131231.GH2194@pengutronix.de> <CACRpkdboeF_G=sTPeSyuZ6KGLCmGSKx_NS=6Rim6HkR2f9=AAQ@mail.gmail.com> <20120716101706.GB17435@pengutronix.de>
In-Reply-To: <20120716101706.GB17435@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/07/12 11:17, Wolfram Sang wrote:
>
>> Well I think I ACKed that from the point of view that it will work as
>> expected with ux500 with these bindings. What is best from the I2C
>> subsystem point of view is another question ...
>
> Okay, thanks for clarifying.
>
>> Overall I think we have this general problem with a lot of DT
>> conversion happening right now: the tempo is set very high and
>> all chip vendors want DT support RealQuickNowPreferrablyYesterday
>> and that makes it hard for subsystem maintainers to hold back,
>> and I also fear vendor-specific properties are overused for this
>> reason.
>
> Word.
>
>> And about the perpetual nature of device tree bindings it
>> appears to me that the modus operandi right now is to not
>> regard any of these as written in stone until they are removed
>> from the kernel tree. We have plenty of drivers patching
>> trees and drivers in one for the moment.
>
> I don't get this one. Yes, they are of perpetual nature, so how could we
> remove them from the kernel tree?
>
> What I am afraid of is: tentative solutions tend to stay, because the
> need for a proper solution is reduced. Yet, finding proper generic
> bindings might take some time which doesn't meet the high pressure
> around DT at the moment.

I agree with what you say to some extent, but I believe that it is more 
important to have a working solution now than to ensure that each 
bindings are as unique as possible. After any suggestion of 
consolidation, a move from vendor specific to generically defined Device 
Tree bindings is trivial. Especially in the current stage where 
adaptions and definitions are still fluid.

Obviously some care is taken to ensure the bindings are as generic as 
possible, but not to the extent that will put the project back some 
months. Over past few months I have enabled many sub-systems; however, I 
think it would have been a fraction of that if we'd gone through the 
laborious process of immediate forced consolidation. I think it's fine 
to have platform/vendor specific bindings that work, then come back to 
unify them once the dust settles.

If you know of any bindings which you know are generic, I'm happy to 
define and swap them out for the ones I've proposed, but due to a change 
of project focus I can't afford to spend hours studying all of the 
drivers to match-up possible unifications.

Kind regards,
Lee

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog



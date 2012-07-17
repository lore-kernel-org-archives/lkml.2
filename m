Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab2GQNaI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 09:30:08 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64413 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899Ab2GQNaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 09:30:05 -0400
Message-ID: <500568D9.10805@linaro.org>
Date: Tue, 17 Jul 2012 14:30:01 +0100
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
References: <5003FB7C.4030509@linaro.org> <20120717130650.GB27595@sirena.org.uk>
In-Reply-To: <20120717130650.GB27595@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/07/12 14:06, Mark Brown wrote:
> On Mon, Jul 16, 2012 at 12:31:08PM +0100, Lee Jones wrote:
>
>> I agree with what you say to some extent, but I believe that it is
>> more important to have a working solution now than to ensure that
>> each bindings are as unique as possible. After any suggestion of
>> consolidation, a move from vendor specific to generically defined
>> Device Tree bindings is trivial. Especially in the current stage
>> where adaptions and definitions are still fluid.
>
>> Obviously some care is taken to ensure the bindings are as generic
>> as possible, but not to the extent that will put the project back
>> some months. Over past few months I have enabled many sub-systems;
>
> It's not just about having generic bindings, it's also about having
> bindings which have some abstraction and hope of reusability. An awful
> lot of bindings are just straight dumps of Linux data structures into
> the device tree which don't make a terribly great deal of sense as
> bindings.

The Device Tree should supply any platform configuration which the 
driver needs in order to correctly setup for a particular machine. This 
is exactly what the platform_data structure did before, hence is is 
reasonable to assume that whatever information resides in that structure 
would be required in the Device Tree.

>> however, I think it would have been a fraction of that if we'd gone
>> through the laborious process of immediate forced consolidation. I
>> think it's fine to have platform/vendor specific bindings that work,
>> then come back to unify them once the dust settles.
>
> In many of these cases we'd be better off just not putting things into
> the device tree in the first place, leaving things at the basic "is the
> device there" stuff.

Then what do you do with the platform data?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog



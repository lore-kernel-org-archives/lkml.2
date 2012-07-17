Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152Ab2GQOCJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 10:02:09 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56764 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981Ab2GQOCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 10:02:05 -0400
Message-ID: <50057058.2060002@linaro.org>
Date: Tue, 17 Jul 2012 15:02:00 +0100
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
References: <5003FB7C.4030509@linaro.org> <20120717130650.GB27595@sirena.org.uk> <500568D9.10805@linaro.org> <20120717133550.GC4477@opensource.wolfsonmicro.com>
In-Reply-To: <20120717133550.GC4477@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/07/12 14:35, Mark Brown wrote:
> On Tue, Jul 17, 2012 at 02:30:01PM +0100, Lee Jones wrote:
>> On 17/07/12 14:06, Mark Brown wrote:
>
>>> It's not just about having generic bindings, it's also about having
>>> bindings which have some abstraction and hope of reusability. An awful
>>> lot of bindings are just straight dumps of Linux data structures into
>>> the device tree which don't make a terribly great deal of sense as
>>> bindings.
>
>> The Device Tree should supply any platform configuration which the
>> driver needs in order to correctly setup for a particular machine.
>> This is exactly what the platform_data structure did before, hence
>> is is reasonable to assume that whatever information resides in that
>> structure would be required in the Device Tree.
>
> An *awful* lot of what people are trying to put into platform data is
> nothing to do with that, it's just the generic data the driver needs to
> be able to understand the hardware at all.  Things like the MFD
> breakdown, random parameters of the hardware which you can infer from
> the device name and so on.

I can only speak from a personal perspective on that one. I do _try_ not 
to put anything in there (platform data or Device Tree), which does not 
belong. I have no idea how successful that notion was however.

I'm sure sure this is relevant in the current case though, as the i2c 
properties proposed here are platform specific. What we're discussing is 
some consolidation of property names, which I do support in theory. What 
I fear is that this driver will lack Device Tree functionality for yet 
another kernel version if it isn't resolved quickly.

Wolfram, are you theorising about these the multiple use of these 
properties, or do you have some examples? I think we would do well to 
work on these, or else they're just going to lie dormant and not get done.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog



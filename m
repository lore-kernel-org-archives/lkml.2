Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab2GPNzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 09:55:46 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36173 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab2GPNzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 09:55:44 -0400
Message-ID: <50041D5C.7010904@linaro.org>
Date: Mon, 16 Jul 2012 14:55:40 +0100
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
References: <20120710164130.f38e4d1673f925ddb13914c9@canb.auug.org.au> <20120712131231.GH2194@pengutronix.de> <CACRpkdboeF_G=sTPeSyuZ6KGLCmGSKx_NS=6Rim6HkR2f9=AAQ@mail.gmail.com> <20120716101706.GB17435@pengutronix.de> <5003FB7C.4030509@linaro.org> <20120716130015.GF17435@pengutronix.de>
In-Reply-To: <20120716130015.GF17435@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/07/12 14:00, Wolfram Sang wrote:
>>> What I am afraid of is: tentative solutions tend to stay, because the
>>> need for a proper solution is reduced. Yet, finding proper generic
>>> bindings might take some time which doesn't meet the high pressure
>>> around DT at the moment.
>>
>> I agree with what you say to some extent, but I believe that it is
>> more important to have a working solution now than to ensure that
>> each bindings are as unique as possible. After any suggestion of
>> consolidation, a move from vendor specific to generically defined
>> Device Tree bindings is trivial. Especially in the current stage
>> where adaptions and definitions are still fluid.
>
> See my response to Linus. I do understand your view and where it comes
> from. As a maintainer, I have other priorities. No offence involved,
> it needs some settlement.

I'm certainly not adverse to doing this, although I'd prefer it was 
completed in the short-term. So should we do it?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog



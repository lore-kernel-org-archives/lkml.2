Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab2GEHQY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 03:16:24 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48861 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab2GEHQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 03:16:23 -0400
Message-ID: <4FF53F43.1040308@linaro.org>
Date: Thu, 05 Jul 2012 08:16:19 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Arnd Bergmann <arnd@arndb.de>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "lrg@ti.com" <lrg@ti.com>, Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH V3 2/3] regulator: dt: regulator match by regulator-compatible
References: <1340194987-23654-1-git-send-email-ldewangan@nvidia.com> <1340194987-23654-3-git-send-email-ldewangan@nvidia.com> <201206201924.09618.arnd@arndb.de> <20120620194609.GA4037@opensource.wolfsonmicro.com> <20120622061314.GA15627@avionic-0098.adnet.avionic-design.de> <20120622084228.GD4037@opensource.wolfsonmicro.com> <20120622085909.GA24121@avionic-0098.mockup.avionic-design.de> <20120622091238.GF4037@opensource.wolfsonmicro.com> <4FE97AA9.7060805@nvidia.com> <20120626091235.GJ30406@opensource.wolfsonmicro.com> <4FE98B4F.8000502@linaro.org> <CACRpkdaYG0tdxHHfQpbE_1=SZ9Grgj1-qvwYv=rxHV7nkLms4w@mail.gmail.com>
In-Reply-To: <CACRpkdaYG0tdxHHfQpbE_1=SZ9Grgj1-qvwYv=rxHV7nkLms4w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/12 00:48, Linus Walleij wrote:
> On Tue, Jun 26, 2012 at 12:13 PM, Lee Jones <lee.jones@linaro.org> wrote:
>> On 26/06/12 10:12, Mark Brown wrote:
>>>
>>> On Tue, Jun 26, 2012 at 02:32:33PM +0530, Laxman Dewangan wrote:
>>>
>>>> I have not seen much oppose on this series as such and if you are OK
>>>> on this then can we apply?
>>>> If it need to buy some ACK from different stack holder then we can ask
>>>> them.
>>>
>>>
>>> I've been waiting for the ST Ericsson guys who are already CCed.  I
>>> generally give people who I expect might review at least a week to do so
>>> before I get bored and apply anyway.
>>
>> You need Linus' ACK, but he is off until Monday.
>
> My ACK on this would be pointless since I barely grasp the issue.
>
> I would much more appreciate your ACK or NACK on it, it's much more
> valuable since you've been working on this code... and this very
> aspect of it even, I guess?

Very well. For the db8500.dtsi changes you have my:

Acked-by: Lee Jones <lee.jones@linaro.org>


-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog



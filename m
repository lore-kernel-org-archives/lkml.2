Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab2GDXsx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 19:48:53 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:33675 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972Ab2GDXsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 19:48:50 -0400
MIME-Version: 1.0
In-Reply-To: <4FE98B4F.8000502@linaro.org>
References: <1340194987-23654-1-git-send-email-ldewangan@nvidia.com>
	<1340194987-23654-3-git-send-email-ldewangan@nvidia.com>
	<201206201924.09618.arnd@arndb.de>
	<20120620194609.GA4037@opensource.wolfsonmicro.com>
	<20120622061314.GA15627@avionic-0098.adnet.avionic-design.de>
	<20120622084228.GD4037@opensource.wolfsonmicro.com>
	<20120622085909.GA24121@avionic-0098.mockup.avionic-design.de>
	<20120622091238.GF4037@opensource.wolfsonmicro.com>
	<4FE97AA9.7060805@nvidia.com>
	<20120626091235.GJ30406@opensource.wolfsonmicro.com>
	<4FE98B4F.8000502@linaro.org>
Date: Thu, 5 Jul 2012 01:48:49 +0200
Message-ID: <CACRpkdaYG0tdxHHfQpbE_1=SZ9Grgj1-qvwYv=rxHV7nkLms4w@mail.gmail.com>
Subject: Re: [PATCH V3 2/3] regulator: dt: regulator match by regulator-compatible
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Arnd Bergmann <arnd@arndb.de>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "lrg@ti.com" <lrg@ti.com>, Stephen Warren <swarren@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 12:13 PM, Lee Jones <lee.jones@linaro.org> wrote:
> On 26/06/12 10:12, Mark Brown wrote:
>>
>> On Tue, Jun 26, 2012 at 02:32:33PM +0530, Laxman Dewangan wrote:
>>
>>> I have not seen much oppose on this series as such and if you are OK
>>> on this then can we apply?
>>> If it need to buy some ACK from different stack holder then we can ask
>>> them.
>>
>>
>> I've been waiting for the ST Ericsson guys who are already CCed.  I
>> generally give people who I expect might review at least a week to do so
>> before I get bored and apply anyway.
>
> You need Linus' ACK, but he is off until Monday.

My ACK on this would be pointless since I barely grasp the issue.

I would much more appreciate your ACK or NACK on it, it's much more
valuable since you've been working on this code... and this very
aspect of it even, I guess?

Yours,
Linus Walleij

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768Ab2HGJca (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 05:32:30 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:51024 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab2HGJc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 05:32:28 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdY6gmyhjaMyjk4XP99rLb=B7jGpc2tpGcDh6O4UdgxXVg@mail.gmail.com>
References: <1341369105.10587.8.camel@phoenix>
	<20120704154821.GG4111@opensource.wolfsonmicro.com>
	<CAF+7xW=jtskjYqpqfAnnYmXRH5m944nDBhZQp7q8+EtEshJXBw@mail.gmail.com>
	<CACRpkdY6gmyhjaMyjk4XP99rLb=B7jGpc2tpGcDh6O4UdgxXVg@mail.gmail.com>
Date: Tue, 7 Aug 2012 11:32:27 +0200
Message-ID: <CACRpkdaAJ0XWUSbd2qXKg4DPU6U-0iOEDFqWpMBRT6DWwtncTg@mail.gmail.com>
Subject: Re: [PATCH RFT] regulator: ab8500: Set enable enable_time in regulator_desc
From: Linus Walleij <linus.walleij@linaro.org>
To: axel.lin@gmail.com
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Daniel WILLERUD <daniel.willerud@stericsson.com>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        Marcus COOPER <marcus.cooper@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 6, 2012 at 5:50 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Mon, Aug 6, 2012 at 5:46 PM, Axel Lin <axel.lin@gmail.com> wrote:
>> 2012/7/4 Mark Brown <broonie@opensource.wolfsonmicro.com>:
>>> On Wed, Jul 04, 2012 at 10:31:45AM +0800, Axel Lin wrote:
>>>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>>>> ---
>>>> Hi Linus,
>>>> While working on this patch, I found in original code:
>>>> ab8500_regulator_ops set enable_time callback to ab8500_regulator_enable_time,
>>>> but does not set the delay in ab8500_regulator_info.
>>>> I'm not sure the delay value is 0 for ab8500_regulator_ops, or the setting is
>>>> just missing.
>>>> Anyway, there is no behavior change by this patch.
>>>
>>> Surely if the delay is not set in info then it'll introduce a delay
>>> which wasn't there before (but which may well be a bug fix)?
>>
>> Ping...
>>
>> Hi Linus,
>> Any comments on this patch?
>
> Looks good to me:
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>
> I need to check the proper rise times with the maintainers.

I remember this now. Only that one regulator has a non-negligeble
rise time, so for that reason it's set to that value. Atleast so I was
told once upon a time when I implemented it, so this patch
should be fine.

Yours,
Linus Walleij

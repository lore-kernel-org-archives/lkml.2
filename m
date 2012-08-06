Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682Ab2HFPuN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 11:50:13 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:35490 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409Ab2HFPuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 11:50:11 -0400
MIME-Version: 1.0
In-Reply-To: <CAF+7xW=jtskjYqpqfAnnYmXRH5m944nDBhZQp7q8+EtEshJXBw@mail.gmail.com>
References: <1341369105.10587.8.camel@phoenix>
	<20120704154821.GG4111@opensource.wolfsonmicro.com>
	<CAF+7xW=jtskjYqpqfAnnYmXRH5m944nDBhZQp7q8+EtEshJXBw@mail.gmail.com>
Date: Mon, 6 Aug 2012 17:50:10 +0200
Message-ID: <CACRpkdY6gmyhjaMyjk4XP99rLb=B7jGpc2tpGcDh6O4UdgxXVg@mail.gmail.com>
Subject: Re: [PATCH RFT] regulator: ab8500: Set enable enable_time in regulator_desc
From: Linus Walleij <linus.walleij@linaro.org>
To: axel.lin@gmail.com
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Daniel WILLERUD <daniel.willerud@stericsson.com>,
        Mattias WALLIN <mattias.wallin@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 6, 2012 at 5:46 PM, Axel Lin <axel.lin@gmail.com> wrote:
> 2012/7/4 Mark Brown <broonie@opensource.wolfsonmicro.com>:
>> On Wed, Jul 04, 2012 at 10:31:45AM +0800, Axel Lin wrote:
>>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>>> ---
>>> Hi Linus,
>>> While working on this patch, I found in original code:
>>> ab8500_regulator_ops set enable_time callback to ab8500_regulator_enable_time,
>>> but does not set the delay in ab8500_regulator_info.
>>> I'm not sure the delay value is 0 for ab8500_regulator_ops, or the setting is
>>> just missing.
>>> Anyway, there is no behavior change by this patch.
>>
>> Surely if the delay is not set in info then it'll introduce a delay
>> which wasn't there before (but which may well be a bug fix)?
>
> Ping...
>
> Hi Linus,
> Any comments on this patch?

Looks good to me:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

I need to check the proper rise times with the maintainers.

Yours,
Linus Walleij

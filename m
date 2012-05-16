Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966933Ab2EPKPm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 06:15:42 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:48701 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966231Ab2EPKPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 06:15:40 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdb9LbjvobsJf61VA1Nt8-UCwDZzmjqC8JuN8WPdvhq+iQ@mail.gmail.com>
References: <20120515154333.6659.66479.sendpatchset@w520>
	<CACRpkdb9LbjvobsJf61VA1Nt8-UCwDZzmjqC8JuN8WPdvhq+iQ@mail.gmail.com>
Date: Wed, 16 May 2012 19:15:39 +0900
Message-ID: <CANqRtoTCo_Vwe8OMS2ovHNimoe_4ZnCEHk5TQ4YPq8oPJXMObg@mail.gmail.com>
Subject: Re: [PATCH] gpio: Emma Mobile GPIO driver V2
From: Magnus Damm <magnus.damm@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, rjw@sisk.pl, linus.walleij@stericsson.com,
        arnd@arndb.de, linux-sh@vger.kernel.org, horms@verge.net.au,
        grant.likely@secretlab.ca, lethal@linux-sh.org, olof@lixom.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 4:11 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Tue, May 15, 2012 at 5:43 PM, Magnus Damm <magnus.damm@gmail.com> wrote:
>
>> From: Magnus Damm <damm@opensource.se>
>>
>> This patch is V2 of the Emma Mobile GPIO driver. This
>> driver is designed to be reusable between multiple SoCs
>> that share the same basic building block, but so far it
>> has only been used on Emma Mobile EV2.
>>
>> Each driver instance handles 32 GPIOs with individually
>> maskable IRQs. The driver operates on two I/O memory
>> ranges and the 32 GPIOs are hooked up to two interrupts.
>>
>> In the case of Emma Mobile EV2 this GPIO building block
>> is used as main external interrupt controller hooking up
>> 159 GPIOS as 159 interrupts via 5 driver instances and
>> 10 interrupts to the GIC and the Cortex-A9 Dual.
>>
>> Signed-off-by: Magnus Damm <damm@opensource.se>
>
> V2 is fair enough for me, so feel free to add:
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thank you! Do you guys have any preferences how to merge this?

Can I include it together with the EMEV2 SoC bits perhaps? That may be
easy so we can keep track of the platform data header file dependency.

Cheers,

/ magnus

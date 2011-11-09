Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab1KIOLj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 09:11:39 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49236 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab1KIOLi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 09:11:38 -0500
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF173F9A5023@HQMAIL01.nvidia.com>
References: <1320675304-1857-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF173F9A5023@HQMAIL01.nvidia.com>
Date: Wed, 9 Nov 2011 15:11:37 +0100
Message-ID: <CACRpkdZqdgSc6FCoLT8iwzVVYuFw_t8bF=a2hCZFQCLw5zwqkQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: hide subsystem from the populace
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 7, 2011 at 5:23 PM, Stephen Warren <swarren@nvidia.com> wrote:
> Linus Walleij wrote at Monday, November 07, 2011 7:15 AM:

>>  if PINCTRL
>>
>> +menu "Pin controllers"
>> +     depends on PINCTRL
>> +
>>  config PINMUX
>>       bool "Support pinmux controllers"
>>       help
>
> But shouldn't PINMUX and PINMUX_${soc} also have their help text removed;
> it seems like if a SoC selects PINCTRL, it would also select PINMUX if
> appropriate, and the relevant PINMUX_${soc} too?

Yep, you're absolutely right, let's cut the crap.

> I assume there are also patches for arch/arm/mach-${foo}/Kconfig somewhere
> to select PINCTRL when appropriate; they didn't show up in my inbox, but
> I haven't checked my sub-folders yet, so perhaps they're already there.

The U300 one is already in arch/arm/mach-u300/Kconfig

The SirfPrimaII will be part of that platform (still out-of-tree).
They have to start somewhere ... those guys need pinmux to even
get the UART working.

Thanks,
Linus Walleij

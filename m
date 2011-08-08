Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab1HHSZM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 14:25:12 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51576 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076Ab1HHSZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 14:25:11 -0400
MIME-Version: 1.0
In-Reply-To: <20110808081552.GI32513@linux-sh.org>
References: <1312780773-23142-1-git-send-email-Baohua.Song@csr.com> <20110808081552.GI32513@linux-sh.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 8 Aug 2011 12:24:50 -0600
X-Google-Sender-Auth: LyABVmyxuGbfh76F3Fw6nXA1fuY
Message-ID: <CACxGe6ssT4=kxApaKhv+=7nDcEFVW+oyByFQ_hzcfyZ4gw2C3g@mail.gmail.com>
Subject: Re: [PATCH] GPIOLIB: add generic gpio_set_pull API
To: Paul Mundt <lethal@linux-sh.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Cc: Barry Song <Baohua.Song@csr.com>, workgroup.linux@csr.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 8, 2011 at 2:15 AM, Paul Mundt <lethal@linux-sh.org> wrote:
> On Sun, Aug 07, 2011 at 10:19:33PM -0700, Barry Song wrote:
>> Now there are many different implementations for GPIO pull configuration, for
>> example:
>> s3c_gpio_setpull()
>> tegra_pinmux_set_pullupdown()
>> chipcHw_setPinPullup()
>> gpio_pullup()
>> s3c2410_gpio_pullup()
>>
>> This patch adds a new generic gpio_set_pull API so that all SoCs can have unified
>> codes.
>>
>> Signed-off-by: Barry Song <Baohua.Song@csr.com>
>
> For arch/arm/mach-shmobile we also have gpio_pull_up() for board-g4evm.c
> and gpio_pull_down() for board-mackerel.c. Both of these would benefit
> from this sort of an API addition.

I think I'm okay with this API change.  Linus, what say you?  How does
this interact with your plans for pinctrl?

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab1GKE4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 00:56:37 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51128 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab1GKE4g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 00:56:36 -0400
MIME-Version: 1.0
In-Reply-To: <201107110030.06399.vapier@gentoo.org>
References: <20110711025344.GA27497@opensource.wolfsonmicro.com>
 <20110711035732.GA5040@opensource.wolfsonmicro.com> <201107110030.06399.vapier@gentoo.org>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 11 Jul 2011 12:56:14 +0800
Message-ID: <CAGsJ_4x_e0OR8dV=n-zodi8Sr4SZkU6o6gJK13UpZrgTzZQvbQ@mail.gmail.com>
Subject: Re: [PATCH 0/6] clk: Initial feedback for off-SoC slow bus clocks
To: Mike Frysinger <vapier@gentoo.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Grant Likely <grant@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>, linux-sh@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel@lists.infradead.org,
        uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/11 Mike Frysinger <vapier@gentoo.org>:
> On Sunday, July 10, 2011 23:57:40 Mark Brown wrote:
>> On Mon, Jul 11, 2011 at 11:53:44AM +0900, Mark Brown wrote:
>>
>> Linus, CCing you in as apparently you're taking over the clock API work.
>> Do you need me to forward all the patches to you?
>
> along these lines, i dont think the new people on the cc noticed my earlier e-
> mail:
> for future series, could you cc uclinux-dist-devel@blackfin.uclinux.org ?  we
> dont do clock management on Blackfin parts atm, but it's something we would
> like to start doing.  our hardware can easily benefit from this.

Except that, AFAIK, arch/blackfin/mach-xxx is much similar with
arch/arm/mach-xxx with a lot of platform, i2c, spi board information.
it is probably we can also benefit from device tree as what ARM is
doing.
but not sure whether it is really worthwhile for the current situation
and long term plan of blackfin. Anyway, there are not so many blackfin
SoC and boards as ARM.

> -mike
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab1GKFCT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 01:02:19 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58779 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783Ab1GKFCR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 01:02:17 -0400
MIME-Version: 1.0
In-Reply-To: <CAGsJ_4x_e0OR8dV=n-zodi8Sr4SZkU6o6gJK13UpZrgTzZQvbQ@mail.gmail.com>
References: <20110711025344.GA27497@opensource.wolfsonmicro.com>
 <20110711035732.GA5040@opensource.wolfsonmicro.com> <201107110030.06399.vapier@gentoo.org>
 <CAGsJ_4x_e0OR8dV=n-zodi8Sr4SZkU6o6gJK13UpZrgTzZQvbQ@mail.gmail.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Mon, 11 Jul 2011 01:01:56 -0400
X-Google-Sender-Auth: 3od6Fh1n9AUrTx6096GxWyJUkqo
Message-ID: <CAMjpGUc51mg1vnj2PDk-=u=s7b0j0Qqm4nXLbugM5QsbshOZpg@mail.gmail.com>
Subject: Re: [uclinux-dist-devel] [PATCH 0/6] clk: Initial feedback for
 off-SoC slow bus clocks
To: Barry Song <21cnbao@gmail.com>
Cc: Grant Likely <grant@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>, linux-sh@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 00:56, Barry Song wrote:
> 2011/7/11 Mike Frysinger:
>> On Sunday, July 10, 2011 23:57:40 Mark Brown wrote:
>>> On Mon, Jul 11, 2011 at 11:53:44AM +0900, Mark Brown wrote:
>>> Linus, CCing you in as apparently you're taking over the clock API work.
>>> Do you need me to forward all the patches to you?
>>
>> along these lines, i dont think the new people on the cc noticed my earlier e-
>> mail:
>> for future series, could you cc uclinux-dist-devel@blackfin.uclinux.org ?  we
>> dont do clock management on Blackfin parts atm, but it's something we would
>> like to start doing.  our hardware can easily benefit from this.
>
> Except that, AFAIK, arch/blackfin/mach-xxx is much similar with
> arch/arm/mach-xxx with a lot of platform, i2c, spi board information.
> it is probably we can also benefit from device tree as what ARM is
> doing.

i dont think device trees are a requirement for the clock api

> but not sure whether it is really worthwhile for the current situation
> and long term plan of blackfin. Anyway, there are not so many blackfin
> SoC and boards as ARM.

there are not plans for device tree support.  no customers have asked
for it, and we arent in the arm situation where we have a distro (like
Ubuntu) riding us to have a single build boot on all the different
platforms.
-mike

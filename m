Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689Ab2KLLxw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 06:53:52 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61230 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab2KLLxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 06:53:49 -0500
MIME-Version: 1.0
In-Reply-To: <20121105214753.GB1254@beefymiracle.amer.corp.natinst.com>
References: <cover.1351721190.git.josh.cartwright@ni.com>
	<c0347788fbad559a249a25128a23f40c85d9cbda.1351721190.git.josh.cartwright@ni.com>
	<CAHTX3d++0fGSw7GQHcc-S1X1Qh-rfekpr-E8Jkg2_vFqdCFFTg@mail.gmail.com>
	<20121105214753.GB1254@beefymiracle.amer.corp.natinst.com>
Date: Mon, 12 Nov 2012 12:53:47 +0100
X-Google-Sender-Auth: pjktv39mIg6EnqB0Rg8QTieUOaQ
Message-ID: <CAHTX3dKYJ_rWy-bWdhz24R=0ksw9YDixtqpJfEwRGcffu6vwkA@mail.gmail.com>
Subject: Re: [PATCH 2/8] ARM: zynq: move ttc timer code to drivers/clocksource
From: Michal Simek <michal.simek@xilinx.com>
To: Josh Cartwright <josh.cartwright@ni.com>
Cc: Russell King <linux@arm.linux.org.uk>, John Stultz <johnstul@us.ibm.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Alan Cox <alan@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/5 Josh Cartwright <josh.cartwright@ni.com>:
> On Mon, Nov 05, 2012 at 12:22:55PM +0100, Michal Simek wrote:
>> 2012/10/29 Josh Cartwright <josh.cartwright@ni.com>:
>> > Suggested cleanup by Arnd Bergmann.  Move the ttc timer.c code to
>> > drivers/clocksource, and out of the mach-zynq directory.
>> >
>> > The common.h (which only held the timer declaration) was renamed to
>> > xilinx_ttc.h and moved into include/linux.
>> >
>> > Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
>> > Cc: Arnd Bergmann <arnd@arndb.de>
>> > ---
>> >  arch/arm/mach-zynq/Makefile                                    | 2 +-
>> >  arch/arm/mach-zynq/common.c                                    | 2 +-
>> >  drivers/clocksource/Makefile                                   | 1 +
>> >  arch/arm/mach-zynq/timer.c => drivers/clocksource/xilinx_ttc.c | 1 -
>> >  arch/arm/mach-zynq/common.h => include/linux/xilinx_ttc.h      | 4 ++--
>> >  5 files changed, 5 insertions(+), 5 deletions(-)
>> >  rename arch/arm/mach-zynq/timer.c => drivers/clocksource/xilinx_ttc.c (99%)
>> >  rename arch/arm/mach-zynq/common.h => include/linux/xilinx_ttc.h (91%)
>>
>> Not going to apply this patch till there is clean way how to move all
>> drivers there.  Especially I don't like to add xilinx_ttc.h to
>> include/linux folder.
>
> Okay;  I think it's best to defer the moving of the ttc driver from this
> patchset.  It is not a dependency of the clk driver support stuff.
> If you agree, I can spin up a v2 of the patchset w/o this change, and
> without the serial CONFIG_OF stuff.  Should v2 contain the patches
> you've already pulled into testing?

Sure and I see you have done which is good.

Thanks,
Michal

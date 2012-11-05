Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658Ab2KELW6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 06:22:58 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:55800 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab2KELW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 06:22:56 -0500
MIME-Version: 1.0
In-Reply-To: <c0347788fbad559a249a25128a23f40c85d9cbda.1351721190.git.josh.cartwright@ni.com>
References: <cover.1351721190.git.josh.cartwright@ni.com>
	<c0347788fbad559a249a25128a23f40c85d9cbda.1351721190.git.josh.cartwright@ni.com>
Date: Mon, 5 Nov 2012 12:22:55 +0100
X-Google-Sender-Auth: q57wHwVN0C5ByRJSNDLSkUmhAzg
Message-ID: <CAHTX3d++0fGSw7GQHcc-S1X1Qh-rfekpr-E8Jkg2_vFqdCFFTg@mail.gmail.com>
Subject: Re: [PATCH 2/8] ARM: zynq: move ttc timer code to drivers/clocksource
From: Michal Simek <michal.simek@xilinx.com>
To: Josh Cartwright <josh.cartwright@ni.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@ti.com>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Linn <John.Linn@xilinx.com>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/29 Josh Cartwright <josh.cartwright@ni.com>:
> Suggested cleanup by Arnd Bergmann.  Move the ttc timer.c code to
> drivers/clocksource, and out of the mach-zynq directory.
>
> The common.h (which only held the timer declaration) was renamed to
> xilinx_ttc.h and moved into include/linux.
>
> Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/arm/mach-zynq/Makefile                                    | 2 +-
>  arch/arm/mach-zynq/common.c                                    | 2 +-
>  drivers/clocksource/Makefile                                   | 1 +
>  arch/arm/mach-zynq/timer.c => drivers/clocksource/xilinx_ttc.c | 1 -
>  arch/arm/mach-zynq/common.h => include/linux/xilinx_ttc.h      | 4 ++--
>  5 files changed, 5 insertions(+), 5 deletions(-)
>  rename arch/arm/mach-zynq/timer.c => drivers/clocksource/xilinx_ttc.c (99%)
>  rename arch/arm/mach-zynq/common.h => include/linux/xilinx_ttc.h (91%)

Not going to apply this patch till there is clean way how to move all
drivers there.
Especially I don't like to add xilinx_ttc.h to include/linux folder.

Thanks,
Michal

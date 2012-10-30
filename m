Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933009Ab2J3LgL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 07:36:11 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60626 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932770Ab2J3LgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 07:36:09 -0400
Message-ID: <508FBBA5.2080707@monstr.eu>
Date: Tue, 30 Oct 2012 12:36:05 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Josh Cartwright <josh.cartwright@ni.com>
CC: Michal Simek <michal.simek@xilinx.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] ARM: zynq: move ttc timer code to drivers/clocksource
References: <20121029185630.GA26149@beefymiracle.amer.corp.natinst.com>
In-Reply-To: <20121029185630.GA26149@beefymiracle.amer.corp.natinst.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2012 07:56 PM, Josh Cartwright wrote:
> Suggested cleanup by Arnd Bergmann.  Move the ttc timer.c code to
> drivers/clocksource, and out of the mach-zynq directory.
>
> The common.h (which only held the timer declaration) was renamed to
> xilinx_ttc.h and moved into include/linux.
>
> Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> ---
>   arch/arm/mach-zynq/Makefile      |   2 +-
>   arch/arm/mach-zynq/common.c      |   2 +-
>   arch/arm/mach-zynq/common.h      |  24 ----
>   arch/arm/mach-zynq/timer.c       | 298 ---------------------------------------
>   drivers/clocksource/Makefile     |   1 +
>   drivers/clocksource/xilinx_ttc.c | 297 ++++++++++++++++++++++++++++++++++++++
>   include/linux/xilinx_ttc.h       |  24 ++++
>   7 files changed, 324 insertions(+), 324 deletions(-)
>   delete mode 100644 arch/arm/mach-zynq/common.h
>   delete mode 100644 arch/arm/mach-zynq/timer.c
>   create mode 100644 drivers/clocksource/xilinx_ttc.c
>   create mode 100644 include/linux/xilinx_ttc.h

Really?
If yes. shouldn't be there any better naming convention
especially for headers. linux/clocksource/xilinx_ttc.h.

Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian

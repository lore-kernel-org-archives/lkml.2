Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab2KELU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 06:20:26 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38256 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab2KELUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 06:20:19 -0500
MIME-Version: 1.0
In-Reply-To: <3ec3531d21c247ac3dcc76d91ff6be13ebfc733b.1351721190.git.josh.cartwright@ni.com>
References: <cover.1351721190.git.josh.cartwright@ni.com>
	<3ec3531d21c247ac3dcc76d91ff6be13ebfc733b.1351721190.git.josh.cartwright@ni.com>
Date: Mon, 5 Nov 2012 12:20:16 +0100
X-Google-Sender-Auth: yyzjb7I3wILPUPAry94evq9dgDo
Message-ID: <CAHTX3d+H7QOUgk8HxekEHd-=XV4k=pTbMcC_cAxkhj1z0s+TWg@mail.gmail.com>
Subject: Re: [PATCH 1/8] ARM: zynq: move arm-specific sys_timer out of ttc
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

2012/10/31 Josh Cartwright <josh.cartwright@ni.com>:
> Move the sys_timer definition out of ttc driver and make it part of the
> common zynq code.  This is preparation for renaming and COMMON_CLK
> support.
>
> Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
> ---
>  arch/arm/mach-zynq/common.c | 13 +++++++++++++
>  arch/arm/mach-zynq/common.h |  4 +---
>  arch/arm/mach-zynq/timer.c  | 10 +---------
>  3 files changed, 15 insertions(+), 12 deletions(-)
>

Tested-by: Michal Simek <michal.simek@xilinx.com>

Looks good to me. I have added it to my testing branch
and will provide path to mainline through xilinx arm-next branch

Thanks,
Michal

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289Ab1DHRgt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 13:36:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:17148 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756880Ab1DHRgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 13:36:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,324,1299484800"; 
   d="scan'208";a="730906941"
Date: Fri, 8 Apr 2011 10:36:46 -0700
From: jacob pan <jacob.jun.pan@linux.intel.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com, tglx@linutronix.de
Subject: Re: [PATCHv2 0/2] Permit reuse of APB timers on other platforms
Message-ID: <20110408103646.4f45d42f@jacob-laptop>
In-Reply-To: <1302273218-7263-1-git-send-email-jamie@jamieiles.com>
References: <1302273218-7263-1-git-send-email-jamie@jamieiles.com>
Organization: OTC
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  8 Apr 2011 15:33:36 +0100
Jamie Iles <jamie@jamieiles.com> wrote:

> This patch series splits out the DesignWare APB timer handling into
> clocksource and clockevent drivers then allows different platforms to
> reuse them.  The Synopsys timers can be found in x86, ARM and
> potentially other architectures.
> 
> Here's the updated patch series which Jacob has had running on his x86
> platform and I have working on a currently out-of-tree ARM platform.
> 
> Many thanks to Jacob for the testing (and fixing) to get this running
> on x86.
> 
> Jamie Iles (2):
>   x86, mrst: share APB timer code with other platforms
>   clocksource: platform driver for APB timers
> 
>  arch/x86/Kconfig                            |    1 +
>  arch/x86/include/asm/apb_timer.h            |   22 +--
>  arch/x86/kernel/apb_timer.c                 |  421
> +++++----------------------
> drivers/Kconfig                             |    2 +
> drivers/clocksource/Kconfig                 |   11 +
> drivers/clocksource/Makefile                |    2 +
> drivers/clocksource/dw_apb_timer.c          |  322
> ++++++++++++++++++++ drivers/clocksource/dw_apb_timer_platform.c |
> 173 +++++++++++ include/linux/dw_apb_timer.h                |  129
> ++++++++ 9 files changed, 714 insertions(+), 369 deletions(-) create
> mode 100644 drivers/clocksource/Kconfig create mode 100644
> drivers/clocksource/dw_apb_timer.c create mode 100644
> drivers/clocksource/dw_apb_timer_platform.c create mode 100644
> include/linux/dw_apb_timer.h
> 

Hi Jamie,

Which tree are your patches based on? I failed to apply them on
both mainline and tip tree.
There has been some recent changes in arch/x86/kernel/apb_timer.c
I have resolved conflict and sending you updated patch separately.

Please check,

-- 
Thanks

Jacob
(from Linux laptop)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758383Ab1CaPdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 11:33:18 -0400
Received: from www.linutronix.de ([62.245.132.108]:37995 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758320Ab1CaPdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 11:33:17 -0400
Date: Thu, 31 Mar 2011 17:33:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jamie Iles <jamie@jamieiles.com>
cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] clocksource: clocksource/clockevent driver for Synopsys
 dw_apb_timer
In-Reply-To: <1301584372-26261-1-git-send-email-jamie@jamieiles.com>
Message-ID: <alpine.LFD.2.00.1103311719420.22418@localhost6.localdomain6>
References: <1301584372-26261-1-git-send-email-jamie@jamieiles.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Mar 2011, Jamie Iles wrote:

> This patch adds a driver for the Synopsys DesignWare APB timer block
> found in some ARM systems.  This uses the timers with an IRQ as a
> clockevents device and a timer without an IRQ as a clocksource
> device.

Interesting. That's probably the same thing as:

     arch/x86/kernel/apb_timer.c

So if we merge that thing, then we should make sure, that we can
replace the x86 one with it.

Thanks,

	tglx

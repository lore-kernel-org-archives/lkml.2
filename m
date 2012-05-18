Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946918Ab2ERXOw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:14:52 -0400
Received: from linux-sh.org ([111.68.239.195]:40442 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946677Ab2ERXOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:14:49 -0400
Date: Sat, 19 May 2012 08:14:32 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Anna-Maria Gleixner <anna-maria@glx-um.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 01/24] timers: Provide generic Kconfig switches
Message-ID: <20120518231432.GH24355@linux-sh.org>
References: <20120518163020.548627576@glx-um.de>
 <20120518163104.499615021@glx-um.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120518163104.499615021@glx-um.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 04:45:43PM -0000, Anna-Maria Gleixner wrote:
> +# Options selectable by arch Kconfig
> +
> +# Watchdog function for clocksources to detect instabilities
> +config CLOCKSOURCE_WATCHDOG
> +	bool
> +
> +# Architecture has extra clocksource data
> +config ARCH_CLOCKSOURCE_DATA
> +	bool
> +
> +# Timekeeping vsyscall support
> +config GENERIC_TIME_VSYSCALL
> +	bool
> +
> +# ktime_t scalar 64bit nsec representation
> +config KTIME_SCALAR
> +	bool
> +
> +# Old style timekeeping
> +config ARCH_USES_GETTIMEOFFSET
> +	bool
> +
> +# The generic clock events infrastructure
> +config GENERIC_CLOCKEVENTS
> +	bool
> +
> +# Clockevents broadcasting infrastructure
> +config GENERIC_CLOCKEVENTS_BROADCAST
> +	bool
> +	depends on GENERIC_CLOCKEVENTS
> 
Looks like you've missed GENERIC_CMOS_UPDATE.

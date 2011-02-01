Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab1BAUiB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 15:38:01 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:38971 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966Ab1BAUiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 15:38:00 -0500
Subject: Re: [patch 05/28] posix-timers: Introduce clockid_to_kclock()
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20110201134417.938447839@linutronix.de>
References: <20110201134320.688829863@linutronix.de>
	 <20110201134417.938447839@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 12:37:54 -0800
Message-ID: <1296592674.3336.22.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 13:51 +0000, Thomas Gleixner wrote:
> plain text document attachment
> (posix-timers-introduce-clockid-to-kclock.patch)
> New function to find the kclock for a given clockid.
> 
> Returns a pointer to clock_posix_cpu if clockid < 0. If clockid >=
> MAXCLOCK or if the clock_getres pointer is not set it returns
> -EINVAL. For valid clocks it returns a pointer to the matching
> posix_clock.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Richard Cochran <richard.cochran@omicron.at>

Acked-by: John Stultz <johnstul@us.ibm.com>



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802Ab1BAVOt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 16:14:49 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:40936 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab1BAVOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 16:14:49 -0500
Subject: Re: [patch 10/28] posix-cpu-timers: Remove the stub nanosleep
 functions
From: John Stultz <john.stultz@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20110201134418.422446502@linutronix.de>
References: <20110201134320.688829863@linutronix.de>
	 <20110201134418.422446502@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 13:14:38 -0800
Message-ID: <1296594878.3336.53.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 13:51 +0000, Thomas Gleixner wrote:
> plain text document attachment
> (posix-cpu-timers-use-default-nsleep-notsup.patch)
> CLOCK_THREAD_CPUTIME_ID implements stub functions for nanosleep and
> nanosleep_restart, which return -EINVAL. That return value is
> wrong. The correct return value is -ENOTSUP.
> 
> Remove the stubs and let the new dispatch code return the correct
> error code.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Richard Cochran <richard.cochran@omicron.at>
> ---

Acked-by: John Stultz <johnstul@us.ibm.com>



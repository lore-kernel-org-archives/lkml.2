Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488Ab1BAVjD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 16:39:03 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:59924 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab1BAVjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 16:39:01 -0500
Subject: Re: [patch 27/28] posix-timers: Add support for fd based clocks
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20110201134420.062860200@linutronix.de>
References: <20110201134320.688829863@linutronix.de>
	 <20110201134420.062860200@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 13:38:55 -0800
Message-ID: <1296596335.3336.75.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 13:52 +0000, Thomas Gleixner wrote:
> plain text document attachment
> (posix-timers-add-support-for-fd-based-clocks.patch)
> From: Richard Cochran <richard.cochran@omicron.at>
> 
> Extend the negative clockids which are currently used by posix cpu
> timers to encode the PID with a file descriptor based type which
> encodes the fd in the upper bits.
> 
> Originally-from: Richard Cochran <richard.cochran@omicron.at>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: John Stultz <john.stultz@linaro.org>

Acked-by: John Stultz <johnstul@us.ibm.com>



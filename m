Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253Ab1BAVfQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 16:35:16 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:47416 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab1BAVfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 16:35:15 -0500
Subject: Re: [patch 25/28] posix clocks: Introduce a syscall for clock
 tuning.
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Lameter <cl@linux.com>, David Miller <davem@davemloft.net>,
        Krzysztof Halasa <khc@pm.waw.pl>, Rodolfo Giometti <giometti@linux.it>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Mike Frysinger <vapier@gentoo.org>, Paul Mackerras <paulus@samba.org>,
        Russell King <linux@arm.linux.org.uk>
In-Reply-To: <20110201134419.869804645@linutronix.de>
References: <20110201134320.688829863@linutronix.de>
	 <20110201134419.869804645@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 13:35:03 -0800
Message-ID: <1296596103.3336.72.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 13:52 +0000, Thomas Gleixner wrote:
> plain text document attachment
> (posix-clocks-introduce-a-syscall-for-clock-tuning.patch)
> From: Richard Cochran <richardcochran@gmail.com>
> 
> A new syscall is introduced that allows tuning of a POSIX clock. The
> new call, clock_adjtime, takes two parameters, the clock ID and a
> pointer to a struct timex. Any ADJTIMEX(2) operation may be requested
> via this system call, but various POSIX clocks may or may not support
> tuning.
> 
> [ tglx: Adapted to the posix-timer cleanup series. Avoid copy_to_user
>   	in the error case ]

Acked-by: John Stultz <johnstul@us.ibm.com>




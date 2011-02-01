Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab1BAVSB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 16:18:01 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:48424 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab1BAVR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 16:17:59 -0500
Subject: Re: [patch 13/28] posix-timers: Convert clock_getres() to
 clockid_to_kclock()
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20110201134418.709802797@linutronix.de>
References: <20110201134320.688829863@linutronix.de>
	 <20110201134418.709802797@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 13:17:53 -0800
Message-ID: <1296595073.3336.56.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 13:51 +0000, Thomas Gleixner wrote:
> plain text document attachment
> (posix-timers-convert-clock-getres.patch)
> Use the new kclock decoding. Fixup the fallout in mmtimer.c
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Richard Cochran <richard.cochran@omicron.at>

Acked-by: John Stultz <johnstul@us.ibm.com>



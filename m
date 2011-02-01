Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab1BAVPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 16:15:35 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:47785 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab1BAVPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 16:15:34 -0500
Subject: Re: [patch 11/28] posix-timers: Convert clock_settime to
 clockid_to_kclock()
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20110201134418.518851246@linutronix.de>
References: <20110201134320.688829863@linutronix.de>
	 <20110201134418.518851246@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 13:15:25 -0800
Message-ID: <1296594925.3336.54.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 13:51 +0000, Thomas Gleixner wrote:
> plain text document attachment (posix-timers-convert-clock-set.patch)
> Use the new kclock decoding function in clock_settime and cleanup all
> kclocks which use the default functions. Rename the misnomed
> common_clock_set() to posix_clock_realtime_set().
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Richard Cochran <richard.cochran@omicron.at>

Acked-by: John Stultz <johnstul@us.ibm.com>



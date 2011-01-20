Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab1ATTNC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 14:13:02 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:60395 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807Ab1ATTNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 14:13:01 -0500
Subject: Re: [PATCH 3/5] RTC: Rework RTC code to use timerlist for events
From: John Stultz <john.stultz@linaro.org>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>
In-Reply-To: <m2hbd378jt.fsf@igel.home>
References: <1290136329-18291-1-git-send-email-john.stultz@linaro.org>
	 <1290136329-18291-4-git-send-email-john.stultz@linaro.org>
	 <m2hbd378jt.fsf@igel.home>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Jan 2011 11:12:54 -0800
Message-ID: <1295550774.2998.58.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-20 at 19:07 +0100, Andreas Schwab wrote:
> John Stultz <john.stultz@linaro.org> writes:
> 
> > This patch reworks a large portion of the generic RTC code
> > to in-effect virtualize the rtc interrupt code.
> 
> That breaks RTC on powermac which uses rtc-generic.
> 
> # hwclock 
> select() to /dev/rtc0 to wait for clock tick timed out

Actually, can you also send strace output?

thanks
-john



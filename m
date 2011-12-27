Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489Ab1L0HZb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 02:25:31 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44853 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748Ab1L0HZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 02:25:24 -0500
Date: Tue, 27 Dec 2011 08:25:11 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-kernel@vger.kernel.org, Kumar Sundararajan <kumar@fb.com>,
        john stultz <johnstul@us.ibm.com>, Arun Sharma <asharma@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/4] Add clock_gettime_ns syscall
Message-ID: <20111227072511.GA2250@netboy.at.omicron.at>
References: <cover.1324831829.git.luto@amacapital.net>
 <16ecaa6abb8b7a25ef31970f71a42c7e2ba5416c.1324831829.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16ecaa6abb8b7a25ef31970f71a42c7e2ba5416c.1324831829.git.luto@amacapital.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 25, 2011 at 08:51:00AM -0800, Andy Lutomirski wrote:
> 
> This interface intentionally does not support sub-nanosecond
> precision.  For one thing, light only travels about a foot per
> nanosecond, so nanoseconds are really pretty good for networking
> purposes.  For another, 2^64 picoseconds (say) is a short enough
> interval to be inconvenient.  If anyone needs sub-nanosecond
> precision for anything other than profiling, they're welcome to
> figure out an appropriate interface.  For very precise profiling,
> "what time is it" is the wrong question, anyway -- modern CPUs can
> reorder things across time scales much longer than a nanosecond.

This paragraph probably should be updated, since you did add a padding
field for future sub-nanosecond reporting.

Also, on re-reading this, it seems silly to be to introduce a function
called "clock_gettime_ns" and then to say that this function cannot
answer the question, what time is it?

If the interface is a profiling only interface, then the name should
reflect this fact.

Thanks,
Richard

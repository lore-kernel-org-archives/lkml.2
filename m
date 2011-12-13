Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab1LMDYN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 22:24:13 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35190 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043Ab1LMDYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 22:24:12 -0500
Date: Tue, 13 Dec 2011 04:24:07 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-kernel@vger.kernel.org, Kumar Sundararajan <kumar@fb.com>,
        john stultz <johnstul@us.ibm.com>, Arun Sharma <asharma@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC 0/2] ABI for clock_gettime_ns
Message-ID: <20111213032406.GA9604@netboy.at.omicron.at>
References: <cover.1323739287.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1323739287.git.luto@amacapital.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 05:26:36PM -0800, Andy Lutomirski wrote:
> On x86-64, clock_gettime is so fast that the overhead converting to and
> from nanoseconds is non-negligible.  clock_gettime_ns is a different
> interface that is potentially faster.  If people like the ABI, I'll
> implement an optimized version.

I am not so interested in performance optimizations, but do I think
offering time in nanoseconds is attractive from an application point
of view. The timespec is impractical for everyone.

While you are at it with new syscalls, why not make a clean break from
POSIX and fix the uglies?

- New name, to distance ourselves from POSIX (clock_ns_get?)
- Family of calls, with set/get
- Sub nanosecond field
- TAI time base (or according to parameter?)

Thanks,
Richard

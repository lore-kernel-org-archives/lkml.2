Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab1LXF72 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Dec 2011 00:59:28 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36172 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab1LXF70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Dec 2011 00:59:26 -0500
MIME-Version: 1.0
In-Reply-To: <20111222120326.GA3360@cherladcori01>
References: <cover.1323739287.git.luto@amacapital.net> <20111213032406.GA9604@netboy.at.omicron.at>
 <1323747782.4078.144.camel@work-vm> <CALCETrV8MWwv5ei=4FirhEMyKR5A6hkq4sGSmFqo=mCgopdgXg@mail.gmail.com>
 <20111214074640.GB2180@netboy.at.omicron.at> <1323881310.6805.41.camel@work-vm>
 <20111214183025.GB2465@netboy.at.omicron.at> <1323889666.6805.71.camel@work-vm>
 <20111222120326.GA3360@cherladcori01>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 23 Dec 2011 21:59:04 -0800
Message-ID: <CALCETrUFLu1ekyaJFve4zARER7od-RyVy-JM+VsBBMgxvAFyoQ@mail.gmail.com>
Subject: Re: [RFC 0/2] ABI for clock_gettime_ns
To: Richard Cochran <richardcochran@gmail.com>
Cc: john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
        Kumar Sundararajan <kumar@fb.com>, Arun Sharma <asharma@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 4:03 AM, Richard Cochran
<richardcochran@gmail.com> wrote:
> On Wed, Dec 14, 2011 at 11:07:46AM -0800, john stultz wrote:
>> Maybe I'm still not understanding, but that seems more limited then what
>> is being proposed, at least in my mind. clock_gettime_ns() would still
>> take a clockid, so having a CLOCK_TAI would be a potential change in the
>> future.
>
> POSIX got the clock_gettime interface wrong, because you cannot tell
> the time with it. The POSIX interface will return the same time value
> for two consecutive seconds, due to leap seconds.
>
> IMHO, new interfaces should correct this mistake. So, a new interface
> providing UTC should also tell the user about leap seconds.

I agree.  Hence the extra padding that can be used to fix this, once
the fix is available in core code.

I've written the patch and it's not as big an improvement as I hoped.
I'll play with it a bit and send it out soon.

--Andy

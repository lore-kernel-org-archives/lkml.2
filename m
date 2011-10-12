Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285Ab1JLLWA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 07:22:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:58740 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab1JLLV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 07:21:59 -0400
X-Authority-Analysis: v=1.1 cv=agqPq5NoKwAPC9P66H7dbYUCjxvmT73as08i4x3aqAA= c=1 sm=0 a=NFX316_vVeIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=VwQbUJbxAAAA:8 a=dWfaLmDwyz0oxZl-BuwA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1318418515.13262.21.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 0/2 v2] [GIT PULL][v3.2] tracing: queued updates
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 12 Oct 2011 07:21:55 -0400
In-Reply-To: <20111012081629.GA25086@elte.hu>
References: <20111011152026.701326733@goodmis.org>
	 <20111012081629.GA25086@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Added hpa ]

On Wed, 2011-10-12 at 10:16 +0200, Ingo Molnar wrote:
>  
> > Please pull the latest tip/perf/core tree, which can be found at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> > tip/perf/core
> > 
> > Head SHA1: d696b58ca2c3ca76e784ef89a7e0453d9b7ab187
> 
> Hm, even after 12+ hours of wait i can only pull 177e216 from your 
> tip/perf/core. Is this a korg delay, or did you forget to push? The 
> perf/urgent branch was there, so i don't think it's korg delay.

I just tried again, and got:

$ git push push trace/tip/perf/core:tip/perf/core
Enter passphrase for key '/home/rostedt/.ssh/id_rsa_korg': 
Everything up-to-date

$ git log -1 --pretty=oneline trace/tip/perf/core
d696b58ca2c3ca76e784ef89a7e0453d9b7ab187 tracing: Do not allocate buffer for tra

But if I refresh from git itself

$ git remote -v 
ftrace	git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git (fetch)
ftrace	git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git (push)
push	gitolite@ra.kernel.org:/pub/scm/linux/kernel/git/rostedt/linux-trace.git (fetch)
push	gitolite@ra.kernel.org:/pub/scm/linux/kernel/git/rostedt/linux-trace.git (push)

$ git remote update ftrace
Fetching ftrace

$ git log -1 --pretty=oneline ftrace/tip/perf/core
87912fdfc1378a7e7e54a169ef9eebeafa1af04f tracing: Do not allocate buffer for tra

It seems that gitolite isn't refreshing rebases?

I just pushed it to tip/perf/core-2. I waited about 5 minutes, and I
still do not see it.

The urgent branch I pushed the same time as I did the first version of
this branch.

-- Steve



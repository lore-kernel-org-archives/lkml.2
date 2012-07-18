Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab2GRJTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 05:19:10 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:51712 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab2GRJS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 05:18:59 -0400
Date: Wed, 18 Jul 2012 11:18:53 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [GIT PULL][v3.6] tracing: Check for allocation failure in
 __tracing_open()
Message-ID: <20120718091853.GC13116@gmail.com>
References: <1342110245.14868.7.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342110245.14868.7.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> Dan found a bug that is in the queue for 3.6. Please add this for the
> 3.6 queue.
> 
> Thanks,
> 
> Steve
> 
> Please pull the latest tip/perf/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> tip/perf/core
> 
> Head SHA1: 93574fcc5b50cc7b8834698acb2ce947e5b6a5dc
> 
> 
> Dan Carpenter (1):
>       tracing: Check for allocation failure in __tracing_open()
> 
> ----
>  kernel/trace/trace.c |    4 ++++
>  1 file changed, 4 insertions(+)

Pulled, thanks Steve!

	Ingo

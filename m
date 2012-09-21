Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab2IUHMr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 03:12:47 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:53789 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab2IUHMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 03:12:45 -0400
Date: Fri, 21 Sep 2012 09:12:40 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH][GIT PULL][v3.6] tracing: Don't call page_to_pfn() if
 page is NULL
Message-ID: <20120921071240.GA14789@gmail.com>
References: <1348178633.13080.69.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348178633.13080.69.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> I wrote a test that triggers the bug, and tested this patch which seems
> to fix it as well.
> 
> Please pull the latest tip/perf/urgent tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> tip/perf/urgent
> 
> Head SHA1: 85f2a2ef1d0ab99523e0b947a2b723f5650ed6aa
> 
> 
> Wen Congyang (1):
>       tracing: Don't call page_to_pfn() if page is NULL
> 
> ----
>  include/trace/events/kmem.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Pulled, thanks Steve!

	Ingo

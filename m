Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108Ab0LXTFl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 14:05:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34120 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921Ab0LXTFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 14:05:40 -0500
Date: Fri, 24 Dec 2010 20:05:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, David Sharp <dhsharp@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][GIT PULL][v2.6.37] ring_buffer: Off-by-one and duplicate
 events in ring_buffer_read_page
Message-ID: <20101224190527.GA302@elte.hu>
References: <1293140089.22802.400.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293140089.22802.400.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> Please pull the latest tip/perf/urgent tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/urgent
> 
> 
> David Sharp (1):
>       ring_buffer: Off-by-one and duplicate events in ring_buffer_read_page
> 
> ----
>  kernel/trace/ring_buffer.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)

Pulled, thanks Steve!

	Ingo

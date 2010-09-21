Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691Ab0IULPB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 07:15:01 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37035 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab0IULPA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 07:15:00 -0400
Subject: Re: [PATCH 4/4] tracing/sched: Add sched_rt_setprio tracepoint
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gregory Haskins <ghaskins@novell.com>
In-Reply-To: <20100921024139.369929073@goodmis.org>
References: <20100921024002.672817629@goodmis.org>
	 <20100921024139.369929073@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 21 Sep 2010 13:14:52 +0200
Message-ID: <1285067692.2275.830.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-20 at 22:40 -0400, Steven Rostedt wrote:
> plain text document attachment
> (0004-tracing-sched-Add-sched_rt_setprio-tracepoint.patch)
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Add a tracepoint that shows the priority of a task being boosted
> via priority inheritance.

I'm not too sure about having this tracepoint.. Ideally I'd like to
rewrite the whole PI crap to not actually need anything like this.

Also, sched_pi_setprio() would be a better name I think.



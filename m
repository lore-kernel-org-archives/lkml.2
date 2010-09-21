Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467Ab0IUIqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 04:46:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38331 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284Ab0IUIqo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 04:46:44 -0400
Subject: Re: [PATCH 3/4] tracing/sched: Add sched_rt_push and sched_rt_pull
 tracepoints
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gregory Haskins <ghaskins@novell.com>
In-Reply-To: <20100921024139.095017089@goodmis.org>
References: <20100921024002.672817629@goodmis.org>
	 <20100921024139.095017089@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 21 Sep 2010 10:46:33 +0200
Message-ID: <1285058793.2275.799.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-20 at 22:40 -0400, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Seeing how tasks are affected by the push/pull algorithm of the RT
> scheduler helps in understanding the migration of RT tasks.
> 
> Adding these two tracepoints to show when an RT task is pushed from
> one CPU to another, or pulled helps with analyzing the way the
> scheduler works. 

Why doesn't the migration tracepoint cover this? It shows you the task,
the prio, the old and new cpu. If the migration is logged from the old
cpu, its a push, if its logged from the new its a pull, no?

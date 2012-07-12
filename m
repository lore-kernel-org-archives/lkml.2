Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161074Ab2GLN4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 09:56:19 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39128 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387Ab2GLN4R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 09:56:17 -0400
Message-ID: <1342101361.28010.0.camel@twins>
Subject: Re: [PATCH] sched: deliver sched_switch events to a current task
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Arun Sharma <asharma@fb.com>
Date: Thu, 12 Jul 2012 15:56:01 +0200
In-Reply-To: <1342088069-1005148-1-git-send-email-avagin@openvz.org>
References: <1342088069-1005148-1-git-send-email-avagin@openvz.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-12 at 14:14 +0400, Andrew Vagin wrote:
> Otherwise they can't be filtered for a defined task.
> 
> perf record -e sched:sched_switch ./foo
> 
> This command doesn't report any event without this patch.
> 
> I think it isn't a big problem for security, if someone will know
> who will be executed next. By default perf is disabled for non-root
> users.
> 
> I need this events for profiling sleep times.  sched_switch is used for
> getting callchains and sched_stat_* is used for getting time periods.
> This events are combined in user space, then it can be analized by
> perf tools. 

Thanks!

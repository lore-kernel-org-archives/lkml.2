Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab2FLRqQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 13:46:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54162 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab2FLRqP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 13:46:15 -0400
Message-ID: <1339523164.31548.103.camel@twins>
Subject: Re: [RFC] [PATCH 0/5] Teach perf tool to profile sleep times (V4)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Wagin <avagin@gmail.com>
Cc: Arun Sharma <asharma@fb.com>, Oleg Strikov <OSTRIKOV@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Date: Tue, 12 Jun 2012 19:46:04 +0200
In-Reply-To: <CANaxB-xZ+KDZGMb8G1s5q+R_jzdWbP_FFxiGR=s4L90_tUqNjQ@mail.gmail.com>
References: <1338797382-287275-1-git-send-email-avagin@openvz.org>
	 <1338813658.28282.43.camel@twins>
	 <CANaxB-xZ+KDZGMb8G1s5q+R_jzdWbP_FFxiGR=s4L90_tUqNjQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-12 at 17:15 +0400, Andrew Wagin wrote:
> Yes, I like it. Are you going to commit this? 

No its unfinished and untested.. not even sure its seen a compiler.

Also, in another email I wrote:

> Also, you don't need the callchain on the wakeup side of things. You
> only want the callchain of the sched_switch site.
> 
> We could even dis-allow the callchain unwind when event->ctx->task &&
> event->ctx->task != current -- pretend the unwind failed by writing 0
> entries.
> 
> That also avoids the 'difficultly' of exposing and trying to interpret
> another task's callchain.

That probably wants to be done as well.

If you have the time, please look into this. Hoping of course Frederic
and others don't object to this.. :-)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977Ab0EDR3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 13:29:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55947 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757858Ab0EDR33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 13:29:29 -0400
Subject: Re: [RFC PATCHSET] sched,perf: unify tracers in sched and move
 perf on top of TP
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, efault@gmx.de, avi@redhat.com, paulus@samba.org,
       acme@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <1272976724-14312-1-git-send-email-tj@kernel.org>
References: <1272976724-14312-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 May 2010 19:29:25 +0200
Message-ID: <1272994165.1642.203.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-04 at 14:38 +0200, Tejun Heo wrote:
> 
> This patchset does the following two things.
> 
> * 0001-0007: Unify the three tracers (tracepoints, perf_events and
>   preempt/sched notifiers) in scheduler.

Right, so I really don't like the SCHED_EVENT() thing much, esp the 3
different function postfixes.

> * 0008-0012: Move perf hooks in sched on top of tracepoints if TPs are
>              enabled.

This seems to add a terrible amount of overhead for no particular
reason.

I know Ingo was pushing to consolidate things, but imho this cure is
worse than the ailment.




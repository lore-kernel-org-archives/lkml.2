Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390Ab0LKAvm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 19:51:42 -0500
Received: from novprvoes0310.provo.novell.com ([137.65.248.74]:34545 "EHLO
	novprvoes0310.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756539Ab0LKAvl convert rfc822-to-8bit
	(ORCPT <rfc822;groupwise-GHaskins@novell.com:5:1>);
	Fri, 10 Dec 2010 19:51:41 -0500
Message-Id: <4D0284C80200005A000784C7@novprvoes0310.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Fri, 10 Dec 2010 17:51:36 -0700
From: "Gregory Haskins" <GHaskins@novell.com>
To: <rostedt@goodmis.org>
Cc: <a.p.zijlstra@chello.nl>, <mingo@elte.hu>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 04/10] sched: Change pick_next_task_rt from
 unlikely to likely
References: <4D0284C80200005A000784C4@novprvoes0310.provo.novell.com>
 <4D0284C80200005A000784C7@novprvoes0310.provo.novell.com>
In-Reply-To: <4D0284C80200005A000784C7@novprvoes0310.provo.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for toppost...mobile.

Re: mail client: ack
Re: patch: ack

;)

-Greg 
-----Original Message-----
From: Steven Rostedt <rostedt@goodmis.org>
To: Gregory Haskins <GHaskins@novell.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc:  <linux-kernel@vger.kernel.org>

Sent: 12/10/2010 7:07:29 PM
Subject: Re: [RFC][PATCH 04/10] sched: Change pick_next_task_rt from unlikely to likely

On Mon, 2010-12-06 at 19:46 -0700, Gregory Haskins wrote:

> My feeling is that generally speaking, if the branch is workload dependent, we should probably not annotate it at all and let the CPUs branch-predictor do its thing.  I guess what I am not 100% clear on is how these annotations affect the BPU.  I.e. is it a static decision point or can the BPU still "learn" if the annotation is particularly wrong for a given workload?  For the former, I think we should just remove this particular annotation (and there are others that need review).  For the latter, this is obviously the right annotation we should be using in this particular case.
> 

You need to get a better email client ;-)

OK, if I just remove the likely() do you Ack it?

-- Steve




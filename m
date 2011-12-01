Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601Ab1LAXTf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 18:19:35 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:43794 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755346Ab1LAXTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 18:19:34 -0500
X-Sasl-enc: ImGToftpMzvDIwGn5VVtMKAz9PI2WFwPBGrP3j4qzlLo 1322781573
Date: Thu, 1 Dec 2011 15:18:31 -0800
From: Greg KH <greg@kroah.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        devel@driverdev.osuosl.org, lttng-dev@lists.lttng.org,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Darren Hart <darren@dvhart.com>
Subject: Re: [PATCH 09/11] sched: export task_prio to GPL modules
Message-ID: <20111201231831.GB4961@kroah.com>
References: <1322775683-8741-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1322775683-8741-10-git-send-email-mathieu.desnoyers@efficios.com>
 <1322776568.4699.52.camel@twins>
 <20111201220445.GA10552@Krystal>
 <1322777407.4699.59.camel@twins>
 <20111201221500.GC10552@Krystal>
 <1322780797.4699.61.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322780797.4699.61.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 02, 2011 at 12:06:37AM +0100, Peter Zijlstra wrote:
> On Thu, 2011-12-01 at 17:15 -0500, Mathieu Desnoyers wrote:
> > 
> > If you don't want to trace sched_switch, but just conveniently prepend
> > this information to all your events 
> 
> Oh so you want to debug a scheduler issue but don't want to use the
> scheduler tracepoint, I guess that makes perfect sense for clueless
> people.

Matheiu, can't lttng use the scheduler tracepoint for this information?



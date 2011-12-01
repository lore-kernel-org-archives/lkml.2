Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560Ab1LAXHI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 18:07:08 -0500
Received: from casper.infradead.org ([85.118.1.10]:51899 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172Ab1LAXHH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 18:07:07 -0500
Message-ID: <1322780797.4699.61.camel@twins>
Subject: Re: [PATCH 09/11] sched: export task_prio to GPL modules
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Greg KH <greg@kroah.com>, devel@driverdev.osuosl.org,
        lttng-dev@lists.lttng.org, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Darren Hart <darren@dvhart.com>
Date: Fri, 02 Dec 2011 00:06:37 +0100
In-Reply-To: <20111201221500.GC10552@Krystal>
References: <1322775683-8741-1-git-send-email-mathieu.desnoyers@efficios.com>
	 <1322775683-8741-10-git-send-email-mathieu.desnoyers@efficios.com>
	 <1322776568.4699.52.camel@twins> <20111201220445.GA10552@Krystal>
	 <1322777407.4699.59.camel@twins> <20111201221500.GC10552@Krystal>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-01 at 17:15 -0500, Mathieu Desnoyers wrote:
> 
> If you don't want to trace sched_switch, but just conveniently prepend
> this information to all your events 

Oh so you want to debug a scheduler issue but don't want to use the
scheduler tracepoint, I guess that makes perfect sense for clueless
people.

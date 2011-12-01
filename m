Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab1LAXGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 18:06:30 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42083 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172Ab1LAXG3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 18:06:29 -0500
Message-ID: <1322780758.4699.60.camel@twins>
Subject: Re: [PATCH 09/11] sched: export task_prio to GPL modules
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Greg KH <greg@kroah.com>, devel@driverdev.osuosl.org,
        lttng-dev@lists.lttng.org, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Darren Hart <darren@dvhart.com>
Date: Fri, 02 Dec 2011 00:05:58 +0100
In-Reply-To: <20111201223607.GF10552@Krystal>
References: <1322775683-8741-1-git-send-email-mathieu.desnoyers@efficios.com>
	 <1322775683-8741-10-git-send-email-mathieu.desnoyers@efficios.com>
	 <1322776568.4699.52.camel@twins> <20111201220445.GA10552@Krystal>
	 <1322777407.4699.59.camel@twins> <20111201221500.GC10552@Krystal>
	 <20111201223607.GF10552@Krystal>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-01 at 17:36 -0500, Mathieu Desnoyers wrote:
> So what you are saying is that it is fine to export task_prio to
> _userspace_, thus making it part of the ABI, but it's not OK to export
> it to GPL modules ? 

that's a SCHED_DEBUG proc file.

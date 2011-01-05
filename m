Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869Ab1AEJ5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 04:57:51 -0500
Received: from casper.infradead.org ([85.118.1.10]:40122 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab1AEJ5u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 04:57:50 -0500
Subject: Re: [RFC patch 5/5] trace event sched: remove TP_perf_assign
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <20110104232419.782205410@efficios.com>
References: <20110104231629.996422888@efficios.com>
	 <20110104232419.782205410@efficios.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 05 Jan 2011 10:58:06 +0100
Message-ID: <1294221486.2016.212.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-04 at 18:16 -0500, Mathieu Desnoyers wrote:
> plain text document attachment (trace-event-sched-remove-perf-count.patch)
> The TP_perf_assign part of 2 scheduler TRACE_EVENT are not used and don't act as
> TRACE_EVENT fields per se.

Hrm,. they should be used, include/trace/ftrace.h uses __perf_count().
If it doesn't actually work them something broke.

So NAK on removing them.

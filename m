Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab1KYWnc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 17:43:32 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58709 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab1KYWnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 17:43:31 -0500
Message-ID: <1322261005.2550.6.camel@edumazet-laptop>
Subject: Re: [PATCH] Tracepoint: introduce tracepoint() API
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Christoph Lameter <cl@linux-foundation.org>
Date: Fri, 25 Nov 2011 23:43:25 +0100
In-Reply-To: <20111125221411.GA11733@Krystal>
References: <20111125221411.GA11733@Krystal>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 25 novembre 2011 à 17:14 -0500, Mathieu Desnoyers a écrit :
> Introduce:
> 
>   tracepoint(event_name, arg1, arg2, ...)
> 
> while keeping the old tracepoint API in place, e.g.:
> 
>   trace_event_name(arg1, arg2, ...)
> 
> This allows skipping parameter side-effects (pointer dereference,
> function calls, ...) when the tracepoint is not dynamically activated.
> 
> This allows progressive (and partial) API transition from trace_*(...)
> to tracepoint(*, ...). This differs from the previous attempt to
> introduce this change by Jason Baron in that it supports both the
> original and new tracepoint APIs, which makes the transition smoother
> than having to change all instrumentation at once.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Acked-by: Steven Rostedt <rostedt@goodmis.org>
> Acked-by: Jason Baron <jbaron@redhat.com>
> Link: https://lkml.org/lkml/2009/5/19/328
> CC: Eric Dumazet <eric.dumazet@gmail.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Christoph Lameter <cl@linux-foundation.org>
> ---

Seems good to me, thanks Mathieu !

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>




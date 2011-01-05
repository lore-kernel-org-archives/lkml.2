Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584Ab1AEAAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 19:00:13 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61406 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab1AEAAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 19:00:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DQFVWKMQHQItm75BBOgxuhb8aRCyycRhJkb04MuoQjAPph2btW+ZydKpAIOBOS6KY0
         c5J+5ABK8SbU8KK3zkGmT6VpuSDvAaeB76kz6fAvADbH3IefymOrx1g018fjq3PbY4Y4
         J1vDqrDrTE3iea3c12FCbOyGxRAHX86xy4IUM=
Date: Wed, 5 Jan 2011 01:00:08 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC patch 3/5] ftrace trace event add missing semicolumn
Message-ID: <20110105000005.GE2911@nowhere>
References: <20110104231629.996422888@efficios.com>
 <20110104232419.441463699@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110104232419.441463699@efficios.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 04, 2011 at 06:16:32PM -0500, Mathieu Desnoyers wrote:
> Add a missing semicolumn at the end of a ftrace definition.
> 
> We currently are not seeing any impact of this missing semicolumn because extra
> semicolumns appear all over the place in the code generated from TRACE_EVENT
> within ftrace stages.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> CC: Steven Rostedt <rostedt@goodmis.org>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Thomas Gleixner <tglx@linutronix.de>
> ---
>  include/trace/ftrace.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6-lttng/include/trace/ftrace.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/trace/ftrace.h
> +++ linux-2.6-lttng/include/trace/ftrace.h
> @@ -69,7 +69,7 @@
>  #undef DEFINE_EVENT
>  #define DEFINE_EVENT(template, name, proto, args)	\
>  	static struct ftrace_event_call	__used		\
> -	__attribute__((__aligned__(4))) event_##name
> +	__attribute__((__aligned__(4))) event_##name;

But DEFINE_EVENT() calls are supposed to be ";" terminated, no?

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299Ab1ECM7j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 08:59:39 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:57252 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750740Ab1ECM7i convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 08:59:38 -0400
MIME-Version: 1.0
In-Reply-To: <20110502213213.543282864@efficios.com>
References: <20110502211123.163877033@efficios.com>
	<20110502213213.543282864@efficios.com>
Date: Tue, 3 May 2011 14:59:37 +0200
Message-ID: <BANLkTikdj8Wak1kS9L5KPpyGmbXwE4dxkA@mail.gmail.com>
Subject: Re: [RFC patch 14/32] trace event power remove semicolons
From: "Pihet-XID, Jean" <j-pihet@ti.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Thomas Renninger <trenn@suse.de>, Len Brown <len.brown@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 2, 2011 at 11:11 PM, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
> Part of the gradual TRACE_EVENT() semicolon removal. Enables creation of array
> of events, thus saving space for trace event probes.
>
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> CC: Steven Rostedt <rostedt@goodmis.org>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Jean Pihet <j-pihet@ti.com>
> CC: Arjan van de Ven <arjan@linux.intel.com>
> CC: Thomas Renninger <trenn@suse.de>
> CC: Len Brown <len.brown@intel.com>
> ---
>  include/trace/events/power.h |   28 ++++++++++++++--------------
>  1 file changed, 14 insertions(+), 14 deletions(-)

Acked-by: j-pihet@ti.com

>
> Index: linux-2.6-lttng/include/trace/events/power.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/trace/events/power.h
> +++ linux-2.6-lttng/include/trace/events/power.h
> @@ -25,14 +25,14 @@ DECLARE_EVENT_CLASS(cpu,
>
>        TP_printk("state=%lu cpu_id=%lu", (unsigned long)__entry->state,
>                  (unsigned long)__entry->cpu_id)
> -);
> +)
>
>  DEFINE_EVENT(cpu, cpu_idle,
>
>        TP_PROTO(unsigned int state, unsigned int cpu_id),
>
>        TP_ARGS(state, cpu_id)
> -);
> +)
>
>  /* This file can get included multiple times, TRACE_HEADER_MULTI_READ at top */
>  #ifndef _PWR_EVENT_AVOID_DOUBLE_DEFINING
> @@ -46,7 +46,7 @@ DEFINE_EVENT(cpu, cpu_frequency,
>        TP_PROTO(unsigned int frequency, unsigned int cpu_id),
>
>        TP_ARGS(frequency, cpu_id)
> -);
> +)
>
>  TRACE_EVENT(machine_suspend,
>
> @@ -63,7 +63,7 @@ TRACE_EVENT(machine_suspend,
>        ),
>
>        TP_printk("state=%lu", (unsigned long)__entry->state)
> -);
> +)
>
>  /* This code will be removed after deprecation time exceeded (2.6.41) */
>  #ifdef CONFIG_EVENT_POWER_TRACING_DEPRECATED
> @@ -92,21 +92,21 @@ DECLARE_EVENT_CLASS(power,
>
>        TP_printk("type=%lu state=%lu cpu_id=%lu", (unsigned long)__entry->type,
>                (unsigned long)__entry->state, (unsigned long)__entry->cpu_id)
> -);
> +)
>
>  DEFINE_EVENT(power, power_start,
>
>        TP_PROTO(unsigned int type, unsigned int state, unsigned int cpu_id),
>
>        TP_ARGS(type, state, cpu_id)
> -);
> +)
>
>  DEFINE_EVENT(power, power_frequency,
>
>        TP_PROTO(unsigned int type, unsigned int state, unsigned int cpu_id),
>
>        TP_ARGS(type, state, cpu_id)
> -);
> +)
>
>  TRACE_EVENT(power_end,
>
> @@ -124,7 +124,7 @@ TRACE_EVENT(power_end,
>
>        TP_printk("cpu_id=%lu", (unsigned long)__entry->cpu_id)
>
> -);
> +)
>
>  /* Deprecated dummy functions must be protected against multi-declartion */
>  #ifndef _PWR_EVENT_AVOID_DOUBLE_DEFINING_DEPRECATED
> @@ -180,28 +180,28 @@ DECLARE_EVENT_CLASS(clock,
>
>        TP_printk("%s state=%lu cpu_id=%lu", __get_str(name),
>                (unsigned long)__entry->state, (unsigned long)__entry->cpu_id)
> -);
> +)
>
>  DEFINE_EVENT(clock, clock_enable,
>
>        TP_PROTO(const char *name, unsigned int state, unsigned int cpu_id),
>
>        TP_ARGS(name, state, cpu_id)
> -);
> +)
>
>  DEFINE_EVENT(clock, clock_disable,
>
>        TP_PROTO(const char *name, unsigned int state, unsigned int cpu_id),
>
>        TP_ARGS(name, state, cpu_id)
> -);
> +)
>
>  DEFINE_EVENT(clock, clock_set_rate,
>
>        TP_PROTO(const char *name, unsigned int state, unsigned int cpu_id),
>
>        TP_ARGS(name, state, cpu_id)
> -);
> +)
>
>  /*
>  * The power domain events are used for power domains transitions
> @@ -226,14 +226,14 @@ DECLARE_EVENT_CLASS(power_domain,
>
>        TP_printk("%s state=%lu cpu_id=%lu", __get_str(name),
>                (unsigned long)__entry->state, (unsigned long)__entry->cpu_id)
> -);
> +)
>
>  DEFINE_EVENT(power_domain, power_domain_target,
>
>        TP_PROTO(const char *name, unsigned int state, unsigned int cpu_id),
>
>        TP_ARGS(name, state, cpu_id)
> -);
> +)
>  #endif /* _TRACE_POWER_H */
>
>  /* This part must be outside protection */
>
>

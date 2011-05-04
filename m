Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab1EDI5m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 04:57:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54896 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751768Ab1EDI5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 04:57:41 -0400
Date: Wed, 4 May 2011 09:56:39 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        lrg@slimlogic.co.uk
Subject: Re: [RFC patch 31/32] trace event regulator remove semicolons
Message-ID: <20110504085639.GA9254@opensource.wolfsonmicro.com>
References: <20110503231023.968960757@efficios.com>
 <20110503231429.245222720@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110503231429.245222720@efficios.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 07:10:54PM -0400, Mathieu Desnoyers wrote:
> Part of the gradual TRACE_EVENT() semicolon removal. Enables creation of array
> of events, thus saving space for trace event probes.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> CC: Steven Rostedt <rostedt@goodmis.org>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Mark Brown <broonie@opensource.wolfsonmicro.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

and adding Liam again.

> ---
>  include/trace/events/regulator.h |   20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> Index: linux-2.6-lttng/include/trace/events/regulator.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/trace/events/regulator.h
> +++ linux-2.6-lttng/include/trace/events/regulator.h
> @@ -27,7 +27,7 @@ DECLARE_EVENT_CLASS(regulator_basic,
>  
>  	TP_printk("name=%s", __get_str(name))
>  
> -);
> +)
>  
>  DEFINE_EVENT(regulator_basic, regulator_enable,
>  
> @@ -35,7 +35,7 @@ DEFINE_EVENT(regulator_basic, regulator_
>  
>  	TP_ARGS(name)
>  
> -);
> +)
>  
>  DEFINE_EVENT(regulator_basic, regulator_enable_delay,
>  
> @@ -43,7 +43,7 @@ DEFINE_EVENT(regulator_basic, regulator_
>  
>  	TP_ARGS(name)
>  
> -);
> +)
>  
>  DEFINE_EVENT(regulator_basic, regulator_enable_complete,
>  
> @@ -51,7 +51,7 @@ DEFINE_EVENT(regulator_basic, regulator_
>  
>  	TP_ARGS(name)
>  
> -);
> +)
>  
>  DEFINE_EVENT(regulator_basic, regulator_disable,
>  
> @@ -59,7 +59,7 @@ DEFINE_EVENT(regulator_basic, regulator_
>  
>  	TP_ARGS(name)
>  
> -);
> +)
>  
>  DEFINE_EVENT(regulator_basic, regulator_disable_complete,
>  
> @@ -67,7 +67,7 @@ DEFINE_EVENT(regulator_basic, regulator_
>  
>  	TP_ARGS(name)
>  
> -);
> +)
>  
>  /*
>   * Events that take a range of numerical values, mostly for voltages
> @@ -93,7 +93,7 @@ DECLARE_EVENT_CLASS(regulator_range,
>  
>  	TP_printk("name=%s (%d-%d)", __get_str(name),
>  		  (int)__entry->min, (int)__entry->max)
> -);
> +)
>  
>  DEFINE_EVENT(regulator_range, regulator_set_voltage,
>  
> @@ -101,7 +101,7 @@ DEFINE_EVENT(regulator_range, regulator_
>  
>  	TP_ARGS(name, min, max)
>  
> -);
> +)
>  
>  
>  /*
> @@ -125,7 +125,7 @@ DECLARE_EVENT_CLASS(regulator_value,
>  
>  	TP_printk("name=%s, val=%u", __get_str(name),
>  		  (int)__entry->val)
> -);
> +)
>  
>  DEFINE_EVENT(regulator_value, regulator_set_voltage_complete,
>  
> @@ -133,7 +133,7 @@ DEFINE_EVENT(regulator_value, regulator_
>  
>  	TP_ARGS(name, value)
>  
> -);
> +)
>  
>  #endif /* _TRACE_POWER_H */
>  
> 

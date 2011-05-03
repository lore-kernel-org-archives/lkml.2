Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab1ECOau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 10:30:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50531 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751262Ab1ECOat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 10:30:49 -0400
Date: Tue, 3 May 2011 15:30:47 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, lrg@slimlogic.co.uk
Subject: Re: [RFC patch 31/32] trace event regulator remove semicolons
Message-ID: <20110503143046.GR1762@opensource.wolfsonmicro.com>
References: <20110502211123.163877033@efficios.com>
 <20110502213216.383361752@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110502213216.383361752@efficios.com>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 05:11:54PM -0400, Mathieu Desnoyers wrote:
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

and adding Liam.

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

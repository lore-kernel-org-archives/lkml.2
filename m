Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118Ab1KPPTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 10:19:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56099 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756370Ab1KPPTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 10:19:08 -0500
X-Authority-Analysis: v=2.0 cv=JOm5Qr2b c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=5K7hI6SSdcEA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=QyXUC8HyAAAA:8 a=enOUvTreUiab_gNYiHMA:9 a=QEXdDO2ut3YA:10 a=dGJ0OcVc7YAA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH v2] tracing: add trace console
From: Steven Rostedt <rostedt@goodmis.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1321456198.4502.10.camel@jlt3.sipsolutions.net>
References: <1321438728.4773.16.camel@jlt3.sipsolutions.net>
	 <1321452954.4181.20.camel@frodo>
	 <1321456198.4502.10.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Nov 2011 10:19:06 -0500
Message-ID: <1321456746.4181.25.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-16 at 16:09 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>

> +config TRACE_CONSOLE
> +	tristate "Support for a tracing console"
> +	help
> +	  Enable this to get a tracing console that puts every kernel message
> +	  into the tracing infrastructure using trace_printk(). This is useful
> +	  to correlate (existing) printk debugging with tracing. When using it
> +	  remember to set the console level, e.g. with "dmesg -n8".
> +
> +	  Note that if you say Y here you will get every message into tracing
> +	  and will not be able to turn it off.
> +
> +	  The module is called trace-console.

OK, this is much better. I'll apply it for my 3.3 queue.

Peter, can I get your Acked-by?

Thanks!

-- Steve



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931Ab1KPPR4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 10:17:56 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56165 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757591Ab1KPPRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 10:17:55 -0500
X-Authority-Analysis: v=2.0 cv=NJxXCjGg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=l4wf8OQxcBQA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=4MV3xVIxkME-P_Rlkj4A:9 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH] tracing: add trace console
From: Steven Rostedt <rostedt@goodmis.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1321455117.4502.4.camel@jlt3.sipsolutions.net>
References: <1321438728.4773.16.camel@jlt3.sipsolutions.net>
	 <1321452954.4181.20.camel@frodo>  <1321453537.27735.0.camel@twins>
	 <1321453846.4502.0.camel@jlt3.sipsolutions.net>
	 <1321454928.4181.22.camel@frodo>
	 <1321455117.4502.4.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Nov 2011 10:17:52 -0500
Message-ID: <1321456672.4181.24.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-16 at 15:51 +0100, Johannes Berg wrote:
> cho 0 > /debug/tracing/options/trace_printk
> 
> Oh. Maybe I'll just remove it this then. I guess you kinda have to know
> (or be told) you want this anyway.

I would reword it to something that explains this, but don't say
anything about recommending it or not. Just say that when this is
enabled, all printks will go into the trace buffer. If you need to
disable it, you must set it as a module that can be unloaded.

-- Steve



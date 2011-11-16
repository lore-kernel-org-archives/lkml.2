Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571Ab1KPOu4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 09:50:56 -0500
Received: from casper.infradead.org ([85.118.1.10]:39834 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab1KPOuz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 09:50:55 -0500
Subject: Re: [PATCH] tracing: add trace console
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 16 Nov 2011 15:50:31 +0100
In-Reply-To: <1321454928.4181.22.camel@frodo>
References: <1321438728.4773.16.camel@jlt3.sipsolutions.net>
	 <1321452954.4181.20.camel@frodo>  <1321453537.27735.0.camel@twins>
	 <1321453846.4502.0.camel@jlt3.sipsolutions.net>
	 <1321454928.4181.22.camel@frodo>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1321455031.27735.4.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-16 at 09:48 -0500, Steven Rostedt wrote:

> > It'll always be registered and you have no way to turn it off then, so
> > you can't trace without getting every printk. I didn't want to add extra
> > API to toggle it, but building it in might be a bit odd that way.
> 
> Actually, that's not quite true. You could just do:
> 
> echo 0 > /debug/tracing/options/trace_printk

well, that'll kill all trace_printk()s, which isn't what johill meant.


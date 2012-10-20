Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab2JTQuR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 12:50:17 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59626 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753303Ab2JTQuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 12:50:15 -0400
Message-ID: <1350751814.10791.10.camel@joe-AO722>
Subject: Re: [RFC PATCH 8/8] printk: Wake up klogd using irq_work
From: Joe Perches <joe@perches.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Sat, 20 Oct 2012 09:50:14 -0700
In-Reply-To: <1350750167-14263-9-git-send-email-fweisbec@gmail.com>
References: <1350750167-14263-1-git-send-email-fweisbec@gmail.com>
	 <1350750167-14263-9-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-10-20 at 12:22 -0400, Frederic Weisbecker wrote:
> lets implement the printk tick using irq work.

Hi Frederic.

Can you redo this change please against -next in a few days? 

Andrew Morton picked up this series,
https://lkml.org/lkml/2012/10/17/41
but it's not yet in -next.

https://lkml.org/lkml/2012/10/18/600

kernel/printk.c has been moved to kernel/printk/printk.c
and broken up into multiple files.

thanks,  Joe


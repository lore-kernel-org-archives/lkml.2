Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477Ab2JTRVJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 13:21:09 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:36381 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756385Ab2JTRVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 13:21:06 -0400
MIME-Version: 1.0
In-Reply-To: <1350751814.10791.10.camel@joe-AO722>
References: <1350750167-14263-1-git-send-email-fweisbec@gmail.com>
	<1350750167-14263-9-git-send-email-fweisbec@gmail.com>
	<1350751814.10791.10.camel@joe-AO722>
Date: Sat, 20 Oct 2012 13:21:05 -0400
Message-ID: <CAFTL4hzLnxYSx-HE+ZaphiCTKsp90mb+jZUYudKW3wVL+PzytA@mail.gmail.com>
Subject: Re: [RFC PATCH 8/8] printk: Wake up klogd using irq_work
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/20 Joe Perches <joe@perches.com>:
> On Sat, 2012-10-20 at 12:22 -0400, Frederic Weisbecker wrote:
>> lets implement the printk tick using irq work.
>
> Hi Frederic.
>
> Can you redo this change please against -next in a few days?
>
> Andrew Morton picked up this series,
> https://lkml.org/lkml/2012/10/17/41
> but it's not yet in -next.
>
> https://lkml.org/lkml/2012/10/18/600
>
> kernel/printk.c has been moved to kernel/printk/printk.c
> and broken up into multiple files.

Sure, I will rebase to your work on the next version.

Thanks.

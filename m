Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760831Ab2J2U6F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 16:58:05 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38602 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560Ab2J2U6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 16:58:03 -0400
MIME-Version: 1.0
In-Reply-To: <1351518986.8467.68.camel@gandalf.local.home>
References: <1351517296-9173-1-git-send-email-fweisbec@gmail.com>
	<1351517296-9173-5-git-send-email-fweisbec@gmail.com>
	<1351518986.8467.68.camel@gandalf.local.home>
Date: Mon, 29 Oct 2012 21:58:01 +0100
Message-ID: <CAFTL4hwzgEDPjKLifpFGbCbqV-qiNdw3LQooimrynSCU5H1khQ@mail.gmail.com>
Subject: Re: [RFC PATCH 4/9] irq_work: Let the arch tell us about self-IPI support
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/29 Steven Rostedt <rostedt@goodmis.org>:
> On Mon, 2012-10-29 at 14:28 +0100, Frederic Weisbecker wrote:
>> This prepares us to make printk working on nohz CPUs
>> using irq work.
>
> -ENOTENOUGHINFO
>
> Please state how this prepares printk for nohz CPUS using irq_work.

RIght, I'll add the details in the next version.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964936Ab2J3RRO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 13:17:14 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:52764 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964823Ab2J3RRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 13:17:13 -0400
MIME-Version: 1.0
In-Reply-To: <1351617192.8467.124.camel@gandalf.local.home>
References: <1351611301-3520-1-git-send-email-fweisbec@gmail.com>
	<1351612350.8467.104.camel@gandalf.local.home>
	<CAFTL4hzhTtx_OFeRE+RzsPvMWXr0ncbAjkFhEV-TE_XAFVNbdg@mail.gmail.com>
	<1351617192.8467.124.camel@gandalf.local.home>
Date: Tue, 30 Oct 2012 18:17:12 +0100
Message-ID: <CAFTL4hwZe81m0od4zU_TMi5rL_S4zLtH6Heo=8-qydb9UYE_tg@mail.gmail.com>
Subject: Re: [PATCH 0/2] irq_work: A couple fixes
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/30 Steven Rostedt <rostedt@goodmis.org>:
> On Tue, 2012-10-30 at 17:25 +0100, Frederic Weisbecker wrote:
>
>> No I was worried about the cpu_relax() in irq_work_sync()
>
> That one is fine too, as this is the purpose of cpu_relax(). Not only to
> relax the cpu, but also to tell gcc that the loop needs to be reread.

Ok, should be fine then.

Thanks!

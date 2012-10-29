Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760402Ab2J2Sh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 14:37:28 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:34754 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757476Ab2J2Sh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 14:37:26 -0400
MIME-Version: 1.0
In-Reply-To: <1351518762.8467.67.camel@gandalf.local.home>
References: <1351517296-9173-1-git-send-email-fweisbec@gmail.com>
	<1351517296-9173-4-git-send-email-fweisbec@gmail.com>
	<1351518762.8467.67.camel@gandalf.local.home>
Date: Mon, 29 Oct 2012 19:37:25 +0100
Message-ID: <CAFTL4hxUeg+M4j8NMwVEjFsB2BQWPWfD4nfzDFZMCPQzqFU+xg@mail.gmail.com>
Subject: Re: [RFC PATCH 3/9] irq_work: Move irq_work_raise()
 declaration/default definition to arch headers
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
> Don't add stub files. We don't do that anymore.
>
> The correct way of doing this is to modify:
>
>  arch/*/include/asm/Kbuild
>
> and add:
>
>  generic-y += irq_work.h

Ah, ok!

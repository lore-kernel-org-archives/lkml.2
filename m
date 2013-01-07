Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733Ab3AGVea (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 16:34:30 -0500
Received: from mail-vb0-f44.google.com ([209.85.212.44]:49634 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603Ab3AGVe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 16:34:29 -0500
MIME-Version: 1.0
In-Reply-To: <20121216092232.GA23189@gmail.com>
References: <1355498868-8337-1-git-send-email-fweisbec@gmail.com>
	<20121216092232.GA23189@gmail.com>
Date: Mon, 7 Jan 2013 22:34:28 +0100
Message-ID: <CAFTL4hwffymjAstKHB4S238goaNMpW_0hO74nFBKGrP1J6rs7A@mail.gmail.com>
Subject: Re: [PATCH v2] context_tracking: Add comments on interface and internals
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/12/16 Ingo Molnar <mingo@kernel.org>:
>
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
>> +
>> +/**
>> + * context_tracking_task_switch - context switch the syscall hooks
>> + *
>> + * The context tracking uses the syscall slow path to implement its user-kernel
>> + * boundaries hooks on syscalls. This way it doesn't impact the syscall fast
>> + * path on CPUs that don't do context tracking.
>> + *
>> + * But we need to clear the flag on the previous task because it may later
>> + * migrate to some CPU that doesn't do the context tracking. As such the TIF
>> + * flag may not be desired there.
>
> If possible: s/hooks/callbacks
>
> 'hook' gives me the visual of a box match. YMMV.

Ok, I'm fixing this.

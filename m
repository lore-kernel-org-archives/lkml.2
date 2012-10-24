Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934858Ab2JXN4q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 09:56:46 -0400
Received: from mail.lemote.com ([222.92.8.141]:48411 "EHLO lemote.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934740Ab2JXN4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 09:56:45 -0400
Message-ID: <4794.58.209.249.125.1351084344.squirrel@mail.lemote.com>
Date: Wed, 24 Oct 2012 21:12:24 +0800 (CST)
Subject: Re: [RFC][PATCH] sched: Fix a deadlock of cpu-hotplug
From: =?gb2312?Q?=B3=C2=BB=AA=B2=C5?= <chenhc@lemote.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Cc: "Ingo Molnar" <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        "Fuxin Zhang" <zhangfx@lemote.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Tejun Heo" <tj@kernel.org>
User-Agent: SquirrelMail/1.4.11
MIME-Version: 1.0
Content-Type: text/plain;charset=gb2312
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Wed, 2012-10-24 at 20:34 +0800, ³Â»ª²Å wrote:
>> I see, this is an arch-specific bug, sorry for my carelessness and thank
>> you for your tips.
>
> What arch are you using? And what exactly did the arch do wrong? Most of
> the code involved seems to be common code.
>
> Going by c0_compare_interrupt, this is some MIPS device.
>
Yes, I'm use MIPS, In a place which local_irq_save()/local_irq_restore()
should be used, I use local_irq_disable()/local_irq_enable() by mistake.



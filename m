Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab1CYQpU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 12:45:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42213 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753373Ab1CYQpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 12:45:18 -0400
MIME-Version: 1.0
In-Reply-To: <tip-45daae575e08bbf7405c5a3633e956fa364d1b4f@git.kernel.org>
References: <tip-45daae575e08bbf7405c5a3633e956fa364d1b4f@git.kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 25 Mar 2011 09:44:24 -0700
Message-ID: <AANLkTi=Dgo7Ck-Nc+qq7roRqcO9mtoA_FLt=QA6mdK_W@mail.gmail.com>
Subject: Re: [tip:perf/urgent] perf, x86: Complain louder about BIOSen
 corrupting CPU/PMU state and continue
To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 4:52 AM, tip-bot for Ingo Molnar <mingo@elte.hu> wrote:
>
> perf, x86: Complain louder about BIOSen corrupting CPU/PMU state and continue

I don't think this should go into "urgent". It's more of an annoyance
than anything we need to fix in 39.

Also, don't we need to make sure that the event isn't tied to the SCI
line? I thought the affected BIOSen did something odd with the local
apic setup too? But that might be some fevered nightmare dream of
mine, and/or just a misunderstanding from the hallway discussion I've
had with people about this.

This might also be something we do want to give a kernel command line
option for. As in "bios=allow-annoying-pmu-thing" or whatever.

                    Linus

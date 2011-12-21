Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab1LUSrF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 13:47:05 -0500
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:20739 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751525Ab1LUSrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 13:47:03 -0500
Date: Wed, 21 Dec 2011 10:47:02 -0800 (PST)
From: Aaron Spear <aspear@vmware.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: devel@driverdev.osuosl.org, Peter Zijlstra <peterz@infradead.org>,
        Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>, lttng-dev@lists.lttng.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: Re: [lttng-dev] [PATCH 09/11] sched: export task_prio to GPL modules
Message-ID: <fb3f11b9-d36f-4160-96ff-c4610af742de@aspear-win7>
In-Reply-To: <20111220110813.GA19105@elte.hu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [24.8.22.216]
X-Mailer: Zimbra 7.1.3_GA_3374 (Zimbra Desktop/7.1.2_10978_Windows)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar <mingo@elte.hu> wrote:

> "CTF" was mainly written by yourself, right?
> 
> If there's any tool worth caring about that wants to deal in CTF
> then it can be converted just fine. I don't think it matters
> nearly as much as you seem to imply, see my reply further below.

Hi Ingo,

I thought it might be a useful point of reference to mention that there is a commitment to CTF for more than just LTTng.  The Multicore Association and member companies including TI, Freescale, Samsung, Mentor Graphics, Wind River Systems, VMware and others intend to use CTF as a lingua franca for correlation of traces taken from different tracing technologies in heterogeneous multi-core systems.  Linux is pivotal here of course, but we are also aggregating various types of hardware traces as well as instrumentation trace from bare metal, RTOS's, and other OS's.  Many of the requirements that went into the draft CTF specification were driven by this working groups experience in the embedded industry and many different legacy tracing technologies.  While Mathieu has been instrumental in creating CTF, he is certainly not the only one with a vested interest in its future.

respectfully,
Aaron Spear - VMware
Chairman, Multicore Association Tools Infrastructure Working Group

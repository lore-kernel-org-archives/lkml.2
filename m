Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361Ab0EFITp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 04:19:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9312 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752665Ab0EFITn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 04:19:43 -0400
Message-ID: <4BE27B6F.2030806@redhat.com>
Date: Thu, 06 May 2010 11:18:55 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
       efault@gmx.de, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCHSET] sched,perf: unify tracers in sched and move perf
 on top of TP
References: <1273050400.1642.229.camel@laptop> <4BE13B33.3030709@kernel.org> <1273053073.1642.235.camel@laptop> <4BE1406C.2000400@kernel.org> <1273059488.1642.245.camel@laptop> <4BE1648B.1080709@kernel.org> <20100505165532.GC14323@elte.hu> <1273083173.1642.250.camel@laptop> <1273083396.1642.251.camel@laptop> <20100505183000.GF6320@nowhere> <20100506062855.GD1172@elte.hu>
In-Reply-To: <20100506062855.GD1172@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2010 09:28 AM, Ingo Molnar wrote:
>
> Yep. Also, most of the default distro kernels will have 3 sets of facilities:
>
>   - preempt notifiers
>   - tracepoints
>   - sw events
>
> which is crazy. We can just standardize on using the tracepoint interface
> definition methods - they are properly typed, widespread and well-known enough
> to be perfect for this.
>
> ( They are also under intense optimization - the jump-tracepoints patch makes
>    them probably even cheaper than preempt notifiers, in the off case. )
>
>    

What about the on case?  kvm has preempt notifiers enabled all the time, 
and relies on their being fast.

-- 
error compiling committee.c: too many arguments to function


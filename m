Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab1BPUg6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 15:36:58 -0500
Received: from mail.openrapids.net ([64.15.138.104]:40542 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752544Ab1BPUg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 15:36:56 -0500
Date: Wed, 16 Feb 2011 15:36:53 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Roland McGrath <roland@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Stefan Hajnoczi <stefanha@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Julien Desfossez <julien.desfossez@polymtl.ca>,
        dominique.toupin@ericsson.com, ltt-dev@lists.casi.polymtl.ca,
        systemtap@sources.redhat.com, linux-kernel@vger.kernel.org,
        Jason Baron <jbaron@redhat.com>, hpa@zytor.com, rostedt@goodmis.org,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, sam@ravnborg.org, michael@ellerman.id.au,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: Porting "jump labels" to userspace
Message-ID: <20110216203653.GA2015@Krystal>
References: <4D5AA164.1050607@polymtl.ca> <y0mvd0ltgba.fsf@fche.csb> <AANLkTi=Nsy6fXE9=Njxs9LPHuohHzf=q5kD+fK765Rht@mail.gmail.com> <1297853778.3224.90.camel@springer.wildebeest.org> <20110216185056.CAD7B1806E0@magilla.sf.frob.com> <20110216200034.GA6066@Krystal> <4D5C3024.6040807@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5C3024.6040807@caviumnetworks.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 15:36:22 up 85 days,  1:39,  4 users,  load average: 0.02, 0.02,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Daney (ddaney@caviumnetworks.com) wrote:
> On 02/16/2011 12:00 PM, Mathieu Desnoyers wrote:
> [...]>
>> Actually, creating the equivalent of the jump labels for userspace is on our
>> list of "things to do" for the UST project.
>>
>> If Jason and other jump label contributors agree to dual-license the jump label
>> generic and per-arch implementations under both GPLv2 and LGPLv2.1, we could
>> probably re-use a large part of this code to create a static jump label library
>> for userspace. The concerned authors are precisely: Jason for generic and x86
>> code, Steven for some improvements in generic code and David S. Miller for the
>> sparc port. After things settle down with the current jump label changes
>> proposed by Peter Zijlstra, we might also want to ask for his permission to
>> LGPLize his changes.
>>
> FWIW:  MIPS jump label support is now in as of:
>
> 94bb0c1 (MIPS: jump label: Add MIPS support.)
>
> I would be the author of that.

Sorry David, my tree was a bit outdated from Linus's head :)

Mathieu

>
> David Daney

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com

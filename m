Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab2F1BUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 21:20:33 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:64433 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab2F1BUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 21:20:32 -0400
X-AuditID: 9c930179-b7cceae000004195-c5-4febb15bbe1b
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Avi Kivity <avi@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, kvm@vger.kernel.org,
        dsahern@gmail.com
Subject: Re: [PATCH 2/4] KVM: Use __print_hex() for kvm_emulate_insn tracepoint
References: <1340757701-10711-1-git-send-email-namhyung@kernel.org>
	<1340757701-10711-2-git-send-email-namhyung@kernel.org>
	<1340801375.16702.10.camel@gandalf.stny.rr.com>
	<4FEB0288.5080106@redhat.com>
	<1340803224.16702.12.camel@gandalf.stny.rr.com>
Date: Thu, 28 Jun 2012 10:16:36 +0900
In-Reply-To: <1340803224.16702.12.camel@gandalf.stny.rr.com> (Steven Rostedt's
	message of "Wed, 27 Jun 2012 09:20:24 -0400")
Message-ID: <87bok4z157.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC'ing David]

Hi, Steve

On Wed, 27 Jun 2012 09:20:24 -0400, Steven Rostedt wrote:
> On Wed, 2012-06-27 at 15:54 +0300, Avi Kivity wrote:
>
>> Acked-by: Avi Kivity <avi@redhat.com>
>
> Thanks Avi!
>

Can you give me your ack's too (for this and other ones in the series)?
And if you ok, I can route this and future changes (from anybody) on
libtraceevent through my tree.


>> 
>> Some time ago we discussed moving the trace-cmd plugins to /lib/modules,
>> which would make this trace display as "mov %edx,(%eax)" instead of "89
>> 10", even for non-trace-cmd users.  Was there any movement on this?
>> 
>
> As a matter of fact ;-)  The trace-cmd libparsevent library has now been
> moved to tools/lib/libtraceevent, in which perf now uses. It is just a
> matter of time till perf gets the use of the trace-cmd plugins. We just
> need to figure out the logistics.
>
> Maybe make a tools/event_plugins ?
>
> Or something to that affect?
>

tools/lib/traceevent/plugins ?

Thanks,
Namhyung

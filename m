Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371Ab2F1CDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 22:03:11 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:54383 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261Ab2F1CDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 22:03:09 -0400
X-AuditID: 9c930179-b7cceae000004195-8b-4febbb5b656e
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
	<87bok4z157.fsf@sejong.aot.lge.com>
	<1340848364.16702.56.camel@gandalf.stny.rr.com>
Date: Thu, 28 Jun 2012 10:59:17 +0900
In-Reply-To: <1340848364.16702.56.camel@gandalf.stny.rr.com> (Steven Rostedt's
	message of "Wed, 27 Jun 2012 21:52:44 -0400")
Message-ID: <87y5n8xklm.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2012 21:52:44 -0400, Steven Rostedt wrote:
> On Thu, 2012-06-28 at 10:16 +0900, Namhyung Kim wrote:
>> [CC'ing David]
>> 
>> Hi, Steve
>> 
>> On Wed, 27 Jun 2012 09:20:24 -0400, Steven Rostedt wrote:
>> > On Wed, 2012-06-27 at 15:54 +0300, Avi Kivity wrote:
>> >
>> >> Acked-by: Avi Kivity <avi@redhat.com>
>> >
>> > Thanks Avi!
>> >
>> 
>> Can you give me your ack's too (for this and other ones in the series)?
>> And if you ok, I can route this and future changes (from anybody) on
>> libtraceevent through my tree.
>> 
>
> Actually, as this patch touches x86 and ftrace, and does not truly
> affect the tools directory, I've already added it into my queue for 3.6.
>

Ok, thanks. But how about other ones? Did you add all of 4 into you
queue?

Thanks,
Namhyung

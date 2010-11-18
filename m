Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216Ab0KRJnP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 04:43:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756135Ab0KRJnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 04:43:13 -0500
Message-ID: <4CE4F4FB.7050104@redhat.com>
Date: Thu, 18 Nov 2010 11:42:19 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
        Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC][PATCH 1/5] [PATCH 1/5] events: Add EVENT_FS the event	filesystem
References: <20101117005357.024472450@goodmis.org> <20101117005939.600541101@goodmis.org> <20101117033242.GB31335@suse.de> <20101117103914.GA21976@elte.hu> <1289996753.30543.35.camel@gandalf.stny.rr.com> <20101117174652.GC13717@Krystal> <1290016354.30543.71.camel@gandalf.stny.rr.com> <20101117181222.GB1093@Krystal>
In-Reply-To: <20101117181222.GB1093@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2010 08:12 PM, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> >
> >  I still say no to stable tracepoints in modules. Once you open that
> >  door, everyone will have it.
> >
> >  But, that doesn't mean that a raw traepoint can't be stable. If the
> >  maintainer of that tracepoint states it is stable, then by all means,
> >  let tools use it.
>
> I'd really like to hear Avi's thoughts on this.

Steven's scheme is fine with me.  (kvm tracepoints are more or less 
stable, but all tools so far read the tracepoint definitions 
dynamically, and can cope with tracepoints being added/changed/removed).

-- 
error compiling committee.c: too many arguments to function


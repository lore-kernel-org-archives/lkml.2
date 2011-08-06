Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab1HFXOg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 19:14:36 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55127 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab1HFXOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 19:14:34 -0400
MIME-Version: 1.0
In-Reply-To: <1312666815.18583.221.camel@gandalf.stny.rr.com>
References: <CAGZ=bq+mJ-9pf0Y22b9LLey0Em2Y7SAA5FnQ5cPsde6GB_aqgw@mail.gmail.com>
 <1312666815.18583.221.camel@gandalf.stny.rr.com>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Sat, 6 Aug 2011 19:14:13 -0400
Message-ID: <CAGZ=bqLcxs8vXiujFTrVzA-N2LKv-Q0aV2C=AgRcpKKBQ5SADA@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/8] Having perf use libparsevent.a
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 6, 2011 at 17:40, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Sat, 2011-08-06 at 14:47 -0400, Kyle Moffett wrote:
>> On Aug 6, 2011 11:35 AM, "Steven Rostedt" <rostedt@goodmis.org> wrote:
>>> On Sat, 2011-08-06 at 09:16 -0600, David Ahern wrote:
>>>> If the library is just for parsing trace events why not call it
>>>> libtraceparse or libtrace? This isn't perf specific functionality.
>>>
>>> Actually, I'm thinking libevents would probably be most appropriate.
>>> It has less to do with perf in general, and more about events. Even
>>> reading the events goes under this category.
>>
>> Ooh, please don't... "libevent" is already an epoll() event-based
>> application helper library and this would be overly confusing.
>
> OK, what about libkevent, as this has to do with kernel events.

Hmm, well "kevent()" is a BSD syscall that does the same kinds of things
as "epoll()" does on Linux.  It's used by libevent, in fact.

Maybe "libkernevent"?  A quick google doesn't find anything problematic
there...  Other options with minimal chance of confusion are:
  libkernelevent
  liblinuxevent
  libinuxevent (Linked with option "-linuxevent")

To be honest I don't really see anything wrong with a name involving
"trace"...  Perhaps something like libevtrace/libtraceevent/etc?

Cheers,
Kyle Moffett

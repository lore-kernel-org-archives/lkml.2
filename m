Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250Ab1HHJee (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 05:34:34 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:58959 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034Ab1HHJec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 05:34:32 -0400
MIME-Version: 1.0
In-Reply-To: <1312666815.18583.221.camel@gandalf.stny.rr.com>
References: <CAGZ=bq+mJ-9pf0Y22b9LLey0Em2Y7SAA5FnQ5cPsde6GB_aqgw@mail.gmail.com>
	<1312666815.18583.221.camel@gandalf.stny.rr.com>
Date: Mon, 8 Aug 2011 17:34:31 +0800
Message-ID: <CAM_iQpXwvP1S_cPtME5wYRZ5BkGNPebrCU2D6g4Mosse6md+rQ@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/8] Having perf use libparsevent.a
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Kyle Moffett <kyle@moffetthome.net>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
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

On Sun, Aug 7, 2011 at 5:40 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Sat, 2011-08-06 at 14:47 -0400, Kyle Moffett wrote:
>> On Aug 6, 2011 11:35 AM, "Steven Rostedt" <rostedt@goodmis.org> wrote:
>> >
>> > On Sat, 2011-08-06 at 09:16 -0600, David Ahern wrote:
>> >
>> > > If the library is just for parsing trace events why not call it
>> > > libtraceparse or libtrace? This isn't perf specific functionality.
>> >
>> > Actually, I'm thinking libevents would probably be most appropriate.
>> It
>> > has less to do with perf in general, and more about events. Even
>> reading
>> > the events goes under this category.
>>
>> Ooh, please don't... "libevent" is already an epoll() event-based
>> application helper library and this would be overly confusing.
>
> OK, what about libkevent, as this has to do with kernel events.
>

libkevent is still too generic, how about libtraceevent?

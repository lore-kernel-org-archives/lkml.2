Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771Ab1HFVkV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 17:40:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:44519 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148Ab1HFVkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 17:40:19 -0400
X-Authority-Analysis: v=1.1 cv=Pm0sEXe2MdIPK/rOEC7hwDW84D/yDsPO3JtCzsVYOFU= c=1 sm=0 a=JVmKiHRY1FkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=28TUnXNLkGfExS-8OngA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 0/8] Having perf use libparsevent.a
From: Steven Rostedt <rostedt@goodmis.org>
To: Kyle Moffett <kyle@moffetthome.net>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
In-Reply-To: <CAGZ=bq+mJ-9pf0Y22b9LLey0Em2Y7SAA5FnQ5cPsde6GB_aqgw@mail.gmail.com>
References: <CAGZ=bq+mJ-9pf0Y22b9LLey0Em2Y7SAA5FnQ5cPsde6GB_aqgw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sat, 06 Aug 2011 17:40:15 -0400
Message-ID: <1312666815.18583.221.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-08-06 at 14:47 -0400, Kyle Moffett wrote:
> On Aug 6, 2011 11:35 AM, "Steven Rostedt" <rostedt@goodmis.org> wrote:
> >
> > On Sat, 2011-08-06 at 09:16 -0600, David Ahern wrote:
> >
> > > If the library is just for parsing trace events why not call it
> > > libtraceparse or libtrace? This isn't perf specific functionality.
> >
> > Actually, I'm thinking libevents would probably be most appropriate.
> It
> > has less to do with perf in general, and more about events. Even
> reading
> > the events goes under this category.
> 
> Ooh, please don't... "libevent" is already an epoll() event-based
> application helper library and this would be overly confusing.

OK, what about libkevent, as this has to do with kernel events.

-- Steve



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579Ab0KJPJq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 10:09:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:63723 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756489Ab0KJPJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 10:09:45 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=2Zzf6Ss2cq4A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=IytSkmhflcfRvnpANeIA:9 a=cg-_anD8Fw_IKkNTiAUA:7 a=ljD0WotEofgNRXhofq8hhJPhbo8A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC/Requirements/Design] h/w error reporting
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, "Luck, Tony" <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org, ying.huang@intel.com, bp@alien8.de,
        tglx@linutronix.de, akpm@linux-foundation.org, mchehab@redhat.com,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <1289400234.2191.129.camel@laptop>
References: <4cd9edd7543527b78@agluck-desktop.sc.intel.com>
	 <20101110101450.GA18481@elte.hu>
	 <1289400056.12418.139.camel@gandalf.stny.rr.com>
	 <1289400234.2191.129.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 10 Nov 2010 10:09:41 -0500
Message-ID: <1289401781.12418.145.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-10 at 15:43 +0100, Peter Zijlstra wrote:
> On Wed, 2010-11-10 at 09:40 -0500, Steven Rostedt wrote:
> > The second option was agreed upon by myself, Thomas, Frederic, and
> > Peter, and it was OK'd by Linus.
> > 
> > What do you think about it? 
> 
> I would still like to see lots more detail before we commit to anything,

Keeping it out of tree means we don't commit to anything :-)

> sure the second way is the only way out, but you still need to come up
> with a trace data format and a control ABI.

Great! Let's start with that then. Could you list some of the basic
needs of perf? And then I can start talking about what I need for
ftrace, and we also should keep in mind things we may want to do in the
future.

> 
> Without those its pretty pointless to even talk about stuff.

Agreed, but we really do want to find a way out, thus lets start the
conversation. Basically, start from square one. We now have both ftrace
and perf, and we know what we need. We can start working on something
with both in mind, and perhaps keeping track of other things.

I added Mathieu too. I know to you LTTng does not exist, but he can at
least give ideas about something we may not have thought about and may
want to do in the future.

-- Steve




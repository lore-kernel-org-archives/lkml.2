Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070Ab1DHOIu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 10:08:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:44556 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757012Ab1DHOIs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 10:08:48 -0400
Subject: Re: [RFC] tracing: Adding cgroup aware tracing functionality
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Stephane Eranian <eranian@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Rubin <mrubin@google.com>, Ken Chen <kenchen@google.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <20110408134537.GA1967@nowhere>
References: <BANLkTik_jtjWTsOueUzfdQXRx17OcgyDgA@mail.gmail.com>
	 <20110407013349.GH1867@nowhere>
	 <BANLkTinKsYqkEEUu98t+Gn9ciPn_bmsMFQ@mail.gmail.com>
	 <20110407120608.GB1798@nowhere>
	 <BANLkTim70Ef0gy+W+4h76PABn32wDRvTtw@mail.gmail.com>
	 <20110407213208.GE1798@nowhere>
	 <BANLkTimOvWYgiRc6cviB6iiUt9MH-Au1qw@mail.gmail.com>
	 <20110408002812.GG1798@nowhere> <1302248268.21026.18.camel@frodo>
	 <20110408134537.GA1967@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 08 Apr 2011 16:07:52 +0200
Message-ID: <1302271672.9086.155.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-08 at 15:45 +0200, Frederic Weisbecker wrote:
> 
> I bet this idea is not controversial. What has yet to be solved is
> the debate on the writers that can run in overwriting mode at the same
> time we have readers. Which comes along debates on using subbuffers,
> etc..
> 
> But I guess we can solve that along the way? 

Dunno, but the much larger point is how ftrace is going to want to do
multiple sessions and keep session context etc (what events to where).
I've only heard some vague hand waving there but never heard anything
concrete.



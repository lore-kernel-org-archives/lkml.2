Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933254Ab0GUCnL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 22:43:11 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:57720 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932940Ab0GUCnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 22:43:10 -0400
Date: Wed, 21 Jul 2010 08:12:00 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCHv9 2.6.35-rc4-tip 0/13]  Uprobes Patches:
Message-ID: <20100721024200.GC19375@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100712103214.27491.15142.sendpatchset@localhost6.localdomain6>
 <20100720041938.GA28533@infradead.org>
 <20100720063805.GA19375@linux.vnet.ibm.com>
 <20100720210358.GA17631@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100720210358.GA17631@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Em Tue, Jul 20, 2010 at 12:08:05PM +0530, Srikar Dronamraju escreveu:
> > > A minor note on perf probe -S output:  This seems to include a lot of
> > > T.456 or similar labels, which from my recollection are gcc internal
> > > things.  It would be good to filter those out as they aren't quite
> > > useful and just fill up the list.
> > 
> > Okay .. will take a look. Offhand I dont know about the T.456
> > labels, so I will google and see if its possible for us to identify if
> > its a t.456 label. However if you know how to identify a t456 label
> > from normal functions, then it would be great.
> 
> We may have some hint on the symtab, having access to one of those files
> to look at its symtab will help.

I tried searching for t.456 gcc labels in google. I dont think I found
anything interesting. Are we looking at not listing symbols that end
with @plt? Can you please list an example t.456 label. Also any pointers to
where I can find more information on the same would be very useful.

-Srikar

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311Ab0GUNXM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 09:23:12 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:58363 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab0GUNXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 09:23:10 -0400
Date: Wed, 21 Jul 2010 18:51:47 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
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
Message-ID: <20100721132147.GB4290@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100712103214.27491.15142.sendpatchset@localhost6.localdomain6>
 <20100720041938.GA28533@infradead.org>
 <20100720063805.GA19375@linux.vnet.ibm.com>
 <20100720210358.GA17631@ghostprotocols.net>
 <20100721024200.GC19375@linux.vnet.ibm.com>
 <1279717690.4818.31.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1279717690.4818.31.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt <rostedt@goodmis.org> [2010-07-21 09:08:10]:

> On Wed, 2010-07-21 at 08:12 +0530, Srikar Dronamraju wrote:
> 
> > I tried searching for t.456 gcc labels in google. I dont think I found
> > anything interesting. Are we looking at not listing symbols that end
> > with @plt? Can you please list an example t.456 label. Also any pointers to
> > where I can find more information on the same would be very useful.
> 
> I'm not sure you'll find anything looking for "t.456" since that is just
> a random label that gcc created for its internal use. But I believe that
> all of these temp labels have a '.' in them. Thus, you can just ignore
> all labels with '.'.
> 
> 

Thanks a lot for confirming this. I did some digging and was thinking that may
be .L<blah><blah> were the ones that Christoph was referring.

--
Thanks and Regards
Srikar


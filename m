Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab0HBIBS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 04:01:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53635 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab0HBIBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 04:01:16 -0400
Date: Mon, 2 Aug 2010 04:00:32 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCHv10 2.6.35-rc6-tip 9/14]  trace: uprobes trace_event
 interface
Message-ID: <20100802080032.GA12078@infradead.org>
References: <20100727110855.24690.26901.sendpatchset@localhost6.localdomain6>
 <20100727111045.24690.31897.sendpatchset@localhost6.localdomain6>
 <4C510BCE.4010704@hitachi.com>
 <20100802022055.GB5581@nowhere>
 <4C563F44.9080300@hitachi.com>
 <20100802074619.GA5292@nowhere>
 <20100802075637.GB24085@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100802075637.GB24085@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 09:56:37AM +0200, Ingo Molnar wrote:
> > > Hmm, I disagree with it, because both Kprobes and Uprobes provides
> > > APIs for modules too.
> > 
> > I'm not sure there is a point in maintaining a leightweight version for out 
> > of tree code. These modules could just select kprobes/uprobes events as 
> > well.
> > 
> > As you prefer, that was just a suggestion to make it more simple.
> 
> The upstream policy always was that out of tree code does not exist as far as 
> the kernel is concerned. So it is wrong to make the kernel crappier while 
> helping out of tree code.

Indeed.  In addition to that the current version of uprobes does not
actually have any exported symbols.


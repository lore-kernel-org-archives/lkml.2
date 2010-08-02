Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab0HBJgq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 05:36:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36396 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669Ab0HBJgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 05:36:45 -0400
Date: Mon, 2 Aug 2010 05:36:06 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        2nddept-manager@sdl.hitachi.co.jp,
        SystemTAP <systemtap@sources.redhat.com>
Subject: Re: [PATCHv10 2.6.35-rc6-tip 9/14]  trace: uprobes trace_event
 interface
Message-ID: <20100802093606.GA13697@infradead.org>
References: <20100727110855.24690.26901.sendpatchset@localhost6.localdomain6>
 <20100727111045.24690.31897.sendpatchset@localhost6.localdomain6>
 <4C510BCE.4010704@hitachi.com>
 <20100802022055.GB5581@nowhere>
 <4C563F44.9080300@hitachi.com>
 <20100802074619.GA5292@nowhere>
 <20100802075637.GB24085@elte.hu>
 <20100802080032.GA12078@infradead.org>
 <4C568FF7.9070300@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C568FF7.9070300@hitachi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 06:29:27PM +0900, Masami Hiramatsu wrote:
> So, that could be a bug.
> 
> Anyway, at least kprobes has some sample modules under samples/kprobes/.
> Aren't they in-tree consumers of kprobes?

We have quite a few kprobes users in the kernel, just no really useful
modular ones.  We have a couple of useful users of jprobes, which are
the more useful kprobes variants in modules.  All of them might better
be converted to trace events, but those weren't around when they were
added.


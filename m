Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396Ab1FGOVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 10:21:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35781 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab1FGOVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 10:21:41 -0400
Date: Tue, 7 Jun 2011 11:21:16 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hugh Dickins <hughd@google.com>, Andi Kleen <andi@firstfloor.org>,
        Thomas Gleixner <tglx@linutronix.de>, Jonathan Corbet <corbet@lwn.net>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3.0-rc2-tip 20/22] 20: perf: perf interface for uprobes
Message-ID: <20110607142116.GA8311@ghostprotocols.net>
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6>
 <20110607130216.28590.5724.sendpatchset@localhost6.localdomain6>
 <20110607133039.GA4929@infradead.org>
 <20110607133853.GC9949@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110607133853.GC9949@in.ibm.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jun 07, 2011 at 07:08:53PM +0530, Ananth N Mavinakayanahalli escreveu:
> On Tue, Jun 07, 2011 at 09:30:39AM -0400, Christoph Hellwig wrote:
> > On Tue, Jun 07, 2011 at 06:32:16PM +0530, Srikar Dronamraju wrote:
> > > Enhances perf probe to user space executables and libraries.
> > > Provides very basic support for uprobes.

> > Nice.  Does this require full debug info for symbolic probes,
> > or can it also work with simple symbolc information?
 
> It works only with symbol information for now.
> It doesn't (yet) know how to use debuginfo :-)

'perf probe' uses perf symbol library, so it really don't have to know
from where symbol resolution information is obtained, only if it needs
things that are _just_ on debuginfo, such as line information, etc.

But then that is also already supported in 'perf probe'.

Or is there something else in particular you're thinking?

- Arnaldo

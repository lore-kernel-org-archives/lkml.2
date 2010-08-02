Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922Ab0HBO44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 10:56:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41340 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab0HBO4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 10:56:55 -0400
Date: Mon, 2 Aug 2010 11:56:36 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCHv10 2.6.35-rc6-tip 11/14]  perf: perf interface for uprobes
Message-ID: <20100802145636.GI12166@ghostprotocols.net>
References: <20100727110855.24690.26901.sendpatchset@localhost6.localdomain6>
 <20100727111105.24690.48335.sendpatchset@localhost6.localdomain6>
 <20100730191903.GD12166@ghostprotocols.net>
 <20100802122714.GC22812@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100802122714.GC22812@linux.vnet.ibm.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Aug 02, 2010 at 05:57:14PM +0530, Srikar Dronamraju escreveu:
> Hi Arnaldo, 
> 
> 
> > 
> > The following three hunks could be moved to a separate patch that I'd
> > apply on my perf/core branch, so to reduce this patchset size, like I
> > did with the s/kprobe/probe/g one that is already there:
> > 
> > http://git.kernel.org/?p=linux/kernel/git/acme/linux-2.6.git;a=commitdiff;h=0e60836bbd392300198c5c2d918c18845428a1fe
> 
> I will soon 2 patches instead of this patch splitting the 3 hunks into
> a new patch and the resuting patch after removing the previous 3 hunks.

Thanks, I'm just trying to erode the patchset by merging the completely
uncontentious hunks. :)

- Arnaldo

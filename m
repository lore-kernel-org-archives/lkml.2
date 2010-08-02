Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab0HBM3e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 08:29:34 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:48826 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310Ab0HBM3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 08:29:33 -0400
Date: Mon, 2 Aug 2010 17:57:14 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
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
Subject: Re: [PATCHv10 2.6.35-rc6-tip 11/14]  perf: perf interface for
 uprobes
Message-ID: <20100802122714.GC22812@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100727110855.24690.26901.sendpatchset@localhost6.localdomain6>
 <20100727111105.24690.48335.sendpatchset@localhost6.localdomain6>
 <20100730191903.GD12166@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100730191903.GD12166@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo, 


> 
> The following three hunks could be moved to a separate patch that I'd
> apply on my perf/core branch, so to reduce this patchset size, like I
> did with the s/kprobe/probe/g one that is already there:
> 
> http://git.kernel.org/?p=linux/kernel/git/acme/linux-2.6.git;a=commitdiff;h=0e60836bbd392300198c5c2d918c18845428a1fe

I will soon 2 patches instead of this patch splitting the 3 hunks into
a new patch and the resuting patch after removing the previous 3 hunks.

-Srikar

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255Ab1KXONb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 09:13:31 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:59725 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab1KXONa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 09:13:30 -0500
Date: Thu, 24 Nov 2011 19:07:35 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>, tulasidhard@gmail.com
Subject: Re: [PATCH v7 3.2-rc2 4/30] uprobes: Define hooks for mmap/munmap.
Message-ID: <20111124133735.GG28065@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
 <20111118110723.10512.66282.sendpatchset@srdronam.in.ibm.com>
 <1322072149.14799.89.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1322072149.14799.89.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11112414-7408-0000-0000-0000010AF301
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2011-11-23 19:15:49]:

> On Fri, 2011-11-18 at 16:37 +0530, Srikar Dronamraju wrote:
> > @@ -545,8 +547,14 @@ again:                     remove_next = 1 + (end > next->vm_end);
> 
> I'm not sure if you use quilt or git to produce these patches but can
> you either add:
> 
> QUILT_DIFF_OPTS="-F ^[[:alpha:]\$_].*[^:]\$"
> 
> to your .quiltrc, or:
> 
> [diff "default"]
>                 xfuncname = "^[[:alpha:]$_].*[^:]$"

I use stgit 
You had suggested this to me earlier, and I have it my ~/.gitconfig


[diff "default"]
        xfuncname = "^[[:alpha:]$_].*[^:]$"


 stg version 
 Stacked GIT 0.15
 git version 1.7.1
 Python version 2.6.6 (r266:84292, Apr 11 2011, 15:50:32) 
 [GCC 4.4.4 20100726 (Red Hat 4.4.4-13)]

One thing that I might be doing differently is 

I do a "stg export" before using sendpatchset to mail the patches.

-- 
Thanks and Regards
Srikar


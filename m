Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932990Ab1JXQM1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 12:12:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15473 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932874Ab1JXQMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 12:12:23 -0400
Date: Mon, 24 Oct 2011 18:07:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 11/X] uprobes: x86: introduce xol_was_trapped()
Message-ID: <20111024160732.GA19659@redhat.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com> <20111015190007.GA30243@redhat.com> <20111019215139.GA16395@redhat.com> <20111019215307.GE16395@redhat.com> <20111024145531.GB31435@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111024145531.GB31435@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24, Srikar Dronamraju wrote:
>
> > diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
> > index 1c30cfd..f0fbdab 100644
> > --- a/arch/x86/include/asm/uprobes.h
> > +++ b/arch/x86/include/asm/uprobes.h
> > @@ -39,6 +39,7 @@ struct uprobe_arch_info {
> >
> >  struct uprobe_task_arch_info {
> >  	unsigned long saved_scratch_register;
> > +	unsigned long saved_trap_no;
> >  };
> >  #else
> >  struct uprobe_arch_info {};
>
>
> one nit
> I had to add saved_trap_no to #else part (i.e uprobe_arch_info ).

Yes, thanks, I didn't notice this is for X86_64 only.

And just in case, please feel free to rename/redo/whatever.

Oleg.


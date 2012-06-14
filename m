Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab2FNIoF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 04:44:05 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:51332 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755315Ab2FNIoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 04:44:01 -0400
Date: Thu, 14 Jun 2012 14:13:00 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] uprobes: don't use loff_t for the valid virtual
	address
Message-ID: <20120614084300.GC9089@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20120613184933.GA13870@redhat.com> <20120613185106.GE13878@redhat.com> <20120614052430.GA9089@in.ibm.com> <20120614083826.GA2964@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120614083826.GA2964@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061408-8974-0000-0000-00000A0FE677
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 10:38:26AM +0200, Ingo Molnar wrote:
> 
> * Ananth N Mavinakayanahalli <ananth@in.ibm.com> wrote:
> 
> > On Wed, Jun 13, 2012 at 08:51:06PM +0200, Oleg Nesterov wrote:
> > > loff_t looks confusing when it is used for the virtual address.
> > > Change map_info and install_breakpoint/remove_breakpoint paths
> > > to use "unsigned long".
> > > 
> > > The patch doesn't change vma_address(), it can't return "long"
> > > because it is used to verify the mapping. But probably this
> > > needs some cleanups too.
> > 
> > Oleg,
> > 
> > As you mentioned in another email, this conflicts with my 
> > [1/2] preparatory patch for the powerpc port. [...]
> 
> Note, I already merged your preparatory patch into tip:perf/core 
> a couple of days ago:
> 
>  7eb9ba5ed312 uprobes: Pass probed vaddr to arch_uprobe_analyze_insn()
> 
> So as long as Oleg is working on top of -tip there should be no 
> conflict.

Ah.. thanks Ingo. I missed that tip commit email.

Ananth


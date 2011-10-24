Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932975Ab1JXPSI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 11:18:08 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:60483 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932910Ab1JXPSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 11:18:04 -0400
Date: Mon, 24 Oct 2011 20:25:31 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
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
Message-ID: <20111024145531.GB31435@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com>
 <20111015190007.GA30243@redhat.com>
 <20111019215139.GA16395@redhat.com>
 <20111019215307.GE16395@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20111019215307.GE16395@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11102415-7408-0000-0000-000000505626
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
> index 1c30cfd..f0fbdab 100644
> --- a/arch/x86/include/asm/uprobes.h
> +++ b/arch/x86/include/asm/uprobes.h
> @@ -39,6 +39,7 @@ struct uprobe_arch_info {
> 
>  struct uprobe_task_arch_info {
>  	unsigned long saved_scratch_register;
> +	unsigned long saved_trap_no;
>  };
>  #else
>  struct uprobe_arch_info {};


one nit
I had to add saved_trap_no to #else part (i.e uprobe_arch_info ). 

--
Thanks and Regards
Srikar


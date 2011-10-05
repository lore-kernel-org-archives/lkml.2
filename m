Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934975Ab1JEQaD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 12:30:03 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:43570 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934476Ab1JEQaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 12:30:01 -0400
Date: Wed, 5 Oct 2011 21:42:39 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 3.1.0-rc4-tip 8/26]   x86: analyze instruction and
 determine fixups.
Message-ID: <20111005161239.GA28250@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com>
 <20110920120127.25326.71509.sendpatchset@srdronam.in.ibm.com>
 <20111005154838.GA31953@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20111005154838.GA31953@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2011-10-05 17:48:38]:

> On 09/20, Srikar Dronamraju wrote:
> >
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -250,6 +250,9 @@ config ARCH_CPU_PROBE_RELEASE
> >  	def_bool y
> >  	depends on HOTPLUG_CPU
> >
> > +config ARCH_SUPPORTS_UPROBES
> > +	def_bool y
> > +
> 
> It seems you should also change the INSTRUCTION_DECODER entry.

Okay will do.

-- 
Thanks and Regards
Srikar

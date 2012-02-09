Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab2BII1I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 03:27:08 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:39397 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744Ab2BII1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 03:27:06 -0500
Date: Thu, 9 Feb 2012 13:44:51 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, yrl.pp-manager.tt@hitachi.com
Subject: Re: Re: [PATCH v10 3.3-rc2 1/9] uprobes: Install and remove
 breakpoints.
Message-ID: <20120209081451.GC16600@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120202141840.5967.39687.sendpatchset@srdronam.in.ibm.com>
 <20120202141851.5967.68000.sendpatchset@srdronam.in.ibm.com>
 <20120207171707.GA24443@linux.vnet.ibm.com>
 <CAK1hOcOd3hd31vZYw1yAVGK=gMV=vQotL1mRZkVgM=7M8mbMyw@mail.gmail.com>
 <4F3320E5.1050707@hitachi.com>
 <20120209063745.GB16600@linux.vnet.ibm.com>
 <20120209075357.GD18387@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120209075357.GD18387@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020908-5930-0000-0000-000004EDF6AC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar <mingo@elte.hu> [2012-02-09 08:53:57]:

> 
> * Srikar Dronamraju <srikar@linux.vnet.ibm.com> wrote:
> 
> > 	/* Clear REX.b bit (extension of MODRM.rm field):
> > 	 * we want to encode rax/rcx, not r8/r9.
> > 	 */
> 
> Small stylistic nit, just saw this chunk fly by - the proper 
> comment style is like this one:

Okay, Will correct that in the patch that I send.


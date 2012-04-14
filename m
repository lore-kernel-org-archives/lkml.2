Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab2DNLMN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 07:12:13 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:50934 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499Ab2DNLMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 07:12:12 -0400
Date: Sat, 14 Apr 2012 13:12:06 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Oleg Nesterov <oleg@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Anton Arapov <anton@redhat.com>
Subject: Re: [PATCH UPDATED 3/3] tracing: Provide trace events interface for
 uprobes
Message-ID: <20120414111206.GA24688@gmail.com>
References: <20120409091133.8343.65289.sendpatchset@srdronam.in.ibm.com>
 <20120409091154.8343.50489.sendpatchset@srdronam.in.ibm.com>
 <20120411103043.GB29437@linux.vnet.ibm.com>
 <1334236456.23924.333.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334236456.23924.333.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> I'm fine with what I see here (still need to fix what Masami 
> suggested).
> 
> Acked-by: Steven Rostedt <rostedt@goodmis.org>

Ok - Srikar, mind sending the latest (3-patch?) series again, 
with all suggestions and acks incorporated?

Thanks,

	Ingo

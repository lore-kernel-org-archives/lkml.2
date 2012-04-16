Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab2DPJaq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 05:30:46 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:44829 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab2DPJap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 05:30:45 -0400
Date: Mon, 16 Apr 2012 14:52:27 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
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
Subject: Re: [PATCH UPDATED 3/3] tracing: Provide trace events interface
 for uprobes
Message-ID: <20120416092227.GD13363@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120409091133.8343.65289.sendpatchset@srdronam.in.ibm.com>
 <20120409091154.8343.50489.sendpatchset@srdronam.in.ibm.com>
 <20120411103043.GB29437@linux.vnet.ibm.com>
 <1334236456.23924.333.camel@gandalf.stny.rr.com>
 <20120414111206.GA24688@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120414111206.GA24688@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041609-1780-0000-0000-000004CABE55
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000269; HX=3.00000187; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00131337; UDB=6.00030937; UTC=2012-04-16
 09:30:43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar <mingo@kernel.org> [2012-04-14 13:12:06]:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > I'm fine with what I see here (still need to fix what Masami 
> > suggested).
> > 
> > Acked-by: Steven Rostedt <rostedt@goodmis.org>
> 
> Ok - Srikar, mind sending the latest (3-patch?) series again, 
> with all suggestions and acks incorporated?
> 

Just sent out the 3 patches incorporation all suggestions including the
last one from Stephen Boyd.

-- 
Thanks and Regards
Srikar


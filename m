Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759201Ab2EWKC6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 06:02:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16965 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758759Ab2EWKC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 06:02:57 -0400
X-Authority-Analysis: v=2.0 cv=cssZYiEi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=FcrDmSi3BesA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=mbOLb1LPTvekLa0R-5AA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337767375.13348.148.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 3/3] tracing: Provide traceevents interface for uprobes
From: Steven Rostedt <rostedt@goodmis.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
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
Date: Wed, 23 May 2012 06:02:55 -0400
In-Reply-To: <20120523095738.GA15587@linux.vnet.ibm.com>
References: <20120403010442.17852.9888.sendpatchset@srdronam.in.ibm.com>
	 <20120403010502.17852.58528.sendpatchset@srdronam.in.ibm.com>
	 <1337764783.13348.142.camel@gandalf.stny.rr.com>
	 <20120523095738.GA15587@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 15:27 +0530, Srikar Dronamraju wrote:

> Masami already acked the patches and its now part of the -tip tree.
> 
> and these patches got picked into -tip  on May 7 
> 
> f3f096c tracing: Provide trace events interface for uprobes
> 8ab83f5 tracing: Extract out common code for kprobes/uprobes trace events
> 3a6b766 tracing: Modify is_delete, is_return from int to bool

Yeah, I noticed shortly after I replied. I currently can't sleep (been
up since 3:30am EDT), and have been cleaning out my Inbox. I got
confused when I saw these patches marked as "todo" in my folder.

-- Steve




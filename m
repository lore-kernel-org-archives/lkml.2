Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680Ab2EHJCK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 05:02:10 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:51532 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab2EHJCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 05:02:08 -0400
Date: Tue, 8 May 2012 14:20:02 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Oleg Nesterov <oleg@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Anton Arapov <anton@redhat.com>
Subject: Re: [PATCH UPDATED 3/3] tracing: Provide trace events interface
 for uprobes
Message-ID: <20120508085002.GA13272@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120409091133.8343.65289.sendpatchset@srdronam.in.ibm.com>
 <20120409091154.8343.50489.sendpatchset@srdronam.in.ibm.com>
 <20120411103043.GB29437@linux.vnet.ibm.com>
 <20120508041229.GD30652@gmail.com>
 <1336465808.16236.13.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1336465808.16236.13.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12050809-2398-0000-0000-000006741700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2012-05-08 10:30:08]:

> On Tue, 2012-05-08 at 06:12 +0200, Ingo Molnar wrote:
> > FYI, this warning started to trigger in -tip, with the latest 
> > uprobes patches:
> > 
> > warning: (UPROBE_EVENT) selects UPROBES which has unmet direct dependencies (UPROBE_EVENTS && PERF_EVENTS)
> 
> this looks to be the only UPROBE_EVENTS instance, is that a typo?


I think I corrected this in the latest posting I sent on April 16th.

Ingo,

	Since you had asked me to send the patch series again after
handling comments and acks, I had sent the set. At that time, I had
handled this change as part of a comment from Stephen Boyd.  I had
mentioned this in the changelog.

	Would it be possible for you to accept the patches from 
https://lkml.org/lkml/2012/4/16/109
with message id: 
Message-Id: <20120416091936.19174.2641.sendpatchset@srdronam.in.ibm.com> 

Currently you seem to have picked from 
https://lkml.org/lkml/2012/4/11/117

--
Thanks and Regards
Srikar


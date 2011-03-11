Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab1CKJkT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 04:40:19 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:36357 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998Ab1CKJkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 04:40:15 -0500
Date: Fri, 11 Mar 2011 15:05:12 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Tejun Heo <tj@kernel.org>,
        Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        jan.kratochvil@redhat.com, Denys Vlasenko <vda.linux@googlemail.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [RFC] Proposal for ptrace improvements
Message-ID: <20110311093512.GA1815@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110301152457.GE26074@htj.dyndns.org>
 <20110307204346.19557183C29@magilla.sf.frob.com>
 <20110309102855.GC27010@htj.dyndns.org>
 <20110310183305.GD12521@home.goodmis.org>
 <20110311082240.GA7624@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20110311082240.GA7624@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > I don't think perf has a good way to trace userspace yet.
> 
> uprobes are being worked on (and that comes integrated with perf), and that will 
> give a good mechanism - and it (of course) wont be doing any context-switching.
> 

> Peter might be able to fill us in on the details of the review progress of the 
> uprobes patches.

Just an update on uprobes.
I am currently testing my next version of uprobes and I should be
sending it out for review next monday.


-- 
Thanks and Regards
Srikar

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330Ab1COLn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 07:43:57 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:45318 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755392Ab1COLnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 07:43:55 -0400
Date: Tue, 15 Mar 2011 17:07:56 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Frank Ch. Eigler" <fche@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, int-list-linux-mm@kvack.org,
        linux-mm@kvack.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        SystemTap <systemtap@sources.redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 2.6.38-rc8-tip 0/20] 0: Inode based uprobes
Message-ID: <20110315113756.GX24254@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
 <20110314163028.a05cec49.akpm@linux-foundation.org>
 <y0maagxuqx6.fsf@fche.csb>
 <alpine.LFD.2.00.1103150224260.2787@localhost6.localdomain6>
 <20110315052133.GT24254@linux.vnet.ibm.com>
 <alpine.LFD.2.00.1103151158220.2787@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1103151158220.2787@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > uprobes and then draft a proposal for how the syscall should look. 
> > There are still some areas on how we should be allowing the
> > filter, and what restrictions we should place on the syscall
> > defined handler. I would like to hear from you and others on your
> > ideas for the same. If you have ideas on doing it other than using a
> > syscall then please do let me know about the same.
> 
> I don't think that anything else than a proper syscall interface is
> going to work out.

Okay, 

> 
> > I know that getting the user interface right is very important.
> > However I think it kind of depends on what the infrastructure can
> > provide too. So if we can decide on the kernel ABI and the
> > underlying design (i.e can we use replace_page() based background page
> > replacement, Are there issues with the Xol slot based mechanism that
> > we are using, etc), we can work towards providing a stable User ABI that
> > even normal users can use. For now I am concentrating on getting the
> > underlying infrastructure correct.
> 
> Fair enough. I'll go through the existing patchset and comment there.
> 

Thanks for taking a look at the code. Look forward for your
comments.

-- 
Thanks and Regards
Srikar

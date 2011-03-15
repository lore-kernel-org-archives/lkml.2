Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221Ab1COSGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 14:06:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58003 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756478Ab1COSGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 14:06:43 -0400
Date: Tue, 15 Mar 2011 19:06:39 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        SystemTap <systemtap@sources.redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 2.6.38-rc8-tip 0/20] 0: Inode based uprobes
Message-ID: <20110315180639.GQ2499@one.firstfloor.org>
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6> <20110314163028.a05cec49.akpm@linux-foundation.org> <20110314234754.GP2499@one.firstfloor.org> <alpine.LFD.2.00.1103150114590.2787@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1103150114590.2787@localhost6.localdomain6>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

> That's a brilliant reason to drop it right away. systemtap is the
> least of our worries.

Feeling defensive about something?

> 
> > How do you envisage these features actually get used?  For example,
> > will gdb be modified?  Will other debuggers be modified or written?
> 
> How about answering this question first _BEFORE_ advertising
> systemtap?

I thought this was obvious.  systemtap is essentially a script driven 
debugger. 

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

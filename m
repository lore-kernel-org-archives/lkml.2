Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab1AZPZW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 10:25:22 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:47276 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753295Ab1AZPZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 10:25:21 -0500
Date: Wed, 26 Jan 2011 20:48:42 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC] [PATCH 2.6.37-rc5-tip 4/20]  4: uprobes: Adding and
 remove a uprobe in a rb tree.
Message-ID: <20110126151842.GM19725@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
 <20101216095803.23751.41491.sendpatchset@localhost6.localdomain6>
 <1295963773.28776.1054.camel@laptop>
 <20110126084522.GF19725@linux.vnet.ibm.com>
 <1296036847.28776.1142.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1296036847.28776.1142.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2011-01-26 11:14:07]:

> On Wed, 2011-01-26 at 14:15 +0530, Srikar Dronamraju wrote:
> > 
> > 
> > Okay, Will do, but Is there a reason for moving the fvalue out of the
> > uprobe_consumer? Except for reducing the size of the structure, I am
> > unable to see advantage. 
> 
> That's about it, and its the normal way to do such things in kernel
> space.

But the disadvantage would be we wont be able to share the filter
functions. Currently i had one patch that implemented the common
filter functions that tracers could reuse.

-- 
Thanks and Regards
Srikar

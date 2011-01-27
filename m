Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759Ab1A0G5R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 01:57:17 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:53445 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab1A0G5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 01:57:16 -0500
Date: Thu, 27 Jan 2011 12:20:32 +0530
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
        Linux-mm <linux-mm@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC] [PATCH 2.6.37-rc5-tip 16/20] 16: uprobes: register a
 notifier for uprobes.
Message-ID: <20110127065032.GQ19725@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
 <20101216100021.23751.19275.sendpatchset@localhost6.localdomain6>
 <1295963778.28776.1058.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1295963778.28776.1058.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2011-01-25 14:56:18]:

> On Thu, 2010-12-16 at 15:30 +0530, Srikar Dronamraju wrote:
> > Uprobe needs to be intimated on int3 and singlestep exceptions.
> > Hence uprobes registers a die notifier so that its notified of the events.
> 
> Why isn't this part of the previous patch? This splitup really doesn't
> make sense.

The die notifier which is introduced in patch 15 is arch dependent
(i.e x86). Whereever possible I have kept the arch dependent parts
separate from the arch independent parts so that porting to
another architecture becomes easier and clear.

-- 
Thanks and Regards
Srikar

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab0H0MXH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 08:23:07 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:56562 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab0H0MXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 08:23:04 -0400
Date: Fri, 27 Aug 2010 17:47:58 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCHv11 2.6.36-rc2-tip 10/15] 10: tracing: config option to
 enable both kprobe-tracer and uprobe-tracer.
Message-ID: <20100827121758.GA5444@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6>
 <20100825134315.5447.96501.sendpatchset@localhost6.localdomain6>
 <4C76038A.40400@hitachi.com>
 <20100827093135.GI14431@linux.vnet.ibm.com>
 <4C779BDB.70003@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4C779BDB.70003@hitachi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > I think we should go with the first one, i.e have a common knob thats
> > by default unselected.
> 
> Yeah, I'm OK to have a common knob, but I just don't like to set
> KPROBE_EVENT unselected by default. I think there is no reason
> to change default selecting (currently, KPROBE_EVENT=y by default.)

I understand your concern.

> 
> So, I think we should have below selecting list;
> --- Tracers
> ...
> [*] Enable dynamic events
>    [ ] Enable user-space dynamic events (EXPERIMENTAL)
> ...
> 
> What would you think about this ? :)
> 
> Thank you,


Wouldnt it negate the purpose of common knob?
Because people would still have go and select UPROBE_EVENTS,

I think when Frederic asked for a common knob, he was looking at
enabling both or disabling both and an option to selectively
select one of the tracers. 

--
Thanks and Regards
Srikar

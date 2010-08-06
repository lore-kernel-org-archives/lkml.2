Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934271Ab0HFOsJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 10:48:09 -0400
Received: from mail.openrapids.net ([64.15.138.104]:48204 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932268Ab0HFOsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 10:48:05 -0400
Date: Fri, 6 Aug 2010 10:48:01 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, Imre Deak <imre.deak@nokia.com>,
        Jamie Lokier <jamie@shareable.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [patch 01/20] Create generic alignment API (v8)
Message-ID: <20100806144801.GA5523@Krystal>
References: <20100709225727.312232266@efficios.com> <20100709225814.855827624@efficios.com> <20100806114114.GH28519@shisha.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100806114114.GH28519@shisha.kicks-ass.net>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 10:45:40 up 195 days, 17:22,  8 users,  load average: 0.00, 0.02,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alexander Shishkin (virtuoso@slind.org) wrote:
> On Fri, Jul 09, 2010 at 06:57:28 -0400, Mathieu Desnoyers wrote:
> > Rather than re-doing the "alignment on a type size" trick all over again at
> > different levels, import the "ltt_align" from LTTng into kernel.h and make this
> > available to everyone. Renaming to:
> > 
> > - object_align()
> > - object_align_floor()
> > - offset_align()
> > - offset_align_floor()
> 
> I was just wondering if this patch makes any progress anywhere?

I'm using it in my generic ring buffer code (I'm posting it as part of the
patchset). This ring buffer has only been posted in RFC-stages so far.

Other than that, there has been no objection. So the first user of this patch
that gets merged will probably bring the patch alongside with it.

Thanks,

Mathieu

> 
> Regards,
> --
> Alex

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com

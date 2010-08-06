Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761281Ab0HFLlx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 07:41:53 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:40983 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756442Ab0HFLlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 07:41:49 -0400
Date: Fri, 6 Aug 2010 14:41:14 +0300
From: Alexander Shishkin <virtuoso@slind.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
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
        Alexey Dobriyan <adobriyan@gmail.com>,
        Alexander Shishkin <virtuoso@slind.org>
Subject: Re: [patch 01/20] Create generic alignment API (v8)
Message-ID: <20100806114114.GH28519@shisha.kicks-ass.net>
Mail-Followup-To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Christoph Hellwig <hch@lst.de>, Li Zefan <lizf@cn.fujitsu.com>,
	Lai Jiangshan <laijs@cn.fujitsu.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
	Arnaldo Carvalho de Melo <acme@infradead.org>,
	Tom Zanussi <tzanussi@gmail.com>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Andi Kleen <andi@firstfloor.org>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	linux-arm-kernel@lists.infradead.org,
	Imre Deak <imre.deak@nokia.com>, Jamie Lokier <jamie@shareable.org>,
	Alexey Dobriyan <adobriyan@gmail.com>
References: <20100709225727.312232266@efficios.com>
 <20100709225814.855827624@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100709225814.855827624@efficios.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 09, 2010 at 06:57:28 -0400, Mathieu Desnoyers wrote:
> Rather than re-doing the "alignment on a type size" trick all over again at
> different levels, import the "ltt_align" from LTTng into kernel.h and make this
> available to everyone. Renaming to:
> 
> - object_align()
> - object_align_floor()
> - offset_align()
> - offset_align_floor()

I was just wondering if this patch makes any progress anywhere?

Regards,
--
Alex

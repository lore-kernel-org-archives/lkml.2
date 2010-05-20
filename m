Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab0ETPFG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 11:05:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:43390 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab0ETPFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 11:05:04 -0400
X-Authority-Analysis: v=1.1 cv=DB4JU8ZWelvwd5d0x20oybKyR86uyiSly0XbcMdosrc= c=1 sm=0 a=jOljwp8wn3oA:10 a=GQCbJdZ--msA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=UQEaPyTktsJ_13I5gpEA:9 a=Gnq3d0XvIZVEJEkVPFNea48WhZsA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFD] Future tracing/instrumentation directions
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Johannes Berg <johannes.berg@intel.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Lin Ming <ming.m.lin@intel.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Robert Richter <robert.richter@amd.com>
In-Reply-To: <1274366318.26328.2292.camel@gandalf.stny.rr.com>
References: <1274291514.26328.930.camel@gandalf.stny.rr.com>
	 <20100520093131.GA30929@elte.hu>
	 <1274366318.26328.2292.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 20 May 2010 11:04:56 -0400
Message-ID: <1274367896.26328.2321.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-20 at 10:38 -0400, Steven Rostedt wrote:
> n this machine:
> 
> model name	: Intel(R) Core(TM)2 Quad  CPU   Q9450  @ 2.66GHz
> 
> It's a 2x2 (4 cores)
> 

Oh, and this was done with 2.6.34 freshly checked out.

-- Steve

> With running:
> 
> # modprobe ring_buffer_benchmark producer_fifo=10
> # sleep 30
> # cat /debug/tracing/trace
> 




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab0ETMTa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 08:19:30 -0400
Received: from DMZ-MAILSEC-SCANNER-5.MIT.EDU ([18.7.68.34]:62393 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754493Ab0ETMT3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 08:19:29 -0400
X-AuditID: 12074422-b7c13ae000003829-70-4bf528d0200d
Subject: Re: [RFD] Future tracing/instrumentation directions
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <alpine.LFD.2.00.1005201256420.3368@localhost.localdomain>
Date: Thu, 20 May 2010 08:19:04 -0400
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Christoph Hellwig <hch@lst.de>,
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
Content-Transfer-Encoding: 8BIT
Message-Id: <34C06D7E-3CAF-41C9-A0B0-A14D71E81F1F@mit.edu>
References: <1274291514.26328.930.camel@gandalf.stny.rr.com> <20100520093131.GA30929@elte.hu> <20100520100732.GD5309@nowhere> <alpine.LFD.2.00.1005201256420.3368@localhost.localdomain>
To: Thomas Gleixner <tglx@linutronix.de>
X-Mailer: Apple Mail (2.1078)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 20, 2010, at 7:07 AM, Thomas Gleixner wrote:
> 
> I don't care whether I do
> 
> echo 1 >/debug/..../XXX/enable
> cat /debug/tracing/trace
> 
> or
> 
> perfmini trace enable XXX
> perfmini trace dump
> 
> as long as the tool is built in a way that it does not need updates
> when we add trace points or other functionality to the kernel.

I won't care that much assuming that there is a bash_completion script so I can type "perf mini trace enable ext4_da_writep<TAB>" and the right thing happens....

The point is there are a number of advantages of the current system that go beyond just guaranteed availability of the binary->ascii translation tool.  Command competion, shell globbing to find interesting events you want to enable, etc., are also part of the picture

-- Ted


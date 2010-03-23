Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab0CWDjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 23:39:45 -0400
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:53943 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752062Ab0CWDjo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 23:39:44 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Mar 2010 23:39:43 EDT
X-AuditID: 1209190d-b7bf0ae0000059a7-2c-4ba836d27468
Subject: Re: [PATCH 0/18] Allow different tracers to be compiled independently
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <20100323010419.GA8292@nowhere>
Date: Mon, 22 Mar 2010 23:34:33 -0400
Cc: Jan Kara <jack@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Li Zefan <lizf@cn.fujitsu.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <DA3F0457-83D6-4A95-AC86-188BC1C9B2F0@mit.edu>
References: <1269304340-25372-1-git-send-email-jack@suse.cz> <20100323010419.GA8292@nowhere>
To: Frederic Weisbecker <fweisbec@gmail.com>
X-Mailer: Apple Mail (2.1077)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 22, 2010, at 9:04 PM, Frederic Weisbecker wrote:
> 
> I don't know. Yeah this first looks like a good idea but once
> CONFIG_EVENT_TRACING is enabled, each tracepoint is a lightweight
> thing and induce a tiny overhead, probably hard to notice, and
> this is going to be even more the case after the jmp label
> optimization patches.
> 
> I liked the fact we had a general tracing kernel once the above
> config is selected. And we don't bother telling people that to
> use tool X you need CONFIG_EVENT_Y, and you need to rebuild your
> kernel, etc...

Indeed, a lot of the value of tracepoints goes away if people are compiling kernels without them and we need to get a special "tracing kernel" installed before we can debug a problem.

So I'd hope we can do the necessary optimization work so people don't feel it's necessary to enable or disable tracepoints by subsystem....

-- Ted



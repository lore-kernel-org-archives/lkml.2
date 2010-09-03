Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab0ICNMR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 09:12:17 -0400
Received: from mail.openrapids.net ([64.15.138.104]:54036 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753595Ab0ICNMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 09:12:15 -0400
Date: Fri, 3 Sep 2010 09:12:13 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: ltt-dev@lists.casi.polymtl.ca
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Li Zefan <lizf@cn.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: [ANNOUNCEMENT] LTTng tracer re-packaged as stand-alone modules
Message-ID: <20100903131213.GA3230@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 08:21:58 up 223 days, 14:58,  4 users,  load average: 0.01, 0.02,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

Here is a news that should please Linux distributions which have been
overwhelmed by the size of the LTTng patchset. I have extracted the LTTng tracer
patches from the LTTng kernel tree and repackaged it into a new "lttng-modules"
package. There is still a dependency on the LTTng kernel tree at the moment, but
the objective is to gradually reduce the size of this 5 years long mainline
fork.

The objective of this re-packaging is to make life easier for the LTTng users.
Some distributions have been shipping the LTTng tree for years (Wind River,
MontaVista, STLinux). I am still planning to contribute some LTTng pieces to
mainline, but this restructuration will let me focus on the parts that really
need to go into mainline without making my users suffer any longer.

The development of this package is done in the following tree:

git://lttng.org/lttng-modules.git

It will follow a linear development workflow (no more rebases). The kernel LTTng
tree (on which the LTTng tracer module depends) will still be rebased on Linux
mainline.

This is a first step towards cleaning up the LTTng kernel tree. The following
steps will be to refactor the LTTng tree patches, remove part of the
instrumentation from the kernel tree, migrate to TRACE_EVENT(), and migrate to
the generic ring buffer library.

This change is effective as of LTTng 0.227 for kernel 2.6.35.4.
This matches the new lttng-modules package version 0.16.

LTTng, the Linux Trace Toolkit Next Generation, is a project that aims at
producing a highly efficient full system tracing solution.  It is composed of
several components to allow tracing of the kernel, of userspace, trace viewing
and analysis and trace streaming.

Project website: http://lttng.org
Download link: http://lttng.org/content/download
(please refer to the LTTng Manual for installation instructions)

Enjoy!

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com

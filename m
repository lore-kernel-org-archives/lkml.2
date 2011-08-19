Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab1HSCmL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 22:42:11 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:56674 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab1HSCmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 22:42:09 -0400
X-AuditID: b753bd60-a1286ba000000655-73-4e4dcd7eaa75
X-AuditID: b753bd60-a1286ba000000655-73-4e4dcd7eaa75
Message-ID: <4E4DCD59.1070203@hitachi.com>
Date: Fri, 19 Aug 2011 11:41:29 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jason Baron <jbaron@redhat.com>, yrl.pp-manager.tt@hitachi.com,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [PATCH 0/5][RFC] kprobes/ftrace: Have kprobes use ftrace on ftrace
 nops
References: <20110810162222.017387055@goodmis.org>  <4E43209D.7090104@hitachi.com>  <1313022842.18583.282.camel@gandalf.stny.rr.com>  <4E43769C.9000901@hitachi.com>  <1313067691.18583.290.camel@gandalf.stny.rr.com>  <4E44967C.1090101@hitachi.com>  <1313154537.18583.319.camel@gandalf.stny.rr.com>  <4E464D6C.9020807@hitachi.com>  <1313290684.18583.362.camel@gandalf.stny.rr.com>  <4E47A33E.5020202@hitachi.com>  <1313413562.15704.5.camel@gandalf.stny.rr.com>  <4E4BB041.1050004@hitachi.com> <1313697988.15704.77.camel@gandalf.stny.rr.com>
In-Reply-To: <1313697988.15704.77.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/08/19 5:06), Steven Rostedt wrote:
> On Wed, 2011-08-17 at 21:12 +0900, Masami Hiramatsu wrote:
> 
>> I see. OK, I'm now looking forward to your work ;)
> 
> Hi Masami,
> 
> BTW, do you have any test suits that I could use to test the changes I
> make. Something that I may be able to catch regressions with?

Yes, here are the test to ensure putting probes on module/module init code.

http://sourceforge.net/mailarchive/forum.php?thread_name=65795E11DBF1E645A09CEC7EAEE94B9C39F68E90%40USINDEVS02.corp.hds.com&forum_name=dle-develop

http://sourceforge.net/mailarchive/forum.php?thread_name=65795E11DBF1E645A09CEC7EAEE94B9C39F68E8F%40USINDEVS02.corp.hds.com&forum_name=dle-develop

Also, basic smoke test is already in the kernel.

BTW, I think we may need more testcases for checking registers etc.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com

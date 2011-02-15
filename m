Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266Ab1BOQ3c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 11:29:32 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:43495 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab1BOQ33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 11:29:29 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=ZI4DeYlhuOkA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1fM8XR3sZWFIXtiyT7UA:9 a=ysDpxp_I_3rTcfDj-D5jXZBdtpIA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 00/14] [GIT PULL][v2.6.39] tracing/filter: More robust
 filtering
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <1297776787.23343.104.camel@gandalf.stny.rr.com>
References: <20110208015617.902200587@goodmis.org>
	 <20110215044425.GA9994@elte.hu>
	 <1297776787.23343.104.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 15 Feb 2011 11:29:22 -0500
Message-ID: <1297787362.23343.109.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-15 at 08:33 -0500, Steven Rostedt wrote:

> Thanks for letting me waste three days on developing this. I even posted
> an RFC a while back, and no one complained then.

Sorry about being a bit bitchy in my reply here. I need to make a note
not to reply to LKML before my first cup of coffee. ;)

Arnaldo,

Thanks for the post, I'll help you out where you need it. trace-cmd has
some features that reports back to the user on failed filter usage. We
can incorporate that into perf.

-- Steve



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082Ab1BOS7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 13:59:41 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53923 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286Ab1BOS7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 13:59:39 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=ZI4DeYlhuOkA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=dWcSbuINmz9heantNF0A:9 a=zFrm1dnOUZKfY220tDFSffGmGSoA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
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
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20110215184200.GA7335@elte.hu>
References: <20110208015617.902200587@goodmis.org>
	 <20110215044425.GA9994@elte.hu>
	 <1297776787.23343.104.camel@gandalf.stny.rr.com>
	 <20110215184200.GA7335@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 15 Feb 2011 13:59:35 -0500
Message-ID: <1297796375.23343.118.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-15 at 19:42 +0100, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:

> I find this kind of 'the other side does not exist' schizm quite harmful to the 
> 'generic' code in question and am pushing back on you, as i'm expected to. I don't 
> care whether it's "perf's fault" or "ftrace's fault" - i find the whole artificial 
> division harmful and refuse to elongate/deepen it.

Let me apologize again. I did wake up on the wrong side of the bed this
morning, I didn't have my coffee and I was just in a bad mood. That was
not the proper response. I read it as you were not going to take any
more infrastructure updates until the perf side was fixed.

You're right, neither perf or ftrace is intuitive on the filter front
for the novice. But there are advance users that do use it and I was
focused on improving the infrastructure not the interface.

I guess if you started off saying, "Look, I just tried to work with the
perf interface, and the filtering sucks. Can we work to fix that next".
I would have been in a much more collaborating mood.

> 
> Anyway, there's certainly encouraging responses in this thread so i'm hopeful that 
> it's getting fixed and improved and we can push the generic bits upstream.

Yes, I'm hopeful too ;)

-- Steve



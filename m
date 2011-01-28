Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab1A1N6E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 08:58:04 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:37781 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319Ab1A1N6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 08:58:00 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=AlKY2pELOfUA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=D19gQVrFAAAA:8 a=b8VgSBC0AAAA:8 a=5uZyRl2h_sG2iB8QqJsA:9 a=V7e7cGocqw0wNQGNgP7gWNBJoFYA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC] [PATCH 2.6.37-rc5-tip 8/20]  8: uprobes: mmap and fork
 hooks.
From: Steven Rostedt <rostedt@goodmis.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20110128045353.GU19725@linux.vnet.ibm.com>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
	 <20101216095848.23751.73144.sendpatchset@localhost6.localdomain6>
	 <1295957741.28776.719.camel@laptop>
	 <1295985926.10144.61.camel@gandalf.stny.rr.com>
	 <20110126090643.GI19725@linux.vnet.ibm.com>
	 <1296147837.10144.79.camel@gandalf.stny.rr.com>
	 <20110128045353.GU19725@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 28 Jan 2011 08:57:57 -0500
Message-ID: <1296223077.10144.106.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-28 at 10:23 +0530, Srikar Dronamraju wrote:

> Here is the extract from the original patch at
> https://lkml.org/lkml/2010/12/16/74 that I sent to LKML and I dont see
> p being uninitialized. 

I very much apologize. Seems that Evolution was playing tricks on me.

  http://rostedt.homelinux.com/private/evolution-wtf.png

That's a screen shot of your email in the preview window. Where 'p' is
definitely not initialized. WTF happened to my email?

But all the replies to that email does not have it initialized either ??
I was not the only one affected by this.

-- Steve



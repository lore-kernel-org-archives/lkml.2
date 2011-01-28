Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab1A1PCK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 10:02:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:44019 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab1A1PCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 10:02:09 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=AlKY2pELOfUA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=AfUlzTrWpBVSLuc_9lkA:9 a=EbigVCvDhhw2Cp08VhpaC9GFcloA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
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
In-Reply-To: <20110128144629.GW19725@linux.vnet.ibm.com>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
	 <20101216095848.23751.73144.sendpatchset@localhost6.localdomain6>
	 <1295957741.28776.719.camel@laptop>
	 <1295985926.10144.61.camel@gandalf.stny.rr.com>
	 <20110126090643.GI19725@linux.vnet.ibm.com>
	 <1296147837.10144.79.camel@gandalf.stny.rr.com>
	 <20110128045353.GU19725@linux.vnet.ibm.com>
	 <1296223077.10144.106.camel@gandalf.stny.rr.com>
	 <1296224926.10144.109.camel@gandalf.stny.rr.com>
	 <20110128144629.GW19725@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 28 Jan 2011 10:02:05 -0500
Message-ID: <1296226925.10144.110.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-28 at 20:16 +0530, Srikar Dronamraju wrote:

> Interesting, Nothing you can do if your mail client decides to
> delete one arbitrary line. Its Good that you told what you saw and
> hence found a bug in evolution.
> 

Yep, I'm filling out a BZ report right now.

Thanks,

-- Steve



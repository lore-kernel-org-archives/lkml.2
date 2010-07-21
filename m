Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034Ab0GUNIP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 09:08:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:57280 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab0GUNIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 09:08:14 -0400
X-Authority-Analysis: v=1.1 cv=Wd4F0Mu8V05kqqt67pyjJbbzQCzSsR+BbLtAgo88TiY= c=1 sm=0 a=plBTy1s6OugA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=xKPyBF7hT55YOOWZU0YA:9 a=bYsOvXTE5Vgu5liA66g7P-L1g4wA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCHv9 2.6.35-rc4-tip 0/13]  Uprobes Patches:
From: Steven Rostedt <rostedt@goodmis.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20100721024200.GC19375@linux.vnet.ibm.com>
References: <20100712103214.27491.15142.sendpatchset@localhost6.localdomain6>
	 <20100720041938.GA28533@infradead.org>
	 <20100720063805.GA19375@linux.vnet.ibm.com>
	 <20100720210358.GA17631@ghostprotocols.net>
	 <20100721024200.GC19375@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 21 Jul 2010 09:08:10 -0400
Message-ID: <1279717690.4818.31.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-21 at 08:12 +0530, Srikar Dronamraju wrote:

> I tried searching for t.456 gcc labels in google. I dont think I found
> anything interesting. Are we looking at not listing symbols that end
> with @plt? Can you please list an example t.456 label. Also any pointers to
> where I can find more information on the same would be very useful.

I'm not sure you'll find anything looking for "t.456" since that is just
a random label that gcc created for its internal use. But I believe that
all of these temp labels have a '.' in them. Thus, you can just ignore
all labels with '.'.

-- Steve



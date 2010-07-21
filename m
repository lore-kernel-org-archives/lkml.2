Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141Ab0GUOKZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 10:10:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:42184 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070Ab0GUOKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 10:10:23 -0400
X-Authority-Analysis: v=1.1 cv=g9Y3NohClm0xo0Au7hiKM/lwvZwqTqjWC8eysRFNA3U= c=1 sm=0 a=plBTy1s6OugA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=IQh5smi5uFvsr0rxUNIA:9 a=7xcio0WYlXu3NUu1IWH7hO6RSbsA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCHv9 2.6.35-rc4-tip 0/13]  Uprobes Patches:
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
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
In-Reply-To: <20100721132605.GA25631@infradead.org>
References: <20100712103214.27491.15142.sendpatchset@localhost6.localdomain6>
	 <20100720041938.GA28533@infradead.org>
	 <20100720063805.GA19375@linux.vnet.ibm.com>
	 <20100720210358.GA17631@ghostprotocols.net>
	 <20100721024200.GC19375@linux.vnet.ibm.com>
	 <1279717690.4818.31.camel@gandalf.stny.rr.com>
	 <20100721132147.GB4290@linux.vnet.ibm.com>
	 <20100721132605.GA25631@infradead.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 21 Jul 2010 10:10:19 -0400
Message-ID: <1279721419.4818.34.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-21 at 09:26 -0400, Christoph Hellwig wrote:
> On Wed, Jul 21, 2010 at 06:51:47PM +0530, Srikar Dronamraju wrote:
> > Thanks a lot for confirming this. I did some digging and was thinking that may
> > be .L<blah><blah> were the ones that Christoph was referring.
> 
> Well, for me it's T.<blah><blah>, but these seem to be either the same
> or similar.

I've seen both and more.


# nm vmlinux |grep '\.'
ffffffff824d0000 b .brk.dmi_alloc
ffffffff81602710 r ACPI_PSS_BIOS_BUG_MSG.30386
ffffffff81638340 r C.283.15204
ffffffff816382f0 r C.284.15205
ffffffff8164eab0 r C.415.26901
ffffffff81621530 r C.430.27428
ffffffff81606dc0 r C.519.31522
ffffffff81647e00 r C.541.33601
[...]
ffffffff81659590 r CSWTCH.952
ffffffff8135598c t T.1032
ffffffff81355955 t T.1034
ffffffff81051ffb t T.1065
ffffffff81335398 t T.1073

This dump does not have the .L labels, but I have seen them before.

-- Steve



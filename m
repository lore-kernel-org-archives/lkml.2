Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606Ab0GNCzw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 22:55:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:42014 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756492Ab0GNCzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 22:55:50 -0400
X-Authority-Analysis: v=1.1 cv=iR3a2x+wy8z+UqYHl7KFtKHYySPA0Tf/DXXAzrkvAHo= c=1 sm=0 a=dypDJS46MawA:10 a=uEzv4HemXiYA:10 a=IkcTkHD0fZMA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=BMJIvir0SQy8g1qs904A:9 a=fqw8WgG3kxrqlwUVRDD2dN6-OSIA:4 a=QEXdDO2ut3YA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCHv9 2.6.35-rc4-tip 10/13]  perf: Re-Add make_absolute_path
From: Steven Rostedt <rostedt@goodmis.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20100712161239.GF25238@ghostprotocols.net>
References: <20100712103214.27491.15142.sendpatchset@localhost6.localdomain6>
	 <20100712103412.27491.18737.sendpatchset@localhost6.localdomain6>
	 <20100712140023.GC25238@ghostprotocols.net>
	 <1278945036.1537.189.camel@gandalf.stny.rr.com>
	 <20100712161239.GF25238@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Jul 2010 22:49:27 -0400
Message-ID: <1279075767.4190.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-07-12 at 13:12 -0300, Arnaldo Carvalho de Melo wrote:
> Em Mon, Jul 12, 2010 at 10:30:36AM -0400, Steven Rostedt escreveu:

> Well, I prefer to follow the kernel way of doing things, i.e. to
> propagate as much as possible up the callchain the error return value,
> so that the apps can handle it in any way they prefer, i.e. die() calls
> in tools/perf/builtin-foo.c are okayish, but not on tools/perf/util/.

Ah, yes, die is a bit strong. And I have been starting to avoid them
too. Although, when malloc fails, it's almost certain that the app will
die soon anyway ;-)

-- Steve



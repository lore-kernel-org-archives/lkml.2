Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab0GLOak (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 10:30:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53259 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357Ab0GLOaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 10:30:39 -0400
X-Authority-Analysis: v=1.1 cv=FmZLatDjtfD3C7oE6GdrxaCbsxiNBR9ZXBX9JZchN1o= c=1 sm=0 a=dypDJS46MawA:10 a=uEzv4HemXiYA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=yYVPuK6vsqnGe_gb48sA:9 a=iDvGhCBQF3k8ThBnRYkA:7 a=KoylJLFzSurLep3dNYzRBaO82WEA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCHv9 2.6.35-rc4-tip 10/13]  perf: Re-Add make_absolute_path
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
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
In-Reply-To: <20100712140023.GC25238@ghostprotocols.net>
References: <20100712103214.27491.15142.sendpatchset@localhost6.localdomain6>
	 <20100712103412.27491.18737.sendpatchset@localhost6.localdomain6>
	 <20100712140023.GC25238@ghostprotocols.net>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 12 Jul 2010 10:30:36 -0400
Message-ID: <1278945036.1537.189.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-07-12 at 11:00 -0300, Arnaldo Carvalho de Melo wrote:

> Also please remove the xstrdup and die calls from this function, we're
> trying to get rid of all such 'panic' like functions so that we can
> librarize as much code as possible.
>  

What I found useful with the "die" calls with trace-cmd is that I made
them weak, and then they could be overwritten by apps. Thus, in
kernelshark, the die and warning functions produce pop-ups and bug
reports.

-- Steve



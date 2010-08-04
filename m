Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932737Ab0HDNEN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 09:04:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:58117 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932628Ab0HDNEL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 09:04:11 -0400
Subject: Re: [PATCHv9 2.6.35-rc4-tip 2/13]  uprobes: Breakpoint
 insertion/removal in user space applications.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20100804124822.GC28212@linux.vnet.ibm.com>
References: <20100712103214.27491.15142.sendpatchset@localhost6.localdomain6>
	 <20100712103235.27491.293.sendpatchset@localhost6.localdomain6>
	 <20100720042814.GA13624@infradead.org>
	 <20100720072202.GB19375@linux.vnet.ibm.com>
	 <1280923528.1923.1058.camel@laptop>
	 <20100804124822.GC28212@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 04 Aug 2010 15:02:41 +0200
Message-ID: <1280926961.1923.1119.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-04 at 18:18 +0530, Srikar Dronamraju wrote:
> 
> Also wanted to check with if you had tried perf probes and had
> comments/suggestions on any of the other patches in the patchset. 

Just got back from holidays and am trying to make sense of the inbox,
I'll hopefully get around to actually reading the patches 'soon' ;-)

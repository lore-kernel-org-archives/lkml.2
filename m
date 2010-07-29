Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562Ab0G2TnM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 15:43:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:36764 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757358Ab0G2TnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 15:43:11 -0400
Date: Thu, 29 Jul 2010 16:42:19 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCHv10 2.6.35-rc6-tip 10/14]  perf: rename common
 fields/functions from kprobe to probe.
Message-ID: <20100729194219.GB12166@ghostprotocols.net>
References: <20100727110855.24690.26901.sendpatchset@localhost6.localdomain6>
 <20100727111055.24690.20846.sendpatchset@localhost6.localdomain6>
 <4C516B33.9000007@hitachi.com>
 <20100729141351.GG21723@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100729141351.GG21723@linux.vnet.ibm.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jul 29, 2010 at 07:43:51PM +0530, Srikar Dronamraju escreveu:
> Masami, 
>  Below patch should address the comments raised by you.
> 
> Ingo, Arnaldo, 
> Please let me know if you want this to be sent as a new patchset.

I'll try and cherrypick this one for perf/core,

Thanks,

- Arnaldo

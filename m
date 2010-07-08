Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187Ab0GHUTz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 16:19:55 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57958 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab0GHUTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 16:19:54 -0400
Date: Thu, 8 Jul 2010 16:19:26 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Naren A Devaiah <naren.devaiah@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCHv8 2.6.35-rc4-tip 11/12]  perf: perf interface for uprobes
Message-ID: <20100708201926.GB30946@infradead.org>
References: <20100708171003.29165.57615.sendpatchset@localhost6.localdomain6>
 <20100708171215.29165.7352.sendpatchset@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100708171215.29165.7352.sendpatchset@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Here is a terminal snapshot of placing, using and removing a probe on a
> process with pid 3591 (corresponding to zsh)

Btw, I think this interface is not the most the best one for typical
uses cases.  To make perf probe support more useful we'll need at least
a way to create a probe in all intances of a given binary/DSO, and
a way to run a binary with pre-defined breakpoints.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab0HZEhg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 00:37:36 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:33374 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831Ab0HZEhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 00:37:35 -0400
Date: Thu, 26 Aug 2010 10:02:37 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
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
Subject: Re: [PATCHv11 2.6.36-rc2-tip 11/15] 11: perf: list symbols in a
 dso in ascending order.
Message-ID: <20100826043237.GG14431@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6>
 <20100825134329.5447.92261.sendpatchset@localhost6.localdomain6>
 <20100825232116.GA9087@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100825232116.GA9087@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnaldo Carvalho de Melo <acme@infradead.org> [2010-08-25 20:21:16]:

> Em Wed, Aug 25, 2010 at 07:13:29PM +0530, Srikar Dronamraju escreveu:
> > Given a dso, list the symbols in ascending order. Needed for listing
> > available symbols from perf-probe.
> 
> Applied after renaming it to 'dso__fprintf_symbols_by_name', as at first
> I was scratching my head to figure out if we could reuse it in
> dso__fprintf() to then notice that it is in ascending _name_ order, not
> the default that is ordered by addr :-)

Okay, Thanks for pushing it up.

> 
> Please fixup the users, i.e. perf probe in your patchset.

Yes, Shall send the refreshed patch now

-- 
Thanks and Regards
Srikar



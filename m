Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab1CYOPS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 10:15:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59475 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab1CYOPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 10:15:17 -0400
Subject: Re: [RFC] perf: EBNF for event syntax
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lin Ming <ming.m.lin@intel.com>
Cc: "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Matt Fleming <matt@console-pimps.org>
In-Reply-To: <1301060121.2269.1.camel@localhost>
References: <1300851416.31224.58.camel@minggr.sh.intel.com>
	 <1301051277.2250.195.camel@laptop>  <1301060121.2269.1.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Mar 2011 15:17:15 +0100
Message-ID: <1301062635.2250.212.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-25 at 21:35 +0800, Lin Ming wrote:
> > There was a suggestion a while back to make:
> > 
> >  -e ev1,ev2,ev3
> > 
> > create an event group with ev2 and ev3 siblings of ev1, and have
> > multiple -e instances create separate counters.
> > 
> > The problem is that its not backwards compatible, but something like
> > that would still be very nice to have.
> 
> Currently, it means a list of independent events, right?
> 
Right, and as said changing this would create some backward compat
problems so I'm not sure its the best proposal, just wanted to raise the
issue that such functionality would be nice.


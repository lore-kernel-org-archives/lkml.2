Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724Ab2DAViD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 17:38:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614Ab2DAViB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 17:38:01 -0400
Date: Sun, 1 Apr 2012 23:37:48 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>, Jason Baron <jbaron@redhat.com>,
        linux-kernel@vger.kernel.org,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/2] (Was: syscall_regfunc() && TIF_SYSCALL_TRACEPOINT)
Message-ID: <20120401213748.GA17795@redhat.com>
References: <20120330183104.GA12927@redhat.com> <1333134131.23924.191.camel@gandalf.stny.rr.com> <20120330201550.GA16628@redhat.com> <1333152806.23924.196.camel@gandalf.stny.rr.com> <20120331204501.GA18572@redhat.com> <1333229859.23924.200.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333229859.23924.200.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31, Steven Rostedt wrote:
>
> On Sat, 2012-03-31 at 22:45 +0200, Oleg Nesterov wrote:
> >
> > So what do you think we should do,
> >
> > 	- keep this check
> >
> > 	- remove it
> >
> > 	- remove it in a separate patch
>
> I say this one (remove it in a separate patch). That way if something
> breaks we know exactly what did it ;-)

OK, agreed.

Don't really know how can I test this... but the kernel didn't
crash after I enabled the syscall tracer ;)

Oleg.


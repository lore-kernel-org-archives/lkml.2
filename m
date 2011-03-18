Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398Ab1CRTfI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 15:35:08 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:53096 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932223Ab1CRTe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 15:34:57 -0400
Date: Sat, 19 Mar 2011 00:58:11 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Stephen Wilson <wilsons@start.ca>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        SystemTap <systemtap@sources.redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 2.6.38-rc8-tip 16/20] 16: uprobes: register a
 notifier for uprobes.
Message-ID: <20110318192811.GE31152@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
 <20110314133708.27435.81257.sendpatchset@localhost6.localdomain6>
 <20110315195636.GB24972@fibrous.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20110315195636.GB24972@fibrous.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Wilson <wilsons@start.ca> [2011-03-15 15:56:36]:

> On Mon, Mar 14, 2011 at 07:07:08PM +0530, Srikar Dronamraju wrote:
> > +static int __init init_uprobes(void)
> > +{
> > +	register_die_notifier(&uprobes_exception_nb);
> > +	return 0;
> > +}
> > +
> 
> Although not currently needed, perhaps it would be best to return the
> result of register_die_notifier() ? 
> 

Okay, I can do that but notifier_chain_register() that gets called from
register_die_notifier() always return 0.

-- 
Thanks and Regards
Srikar

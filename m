Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759218Ab0FJOIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 10:08:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:37821 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759101Ab0FJOIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 10:08:18 -0400
Date: Thu, 10 Jun 2010 11:07:41 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [PATCH][RFC] tracing: Use class->reg() for all registering of
 events
Message-ID: <20100610140741.GA14096@ghostprotocols.net>
References: <20100608173559.GE2800@linux.vnet.ibm.com>
 <1276024211.15884.107.camel@gandalf.stny.rr.com>
 <20100609050534.GA5878@linux.vnet.ibm.com>
 <1276065150.2046.1004.camel@twins>
 <20100609114753.GB5878@linux.vnet.ibm.com>
 <1276084414.2046.1335.camel@twins>
 <20100609120224.GA8359@ghostprotocols.net>
 <20100609122338.GA9471@ghostprotocols.net>
 <20100609123530.GB9471@ghostprotocols.net>
 <20100610082745.GI5878@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100610082745.GI5878@linux.vnet.ibm.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jun 10, 2010 at 01:57:45PM +0530, Srikar Dronamraju escreveu:
> > > 
> > > Can you please provide a backtrace? I think I know what the problem is,
> > > but I'm not managing to reproduce it here.
> > > 
> > > > > > I am now able to workaround the problem by uninstalling newt-devel.
> > 
> > If you can reinstall it and then try with the following patch, that is
> > the minimal for .35, I'd appreciate,
> 
> Yes, this patch fixes the problem where perf record would fail with
> floating point exception when newt-devel was installed.
> 
> Thanks Arnaldo.

Thanks for testing, I didn't manage to reproduce it here, perhaps the
newt release I have does some checks and notices that newtInit wasn't
called, anyway, I'll push this patch to Ingo right now.

- Arnaldo

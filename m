Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758688Ab0FJI2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 04:28:36 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:32826 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623Ab0FJI2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 04:28:35 -0400
Date: Thu, 10 Jun 2010 13:57:45 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [PATCH][RFC] tracing: Use class->reg() for all registering of
 events
Message-ID: <20100610082745.GI5878@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <1276012661.2046.120.camel@twins>
 <20100608173559.GE2800@linux.vnet.ibm.com>
 <1276024211.15884.107.camel@gandalf.stny.rr.com>
 <20100609050534.GA5878@linux.vnet.ibm.com>
 <1276065150.2046.1004.camel@twins>
 <20100609114753.GB5878@linux.vnet.ibm.com>
 <1276084414.2046.1335.camel@twins>
 <20100609120224.GA8359@ghostprotocols.net>
 <20100609122338.GA9471@ghostprotocols.net>
 <20100609123530.GB9471@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100609123530.GB9471@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > Can you please provide a backtrace? I think I know what the problem is,
> > but I'm not managing to reproduce it here.
> > 
> > > > > I am now able to workaround the problem by uninstalling newt-devel.
> 
> If you can reinstall it and then try with the following patch, that is
> the minimal for .35, I'd appreciate,

Yes, this patch fixes the problem where perf record would fail with
floating point exception when newt-devel was installed.

Thanks Arnaldo.

--
Regards
Srikar


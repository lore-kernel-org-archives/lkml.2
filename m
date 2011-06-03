Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab1FCOxk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 10:53:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588Ab1FCOxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 10:53:39 -0400
Date: Fri, 3 Jun 2011 16:53:37 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] tracing, function, graph: Fixies for field display
Message-ID: <20110603145337.GD1994@jolsa.brq.redhat.com>
References: <1307110803-9476-1-git-send-email-jolsa@redhat.com>
 <1307111215.3667.53.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307111215.3667.53.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 03, 2011 at 10:26:55AM -0400, Steven Rostedt wrote:
> On Fri, 2011-06-03 at 16:19 +0200, Jiri Olsa wrote:
> > hi,
> > 
> > this patchset contains some fixies of trace output for
> > function and function_graph tracers.
> > 
> > attached patches:
> > 1/5 tracing, function_graph: Remove dependency of abstime and duration fields on latency
> > 2/5 tracing, function_graph: Merge overhead and duration display functions
> > 3/5 tracing, function: Fix trace header to follow context-info option
> > 4/5 tracing, function_graph: Remove lock-depth from latency trace
> > 5/5 tracing, function_graph: Add context-info support for function_graph tracer
> 
> Hi Jiri,
> 
> Thanks for these patches. But could you change the change logs to show
> the problems that you see. Just a description does not express what is
> really wrong. Basically add a:
> 
> This is what it looked like before:
> 
> ....
> 
> 
> This is what it looks like now:
> 
> ....
> 
> 
> That way it is obvious what the patches do. I'll test these anyway to
> get a before and after, but it is helpful to see it in the change log.
> 
> Thanks,
> 
> -- Steve
> 
> 

sure, I'll resend v2 shortly

thanks,
jirka

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab1D2PGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 11:06:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563Ab1D2PGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 11:06:49 -0400
Date: Fri, 29 Apr 2011 17:06:42 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: fweisbec@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/3] x86_64,tracing: multiplexing function tracer
Message-ID: <20110429150642.GA1966@jolsa.brq.redhat.com>
References: <1304088194-6214-1-git-send-email-jolsa@redhat.com>
 <1304089030.18763.257.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304089030.18763.257.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 10:57:10AM -0400, Steven Rostedt wrote:
> On Fri, 2011-04-29 at 16:43 +0200, Jiri Olsa wrote:
> > hi, me again ;)
> > 
> > from last RFC email it turned out it'd be good to have support
> > for more than 1 currently running function tracers. With
> > the possibility to specify separate filter for each of them.
> 
> Jiri, I thought I told you to wait, as I'm basically doing the same
> thing. Except that I'm gutting the heck out of ftrace.c.

yep, I was just keeping busy.. ;)
looking forward to see your change

jirka

> 
> I've been working the last several days rewriting this code.
> 
> > 
> > I thought about one way how to do that and put it to the
> > code for considering. It seems to work properly, though
> > I was fighting with set_ftrace_filter for a while.. and
> > it is still not ideal ;)
> 
> Soon, set_ftrace_filter will only affect the function tracer and not any
> other user of function tracing.
> 
> I'm almost done. I was hoping to release something today, but it will
> probably have to wait till next week.
> 
> -- Steve
> 
> 

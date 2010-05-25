Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759060Ab0EYXNO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 19:13:14 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33788 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903Ab0EYXNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 19:13:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lxWEFxzM8YquhHrpurIZeMRPcxcuEAd2ul8B+ukPs2vsOHjU8xgoPKgFylEISk9p47
         Se2udK25KHt4uM/JTH1HRCs4G3gLgLvid3v2P9phPHr8Iuzrps5WQSvxYtnlh077ZBKz
         1HK9PxFET2tw7uuXZHUYWytfixlf4MsLD8HsE=
Date: Wed, 26 May 2010 01:13:10 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Chase Douglas <chase.douglas@canonical.com>,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Tracing configuration review
Message-ID: <20100525231308.GE5370@nowhere>
References: <1274815906.9757.83.camel@cndougla-ubuntu> <1274816768.22648.220.camel@gandalf.stny.rr.com> <20100525201736.GB5370@nowhere> <1274824866.1876.1.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274824866.1876.1.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 06:01:06PM -0400, Steven Rostedt wrote:
> On Tue, 2010-05-25 at 22:17 +0200, Frederic Weisbecker wrote:
> > On Tue, May 25, 2010 at 03:46:08PM -0400, Steven Rostedt wrote:
> > > On Tue, 2010-05-25 at 15:31 -0400, Chase Douglas wrote:
> > > > # CONFIG_SCHED_TRACER is not set (headed for deprecation?)
> > > 
> > > Although it is headed for deprecation, I think it still gets set by
> > > other tracers, since it has the code to initiate the comm reader.
> > 
> > 
> > 
> > Doesn't actually CONTEXT_SWITCH_TRACER has the code for the
> > comm things?
> > 
> 
> Ah, I was confused. But then the SCHED_TRACER is the wakeup tracer, and
> that is heading for deprecation??


It would be nice if we can make it a ftrace_event_call, so that we
can control it like any other trace event.

But for now we don't have any replacement, so it is not yet deprecated.
That's why I said "in the long term" ;)


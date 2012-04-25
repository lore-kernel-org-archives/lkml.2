Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759071Ab2DYLeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 07:34:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758912Ab2DYLeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 07:34:20 -0400
Date: Wed, 25 Apr 2012 13:34:15 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] ftrace: Remove unused code ftrace related code
Message-ID: <20120425113414.GA3378@m.brq.redhat.com>
References: <1335342219-2782-1-git-send-email-jolsa@redhat.com>
 <1335342219-2782-2-git-send-email-jolsa@redhat.com>
 <1335352889.28106.157.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335352889.28106.157.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 07:21:29AM -0400, Steven Rostedt wrote:
> On Wed, 2012-04-25 at 10:23 +0200, Jiri Olsa wrote:
> > Removing unused functions:
> >   ftrace_rec_iter_record
> >   ftrace_rec_iter_next
> >   ftrace_rec_iter_start
> >   ftrace_location
> 
> No, no, no!!
> 
> These are used in the core infrastructure of removing stop machine from
> ftrace.
> 
> Correct, no one currently uses them, but that's because they were needed
> for the arch dependent code. I have patches for both PPC and x86 to
> remove stop machine, and I want the PPC changes to go through the PPC
> tree.
> 
> I pushed the changes for the core infrastructure so that we don't have
> dependencies between different archs.
> 
> Please read: commit c88fd8634ea68e74c7d19fd2621b4078fd22864c
> 
> If you remove these you would break:
> 
>  https://lkml.org/lkml/2012/4/23/620
> 
> Big NACK!

I see, thought they were just leftover not seeing any user..
big sorry then ;-)

jirka

> 
> -- Steve
> 
> 
> 

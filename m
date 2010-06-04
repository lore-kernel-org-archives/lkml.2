Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050Ab0FDCLM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 22:11:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64543 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901Ab0FDCLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 22:11:10 -0400
X-Authority-Analysis: v=1.1 cv=DT5lrGikL/lNZzMKzbmp3iVCACewI9NZ3q1CIi1KGbI= c=1 sm=0 a=PrV_ml3jdBcA:10 a=yQWWgrYGNuUA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=qkXcoXxcMv0mUtqM5rMA:9 a=QPHa6bOalSxeIxWhT9fok8iMLXsA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH][GIT PULL][v2.6.35] tracing/events: Convert format
 output to seq_file
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>,
       James Bottomley <James.Bottomley@suse.de>,
       Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
In-Reply-To: <4C08594E.2000703@cn.fujitsu.com>
References: <1275594103.15884.35.camel@gandalf.stny.rr.com>
	 <4C08594E.2000703@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 03 Jun 2010 22:11:08 -0400
Message-ID: <1275617468.15884.65.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-04 at 09:39 +0800, Li Zefan wrote:
> Steven Rostedt wrote:
> > Ingo,
> > 
> > Please pull the latest tip/perf/urgent tree, which can be found at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> > tip/perf/urgent
> > 
> > 
> > Steven Rostedt (1):
> >       tracing/events: Convert format output to seq_file
> > 
> > ----
> >  kernel/trace/trace_events.c |  208 +++++++++++++++++++++++++++++--------------
> >  1 files changed, 142 insertions(+), 66 deletions(-)
> > ---------------------------
> > commit 0953fa1f774105fcd6150282b7b9ea7763090f64
> > Author: Steven Rostedt <srostedt@redhat.com>
> > Date:   Thu Jun 3 15:21:34 2010 -0400
> > 
> >     tracing/events: Convert format output to seq_file
> >     
> 
> This patch seriously conflicts with my patch that extracts common fields
> from every trace event to a global list, which is already in your perf/core2
> branch. Should I rebase and resend it?
> 

Ah sorry. No don't.

We held off your patches to after the merge window. I even reminded Ingo
to pull them in earlier today. But I forgot that these changes would
conflict with yours.

Ingo and I were not sure if your patches were too much for the end of
the merge window, so we held off on them.

This patch set was created when I noticed that the SCSI tracepoints
failed the size limit in the format, and I worked to fix them.

We may still try to push your patches in -rc. I'll do the conflict
resolution, and make it perf/core-4.

IOW, don't worry about it, I'll do the worrying ;-)

Thanks!

-- Steve



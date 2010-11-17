Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934711Ab0KQMQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 07:16:40 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:36521 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934568Ab0KQMQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 07:16:38 -0500
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=VINkOuZDQI4A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=DRxwDprGQyHbkyvg1QMA:9 a=Np1pi525d2UIVUaLI5lGT4FshsYA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=0kPLrQdw3YYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 1/5] [PATCH 1/5] events: Add EVENT_FS the event
 filesystem
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <20101117033242.GB31335@suse.de>
References: <20101117005357.024472450@goodmis.org>
	 <20101117005939.600541101@goodmis.org>  <20101117033242.GB31335@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 17 Nov 2010 07:16:35 -0500
Message-ID: <1289996195.30543.25.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-16 at 19:32 -0800, Greg KH wrote:
> On Tue, Nov 16, 2010 at 07:53:58PM -0500, Steven Rostedt wrote:
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > Copied mostly from debugfs, the eventfs is the filesystem
> > that will include stable tracepoints. Currently nothing
> > enables this filesystem as of this patch.
> 
> What?  Wait, I wrote tracefs a long time ago just for this, why not take
> that code and use it instead?


Because:

1) I couldn't find it (I thought you called it eventfs, so I was
searching for the wrong thing).

2) You never answered your ping on IRC

3) I was in a rush to get something out.

;-)


I'm perfectly fine in swapping this out. This is only an RFC anyway.
This is also why I Cc'd you on this patch.



> 
> {sigh}  And I just deleted that old tracefs git tree today as I thought
> that idea was long gone and dead....

{sigh} and it may still be dead :-(

-- Steve

> 
> > 
> > Cc: Greg KH <gregkh@suse.de>
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > ---
> >  fs/Kconfig              |    6 +
> >  fs/Makefile             |    1 +
> >  fs/eventfs/Makefile     |    4 +
> >  fs/eventfs/file.c       |   53 ++++++
> >  fs/eventfs/inode.c      |  433 +++++++++++++++++++++++++++++++++++++++++++++++
> 
> This seems a bit big, I don't think you need all of this for some
> reason.  Are you sure you can't make it smaller?
> 
> thanks,
> 
> greg k-h



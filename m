Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab1K2KKh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 05:10:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413Ab1K2KKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 05:10:34 -0500
Date: Tue, 29 Nov 2011 11:10:25 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, fweisbec@gmail.com,
        mingo@redhat.com, paulus@samba.org, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] ftrace, perf: Add support to use function tracepoint
 in perf
Message-ID: <20111129101025.GB1602@m.brq.redhat.com>
References: <1322417074-5834-1-git-send-email-jolsa@redhat.com>
 <1322417074-5834-8-git-send-email-jolsa@redhat.com>
 <1322510318.17003.14.camel@frodo>
 <1322510636.2921.168.camel@twins>
 <1322511189.17003.22.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322511189.17003.22.camel@frodo>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 03:13:09PM -0500, Steven Rostedt wrote:
> On Mon, 2011-11-28 at 21:03 +0100, Peter Zijlstra wrote:
> > On Mon, 2011-11-28 at 14:58 -0500, Steven Rostedt wrote:
> > > >   perf stat -e ftrace:function ls
> > > 
> > > Question. This is a root only command, correct? Otherwise, we are
> > > allowing any user to create a large performance impact to the system. 
> > 
> > Typically not, although I haven't looked at Jiri's implementation of the
> > function tracepoint.
> > 
> 
> I would not allow function tracing for non root users. It's just way too
> invasive to let such a thing happen.

I believe it's for root only, I'll double check

jirka

> 
> -- Steve
> 
> 
> 

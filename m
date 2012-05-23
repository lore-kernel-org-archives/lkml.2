Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933309Ab2EWBnt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 21:43:49 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35461 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760421Ab2EWBnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 21:43:47 -0400
Date: Tue, 22 May 2012 22:43:17 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/2] perf tools: Always try to build libtraceevent
Message-ID: <20120523014317.GE19247@infradead.org>
References: <1337677434-4881-1-git-send-email-namhyung.kim@lge.com>
 <1337677434-4881-2-git-send-email-namhyung.kim@lge.com>
 <20120522153648.GD19247@infradead.org>
 <87k4031yy4.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k4031yy4.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, May 23, 2012 at 10:13:55AM +0900, Namhyung Kim escreveu:
> Hi,
> 
> On Tue, 22 May 2012 12:36:48 -0300, Arnaldo Carvalho de Melo wrote:
> > Em Tue, May 22, 2012 at 06:03:54PM +0900, Namhyung Kim escreveu:
> >> While at it, silence annoying directory change messages.
> >
> > Applied, have you seen these?
> >
> > make[1]: Entering directory `/home/git/linux/tools/lib/traceevent'
> > make[2]: warning: jobserver unavailable: using -j1.  Add `+' to parent make rule.
> > make[2]: `libtraceevent.a' is up to date.
> 
> Yes, but I didn't know how to handle them properly. And the first line
> looks like a bug of QUIET_SUBDIR stuff. Did you build it out of the
> kernel tree?

I always use:

[acme@sandy linux]$ make -j8 -C tools/perf/ O=/home/git/build/perf install

- Arnaldo

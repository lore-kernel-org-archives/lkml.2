Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760142Ab2EPSJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 14:09:28 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:45399 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760084Ab2EPSIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 14:08:37 -0400
Date: Wed, 16 May 2012 15:08:30 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dmitry Antipov <dmitry.antipov@linaro.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Amit Kucheria <amit.kucheria@linaro.org>, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: Re: Perf record format portability
Message-ID: <20120516180830.GH7864@infradead.org>
References: <4FB275EB.5050904@linaro.org>
 <20120515155146.GB7864@infradead.org>
 <4FB38677.8070601@linaro.org>
 <20120516145927.GC7864@infradead.org>
 <1337187503.6724.50.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337187503.6724.50.camel@gandalf.stny.rr.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, May 16, 2012 at 12:58:23PM -0400, Steven Rostedt escreveu:
> On Wed, 2012-05-16 at 11:59 -0300, Arnaldo Carvalho de Melo wrote:
> > 	Was the kernel trace events infrastructure designed with that in
> > mind? I.e. cross analysis? I must be missing something here, still
> > ENOCOFFEE :-\
> 
> Yes, the libparsevents library was design for this from day one. That's
> why trace-cmd data file can be run on an ARM and read on x86, or PPC, or
> whatever. I did all my development testing against 32bit, 64bit and big
> and little endian. This was the case from the beginning.

I need to look at the code, but how does it do this? Copy the relevant
/sys/kernel/debug/events formats in the header and then instead of
looking at /sys/... look at those?

Does it still copy /proc/kallsyms?

- Arnaldo

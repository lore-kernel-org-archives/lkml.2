Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab0C2WYG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 18:24:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:49412 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505Ab0C2WYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 18:24:03 -0400
Date: Mon, 29 Mar 2010 19:23:46 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH -tip 5/7] perf probe: Query basic types from debuginfo
Message-ID: <20100329222346.GB2851@ghostprotocols.net>
References: <20100329203736.2577.56018.stgit@localhost6.localdomain6>
 <20100329203829.2577.44718.stgit@localhost6.localdomain6>
 <20100329205143.GQ3625@ghostprotocols.net>
 <4BB119F8.7020206@redhat.com>
 <20100329215009.GA2851@ghostprotocols.net>
 <4BB1240F.1050300@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BB1240F.1050300@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Mar 29, 2010 at 06:05:03PM -0400, Masami Hiramatsu escreveu:
> Arnaldo Carvalho de Melo wrote:
> > Can't we do just as we do in the kernel and propagate the error back to
> > callers? All the way to userspace, that in this case would be the user
> > instead of an app started by a user?  :-)
> > 
> > Wrt api for storing messages, we have pr_{warning,error,debug}, etc, in
> > the TUI mode it is even redirected to the bottom line and I plan to have
> > them get into something browseable if the user wants to see the last pr_
> > messages.
> 
> Ah, that's very nice:)
> OK, I'll try to use it and remove all 'die()'s.

Thanks a lot!

- Arnaldo

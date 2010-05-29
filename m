Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab0E2Nkk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 09:40:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:37098 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501Ab0E2Nkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 09:40:37 -0400
Date: Sat, 29 May 2010 10:40:13 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>, "David S. Miller" <davem@davemloft.net>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] perf tools: Make target to generate self contained
 source tarball
Message-ID: <20100529134013.GB28009@ghostprotocols.net>
References: <20100528185357.GA28009@ghostprotocols.net>
 <20100529072948.GE16257@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100529072948.GE16257@merkur.ravnborg.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, May 29, 2010 at 09:29:48AM +0200, Sam Ravnborg escreveu:
> On Fri, May 28, 2010 at 03:53:57PM -0300, Arnaldo Carvalho de Melo wrote:
> > Hi Michal, Sam,

> > 	Are you OK with with this change?

> No - I do not like it :-)

> But I like the concept.

I saw the scripts/package, but felt it wasn't quite there where it fits,
because there all existing cases build binary packages and this is
purely a source package, guess I was wrong then :-)

> We have some minimal infrastructure to support packaging
> and this seems like an OK fit for this too.
> Only drawback is that you need to configure your kernel
> before you can pack the source tarball.
> 
> Moving the packaging support to scripts/package/
> avoiding any changes to the top-level Makefile.
> 
> Appended is my attemt to add it to said file.
> But my git did not support the '-o' option so it is untested.
> 
> To apply it you need your MANIFEST file (obviously).
> 
> Help will say:
> $ make help | grep perf
>   perf-pkg        - Build perf-2.6.34.tar.gz source tarball
> 
> 
> You may consider to restructure cmd_perf a little so
> it exits on error. I just did the quick version here.

I'll try to do that later today, thanks a lot!
 
> 	Sam

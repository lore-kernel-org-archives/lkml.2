Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418Ab0EaSGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 14:06:54 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:46179 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074Ab0EaSGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 14:06:52 -0400
Date: Mon, 31 May 2010 20:06:50 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Michal Marek <mmarek@suse.cz>, "David S. Miller" <davem@davemloft.net>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] perf tools: Make target to generate self
	contained source tarball
Message-ID: <20100531180650.GB27518@merkur.ravnborg.org>
References: <20100528185357.GA28009@ghostprotocols.net> <20100529072948.GE16257@merkur.ravnborg.org> <20100531174207.GB3481@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100531174207.GB3481@ghostprotocols.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 02:42:07PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Sat, May 29, 2010 at 09:29:48AM +0200, Sam Ravnborg escreveu:
> > On Fri, May 28, 2010 at 03:53:57PM -0300, Arnaldo Carvalho de Melo wrote:
> > > Hi Michal, Sam,
> > > 
> > > 	Are you OK with with this change?
> > 
> > No - I do not like it :-)
> > 
> > But I like the concept.
> > 
> > We have some minimal infrastructure to support packaging
> > and this seems like an OK fit for this too.
> > Only drawback is that you need to configure your kernel
> > before you can pack the source tarball.
> > 
> > Moving the packaging support to scripts/package/
> > avoiding any changes to the top-level Makefile.
> 
> What about this one?
> 
> It touches one line in the top level Makefile, but that can be
> considered not perf specific, i.e. if building source tarballs
> (-src-pkg suffixed targets) is considered useful, and I think it is,
> then that can be used for building source tarballs with some processing,
> i.e. adding the HEAD to the tarball being generated, like I'm doing
> for perf.

Both the top-level Makefile change and the package stuff can be considered:

Acked-by: Sam Ravnborg <sam@ravnborg.org>

	Sam

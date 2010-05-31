Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab0EaPmd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 11:42:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:38085 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755600Ab0EaPmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 11:42:32 -0400
Date: Mon, 31 May 2010 12:42:14 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>, "David S. Miller" <davem@davemloft.net>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] perf tools: Make target to generate self contained
 source tarball
Message-ID: <20100531154214.GA3481@ghostprotocols.net>
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
> > 
> > 	Are you OK with with this change?
> 
> No - I do not like it :-)
> 
> But I like the concept.
> 
> We have some minimal infrastructure to support packaging
> and this seems like an OK fit for this too.
> Only drawback is that you need to configure your kernel
> before you can pack the source tarball.

Which is really annoying, can't we lift that requirement for source
tarballs? I'm looking into this now.

- Arnaldo

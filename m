Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459Ab2IYRDy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 13:03:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:35171 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378Ab2IYRDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 13:03:53 -0400
Date: Tue, 25 Sep 2012 10:03:49 -0700
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: specifying raw perf events
Message-ID: <20120925170349.GE14405@ghostprotocols.net>
References: <20120925155235.GA6982@aftab.osrc.amd.com>
 <20120925170201.GD14405@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120925170201.GD14405@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Sep 25, 2012 at 10:02:01AM -0700, Arnaldo Carvalho de Melo escreveu:
> Em Tue, Sep 25, 2012 at 05:52:35PM +0200, Borislav Petkov escreveu:
> > I'm trying to use raw events and to read how exactly they're specified.
> > Here's what do:
> > 
> > $ perf list -h
> > 
> > ...
> >   rNNN                                               [Raw hardware event descriptor]
> >   cpu/t1=v1[,t2=v2,t3 ...]/modifier                  [Raw hardware event descriptor]
> >    (see 'perf list --help' on how to encode it)
> > ...
> > 
> > $ perf list --help
> > $
> > 
> > No help. :-(
> > 
> > $ perf --version
> > perf version 3.6.rc7.1723.g226ea0
> > 
> > That's latest Linus + tip/auto-latest.
> 
> $ make -C tools/perf/Documentation install
> 
> ?

If done as non-root:

man -M ~/share/man/ perf-list

- Arnaldo

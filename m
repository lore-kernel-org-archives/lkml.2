Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757826Ab2IYRpN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 13:45:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49842 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654Ab2IYRpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 13:45:11 -0400
Date: Tue, 25 Sep 2012 10:45:07 -0700
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: specifying raw perf events
Message-ID: <20120925174506.GF14405@ghostprotocols.net>
References: <20120925155235.GA6982@aftab.osrc.amd.com>
 <20120925170201.GD14405@ghostprotocols.net>
 <20120925170349.GE14405@ghostprotocols.net>
 <20120925171155.GE6982@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120925171155.GE6982@aftab.osrc.amd.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Sep 25, 2012 at 07:11:55PM +0200, Borislav Petkov escreveu:
> On Tue, Sep 25, 2012 at 10:03:49AM -0700, Arnaldo Carvalho de Melo wrote:
> > Em Tue, Sep 25, 2012 at 10:02:01AM -0700, Arnaldo Carvalho de Melo escreveu:
> > > Em Tue, Sep 25, 2012 at 05:52:35PM +0200, Borislav Petkov escreveu:
> > > $ make -C tools/perf/Documentation install

> Ok, this target doesn't get triggered automatically from

> $ make tools/perf_install

> Should we change that?

yes

> Also, after I run it,

> $ perf list --help
> $

> still doesn't show anything. (running it as non-root).

> > If done as non-root:

> > man -M ~/share/man/ perf-list

> This one works. But looks like "perf list --help" needs fixing?

We accept patches! :-)

- Arnaldo

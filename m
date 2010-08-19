Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab0HSONt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 10:13:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60769 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501Ab0HSONq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 10:13:46 -0400
Date: Thu, 19 Aug 2010 11:13:32 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Bernd Petrovitsch <bernd@sysprog.at>
Cc: Kusanagi Kouichi <slash@ac.auone-net.jp>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Fix build error on read only source.
Message-ID: <20100819141332.GK9410@ghostprotocols.net>
References: <20100817181835.GA21083@ghostprotocols.net>
 <20100818123713.1F02414C03B@msa103.auone-net.jp>
 <20100818141412.GD9410@ghostprotocols.net>
 <1282145141.5822.125.camel@thorin>
 <20100818171917.GH9410@ghostprotocols.net>
 <1282213908.10440.8.camel@thorin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282213908.10440.8.camel@thorin>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Aug 19, 2010 at 12:31:48PM +0200, Bernd Petrovitsch escreveu:
> On Mit, 2010-08-18 at 14:19 -0300, Arnaldo Carvalho de Melo wrote:
> > Em Wed, Aug 18, 2010 at 05:25:41PM +0200, Bernd Petrovitsch escreveu:
> > > On Mit, 2010-08-18 at 11:14 -0300, Arnaldo Carvalho de Melo wrote:
> [...]
> > > > $(phony feature-tests): 
> > > First, this should probably have been:
> > > .PHONY: feature-tests
> > 
> > Humm, isn't $(phony feature-tests): variation valid and shorter, humm,
> > yeah, seems to be for !GNU make :-\
> > 
> > (http://makepp.sourceforge.net/1.18/t_phony.html)
> 
> Funny, I didn't knew GNU-make's "$(phony target): " construct.

it doesn't have AFAIK, its just this makepp, that I never had heard
about before, that has it, probably it introduced the idea. Quite
sensible, it seems.
 
> Hmm, what GNU-make versions and other `make`s are considered (or should
> be) supported?

I think only GNU make is supported.
 
> [...]
> > There is no use of mktemp in Kbuild, that I try hard to use as reference
> > here.
> 
> FWIW fine with me - I just threw an idea in.

Right, and I considered it, using Kbuild usage as a validation gauge to
say we probably shouldn't use it :)

- Arnaldo

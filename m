Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab1LAOLl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 09:11:41 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60721 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289Ab1LAOLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 09:11:39 -0500
Date: Thu, 1 Dec 2011 12:11:30 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Brian Marete <marete@toshnix.com>
Cc: David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, peterz@infradead.org, fweisbec@gmail.com
Subject: Re: [PATCH] perf top: fix crash on annotate request
Message-ID: <20111201141130.GA2323@infradead.org>
References: <1319048598-15030-1-git-send-email-dsahern@gmail.com>
 <20111019183848.GE2229@ghostprotocols.net>
 <4E9F1AA0.4010706@gmail.com>
 <20111019192011.GG2229@ghostprotocols.net>
 <4E9F4B50.1060207@gmail.com>
 <20111020130041.GB1772@ghostprotocols.net>
 <CAHVUoiSwem2r9J==gmHPfst3_0ZB5bd0ykf9cPUMdhZFaXC9EA@mail.gmail.com>
 <CAHVUoiTeCuFLCkyEzCMJ6g1wAp+FWDR3qkSrqE3vJAYwLsRC9Q@mail.gmail.com>
 <20111130181011.GA4111@infradead.org>
 <CAHVUoiQC5RjuHUsfPVTQ_C+W0Khp=hQC+_csP0+fJgUnoaALAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHVUoiQC5RjuHUsfPVTQ_C+W0Khp=hQC+_csP0+fJgUnoaALAA@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Dec 01, 2011 at 04:17:49PM +0300, Brian Marete escreveu:
> On Wed, Nov 30, 2011 at 9:10 PM, Arnaldo Carvalho de Melo
> <acme@infradead.org> wrote:
> > https://github.com/acmel/linux/tree/perf/core

> > It just fell thru the cracks, sorry, I should have tried to reproduce
> > and fix this on the tree you reported.

> > But if you can try with the above tree...

> > Persistence is key, thanks for using it :)

> Hello Arnaldo, Thanks for your reply. The perf/core branch of the tree
> you suggest above gives me the same crash (with what looks to me as
> the same b/trace). Would you like the details of the b/trace? The
> master branch of the said tree appears too old to me (so of course it
> does not suffer the crash). Which other branch of the tree should I
> try?

Its just this one, can you try doing something like:

perf top -vvv > /tmp/debug.top 2>&1
bzip2 /tmp/debug.top

That will print lots of information about symbols being loaded,
overlapping maps, etc that can help me understand why that symbol name
looks garbage.

And send me in pvt the result together with a fresh backtrace with those
symbols printed? Also which distro are you using?

- Arnaldo

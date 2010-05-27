Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759179Ab0E0AXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 20:23:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39471 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757356Ab0E0AXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 20:23:18 -0400
Date: Wed, 26 May 2010 21:23:06 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       mingo@elte.hu, Peter Zijlstra <peterz@infradead.org>,
       Tom Zanussi <tzanussi@gmail.com>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [GIT PULL 0/2] perf annotate fix and report improvoment
Message-ID: <20100527002306.GH9874@ghostprotocols.net>
References: <20100526005531.GA9874@ghostprotocols.net>
 <AANLkTim-xv9mNEwGCueV47AoKh6AXbrdbTdCEwZHaEHJ@mail.gmail.com>
 <20100526182351.GB9874@ghostprotocols.net>
 <AANLkTimOEUKYXzdMOiWE6gRxR7vJX36VscdLjRroqGLq@mail.gmail.com>
 <20100526193255.GC9874@ghostprotocols.net>
 <AANLkTinxVsp1qtfqjlwl-ngrcD9IBDg6GoBnAk07ABuo@mail.gmail.com>
 <20100526203315.GD9874@ghostprotocols.net>
 <AANLkTimBC83Z8lSD8Drfpefl1D8Fpx-hYuQaZx4RyvSG@mail.gmail.com>
 <20100526205002.GE9874@ghostprotocols.net>
 <AANLkTilDGRUQXZZhFKugOjXvWrb-mHyVTSBPSiWaJ0XH@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTilDGRUQXZZhFKugOjXvWrb-mHyVTSBPSiWaJ0XH@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, May 27, 2010 at 01:13:24AM +0200, Stephane Eranian escreveu:
> On Wed, May 26, 2010 at 10:50 PM, Arnaldo Carvalho de Melo
> > You can zoom into DSOs and threads, additionally you can Annotate
> > symbols, so you mean that annotating the 'noploop' in the 'noploop' DSO
> > didn't work?

> Yes, it does not show me the assembly.

We'll get this fixed.

> > Lets try this offline thing ourselves, can you please put the
> > perf.data.tar.bz2 and the perf.data files somewhere I can grab? So that
> > I can try to do these operations here and figure out the problem :-)

> > I guess there is nothing sensitive in those files, lemme know if making
> > them available is not an option and I'll try other ways to get this
> > fixed.

> I will send you the files in a private email.

Thanks a lot!

- Arnaldo

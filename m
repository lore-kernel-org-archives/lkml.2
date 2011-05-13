Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759340Ab1EMUqB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 16:46:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758906Ab1EMUqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 16:46:00 -0400
Date: Fri, 13 May 2011 17:45:30 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Wim Heirman <wim@heirman.net>
Cc: Ingo Molnar <mingo@elte.hu>, David Ahern <dsahern@gmail.com>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Brice Goglin <Brice.Goglin@inria.fr>
Subject: Re: perf-stat per thread results
Message-ID: <20110513204530.GF8950@ghostprotocols.net>
References: <BANLkTimTOTz4qNwYPa6Ey7=QRjOhQHWt-Q@mail.gmail.com> <4DCD4FC5.8020608@gmail.com> <20110513154410.GA6373@elte.hu> <BANLkTi=UKJ2Ztkcui_+8UHF16b_8mTvpnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=UKJ2Ztkcui_+8UHF16b_8mTvpnA@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, May 13, 2011 at 10:32:58PM +0200, Wim Heirman escreveu:
> > It's supposed to do that if --stat is specified, and it used to work - see this
> > commit:

> >  8d51327090ac: perf report: Fix and improve the displaying of per-thread event counters

> > and the output there:
> >
> >     #  PID   TID  cache-misses  cache-references
> >       4658  4659        495581           3238779
> >       4658  4662        498246           3236823
> >       4658  4663        499531           3243162

> > which appears to be roughly what Wim is asking for, AFAICT.

> Thanks, this is exactly what I'm looking for. In 2.6.32 (Ubuntu 10.04)
> it works, although if I use --pid rather than the -- <command> variant
> the first thread seams to be missing. In 2.6.38 (Ubuntu 11.04) the
> first thread is missing in both use cases, and I get one column per
> processor (which in itself is fine).

Can you try after applying the patches in this message:

http://marc.info/?l=linux-kernel&m=130385067430510&w=2

and report your results?

If it fixes the problems you're experiencing, please provide a:

Tested-by: Wim Heirman <wim@heirman.net>

So that I can add when sending them to Ingo.

Thanks,

- Arnaldo

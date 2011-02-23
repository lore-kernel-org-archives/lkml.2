Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab1BWLxv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 06:53:51 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56598 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab1BWLxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 06:53:50 -0500
Date: Wed, 23 Feb 2011 08:53:37 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Funny perf
Message-ID: <20110223115337.GB12398@ghostprotocols.net>
References: <20110217182658.GA23443@aftab>
 <1298456508.2217.357.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298456508.2217.357.camel@twins>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Feb 23, 2011 at 11:21:48AM +0100, Peter Zijlstra escreveu:
> On Thu, 2011-02-17 at 19:26 +0100, Borislav Petkov wrote:
> > so this looks like some of the samples do not belong in the perf.data
> > output with that garbled cpu field. It lets me also assume that the
> > sample->time field is also crap so the timestamp check is falsely
> > tripped. 
> 
> Most interesting, I haven't tried to reproduce, but it does sound
> smelly.
> 
> I did have a quick peek at some code I suspected but that all seems in
> order. I guess someone will have to sit down and figure this out proper,
> if nobody steps up I guess it'll have to be me, but that also means it
> might take a while since I've got some other pending stuff to stare at
> before this :/

I'll look at it today.

- Arnaldo

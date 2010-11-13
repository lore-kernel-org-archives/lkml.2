Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab0KMNnb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 08:43:31 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:45053 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752907Ab0KMNna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 08:43:30 -0500
Date: Sat, 13 Nov 2010 14:43:27 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Emese Revfy <re.emese@gmail.com>
Cc: Kees Cook <kees.cook@canonical.com>, linux-kernel@vger.kernel.org,
        cocci@diku.dk, Lionel Debroux <lionel_debroux@yahoo.fr>,
        Brad Spengler <spender@grsecurity.net>
Subject: Re: [Cocci] Re: status of constification
In-Reply-To: <4CDE80E8.6060601@gmail.com>
Message-ID: <Pine.LNX.4.64.1011131442480.8553@pc-004.diku.dk>
References: <20101108223844.GS5876@outflux.net> <4CD9BF25.4090306@gmail.com>
 <Pine.LNX.4.64.1011100727370.352@ask.diku.dk> <4CDC64B9.8070208@gmail.com>
 <Pine.LNX.4.64.1011112352030.27612@ask.diku.dk> <4CDE80E8.6060601@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Nov 2010, Emese Revfy wrote:

> >>> What would the right approach be?  It is not obvious to find 100% of the 
> >>> header files, because some of them depend on information in Makefiles.  
> >>
> >> For 100% coverage you can look at how the Linux Makefiles invoke sparse.
> > 
> > I haven't looked at it, but I doubt it gives 100% coverage, because one 
> > can have code in both the if and else branches of an ifdef.  I would 
> > imagine that it gives 100% coverage for whatever architecture you would be 
> > compiling for?
> 
> For my purposes it's enough to find all includes for a given .config.

Coccinelle doesn't interpret .config files.

> What would be also useful is if Coccinelle could somehow ignore ifdef's that
> guard code blocks so that it would analyse all code in a translation unit. 

It does that.

julia

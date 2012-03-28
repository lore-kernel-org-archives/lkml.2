Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302Ab2C1Qox (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 12:44:53 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:41943 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757985Ab2C1Qor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 12:44:47 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+JWJAnC3WJtCdVz1E2I9ba4c84kjRXoyQPlA2tWX
	XW8OsbeZDm8tjV
Message-ID: <1332953083.7309.147.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] BFS CPU scheduler version 0.420 AKA "Smoking" for
 linux kernel 3.3.0
From: Mike Galbraith <efault@gmx.de>
To: Nikos Chantziaras <realnc@gmail.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 28 Mar 2012 18:44:43 +0200
In-Reply-To: <jkv0q5$kgu$1@dough.gmane.org>
References: <CABqErrHS6C6RVMKChaPGACoaWoXCKf+6dS5KFrWG04+DnZO6Dw@mail.gmail.com>
	 <201203240553.32526.gene.heskett@gmail.com>
	 <57375.1332641134@turing-police.cc.vt.edu>
	 <20120328051243.GA2138@fancy-poultry.org> <jkv0q5$kgu$1@dough.gmane.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-28 at 15:39 +0300, Nikos Chantziaras wrote: 
> On 28/03/12 08:12, Heinz Diehl wrote:
> > On 25.03.2012, Valdis.Kletnieks@vt.edu wrote:
> >
> >> I'va always wondered what people are using to measure interactivity. Do we have
> >> some hard numbers from scheduler traces, or is it a "feels faster"?
> >
> > I guess it's a "feels faster", because it's the only thing that
> > counts. Given that there is strong evidence that scheduler A is
> > "faster, more interactive", whatever... than scheduler B, but a
> > controlled trial shows a significantly better "feels faster"
> > experience using scheduler B, I'm quite shure that people would choose
> > scheduler B over A, and that's quite ok. It does what they expect it
> > to do, despite evidence which documents the opposite.
> 
> CFS: ALSA XRUNs in JACK.
> BFS: much less ALSA XRUNs in JACK

Something like that could be interesting to look into.  Do you have a
setup and recipe for inducing these xruns I can try?  I don't have any
audio problems of my own to fiddle with, but then the few apps I use
buffer a lot, so I wouldn't.

-Mike


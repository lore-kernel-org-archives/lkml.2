Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932741Ab0KLSVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 13:21:18 -0500
Received: from ist.d-labs.de ([213.239.218.44]:43773 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932252Ab0KLSVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 13:21:16 -0500
Date: Fri, 12 Nov 2010 19:20:46 +0100
From: Florian Mickler <florian@mickler.org>
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Newsgroups: gmane.linux.kernel
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [bisected] i915 regression in post 2.6.36 kernels
Message-ID: <20101112192046.1c38e671@schatten.dmk.lab>
In-Reply-To: <201011102339.36590.johannes.hirte@fem.tu-ilmenau.de>
References: <201011100802.20332.johannes.hirte@fem.tu-ilmenau.de>
	<0d30dc$k4n8nm@orsmga001.jf.intel.com>
	<201011102339.36590.johannes.hirte@fem.tu-ilmenau.de>
X-Newsreader: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Nov 2010 23:39:35 +0100
Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de> wrote:

> On Wednesday 10 November 2010 08:46:40 Chris Wilson wrote:
> > On Wed, 10 Nov 2010 08:02:19 +0100, Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de> wrote:
> > > With the latest kernel, I don't get any windows in KDE displayed. After
> > > starting kdm, I get the background picture and the mouse cursor but not the
> > > login window. I can login blindly and a ps on console shows me that the
> > > expected KDE processes are started but still nothing is displayed. 
> > > I've bisected this to:
> > > 
> > > 5c12a07e8073295ce8b57a822f811ac34e4f8420 is the first bad commit
> > > commit 5c12a07e8073295ce8b57a822f811ac34e4f8420
> > > Author: Chris Wilson <chris@chris-wilson.co.uk>
> > > Date:   Wed Sep 22 11:22:30 2010 +0100
> > > 
> > >     drm/i915: Drop ring->lazy_request
> > >     
> > >     We are not currently using it as intended, so remove the complication.
> > > 
> > >     Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> > 
> > May I ask you to recheck your bisection, since that was later reverted.
> > -Chris
> 
> Did so. I've started with v2.6.36 for bisect good and 
> f6614b7bb405a9b35dd28baea989a749492c46b2 for bisect bad (was HEAD) in this
> case. Again I ended in 5c12a07e8073295ce8b57a822f811ac34e4f8420 as the first
> bad commit. The regression was introduced there, as the commit before is fine.
> If it was reverted, the regression should be fixed by this. But I don't find
> neither the fix/revert nor the reintroduction of the regression.
> 
> regrards,
>   Johannes

The revert is a56ba56c275b1c2b982c8901ab92bf5a0fd0b757 .

Regards,
Flo

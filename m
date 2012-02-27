Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab2B0Qc4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 11:32:56 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40378 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753656Ab2B0Qcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 11:32:54 -0500
Message-ID: <1330360371.2822.56.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH] parisc: fix longstanding build failure on prefetch
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: jejb@parisc-linux.org, kyle@mcmartin.ca, deller@gmx.de,
        linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, rientjes@google.com,
        xiyou.wangcong@gmail.com
Date: Mon, 27 Feb 2012 10:32:51 -0600
In-Reply-To: <4F4BA91D.7090303@windriver.com>
References: <1330289478-12603-1-git-send-email-paul.gortmaker@windriver.com>
	 <1330356289.2822.45.camel@dabdike.int.hansenpartnership.com>
	 <4F4BA91D.7090303@windriver.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-27 at 11:02 -0500, Paul Gortmaker wrote:
> On 12-02-27 10:24 AM, James Bottomley wrote:
> > On Sun, 2012-02-26 at 15:51 -0500, Paul Gortmaker wrote:
> >> Upstream commit e66eed651fd18a961f11cda62f3b5286c8cc4f9f
> >>
> >>     "list: remove prefetching from regular list iterators"
> >>
> >> removed <linux/prefetch.h> from <linux/list.h> very early in the
> >> v3.0 dev cycle (v2.6.39-2-ge66eed6), thereby causing build failures
> >> when it exposed the implicit prefetch users in parisc.
> > 
> > I already have this in my internal patch queue:
> > 
> > http://marc.info/?l=linux-parisc&m=132825467010662
> 
> Is this in a different queue than what is in linux next?

Yes, sorry ... I hadn't got around to building the parisc tree for the
current version.  I've done that now.

> It would be nice to see such build fixes get into linux-next
> ASAP, so folks doing multi-arch coverage builds on their work
> can know if they've introduced a regression.  At the moment,
> the parisc builds in linux-next have been worthless for over
> six months, and I'm sure I'm not the 1st one to waste time
> "re-solving" old bugs like this.

So if you recheck with the next build of linux-next, they should all be
there (modulo the cross compile patch which is still under discussion).

James



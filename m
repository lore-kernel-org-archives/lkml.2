Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933115Ab1FACBv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 22:01:51 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:49748 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933030Ab1FACBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 22:01:50 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/tFm9UJp/txj0+xH0L0jfW5BhbOuR1hs4JE9/L2X
	TVz1w3VoVH/MT6
Subject: Re: recursive fault in 2.6.35.5
From: Mike Galbraith <efault@gmx.de>
To: Whit Blauvelt <whit@transpect.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20110531142415.GA17781@black.transpect.com>
References: <20110529162738.GA7832@black.transpect.com>
	 <1306723709.4895.4.camel@marge.simson.net>
	 <20110531142415.GA17781@black.transpect.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Jun 2011 04:01:46 +0200
Message-ID: <1306893706.4791.12.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-31 at 10:24 -0400, Whit Blauvelt wrote:
> On Mon, May 30, 2011 at 04:48:29AM +0200, Mike Galbraith wrote:
> 
> > No, you've been bitten by an annoyingly elusive load balancing bug.
> 
> Thanks Mike. Can that bug be avoided by leaving out some kernel option? The
> system that happened on had it's identical twin fail the day before. For
> both, it was a time of relatively more load (although not excessive). On the
> twin we didn't look at the console before rebooting though.
> 
> On the other hand, we'd run for months with no problem up until this.

No earthly notion.  I never figured out exactly how it happens.  Setting
traps for the critter didn't worked out.  I did receive some diagnostic
info from a group of ppc64 boxen that indicated that the clock went
backward, but when I zeroed in on it, it they went silent.  All other
machines with traps set have been totally silent for months (that's a
lot of machines too).

Bug seems to be dead upstream, at least I haven't noticed any reports
with a recent kernel.

	-Mike


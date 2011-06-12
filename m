Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab1FLLiU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 07:38:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49341 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664Ab1FLLiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 07:38:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Cyril Hrubis <metan@ucw.cz>
Subject: Re: [PATCH] Make GFP_DMA allocations w/o ZONE_DMA emit a warning instead of failing
Date: Sun, 12 Jun 2011 13:39:02 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39+; KDE/4.6.0; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "Dmitry Eremin-Solenikov" <dbaryshkov@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <1306922672-9012-1-git-send-email-dbaryshkov@gmail.com> <201106121307.20631.rjw@sisk.pl> <20110612113319.GB13048@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20110612113319.GB13048@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106121339.02850.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 12, 2011, Cyril Hrubis wrote:
> Hi!
> > > > > Please be more polite to other people. After a197b59ae6 all allocations
> > > > > with GFP_DMA set on nodes without ZONE_DMA fail nearly silently (only
> > > > > one warning during bootup is emited, no matter how many things fail).
> > > > > This is a very crude change on behaviour. To be more civil, instead of
> > > > > failing emit noisy warnings each time smbd. tries to allocate a GFP_DMA
> > > > > memory on non-ZONE_DMA node.
> > > > >
> > > > > This change should be reverted after one or two major releases, but
> > > > > we should be more accurate rather than hoping for the best.
> > > > 
> > > > Instaed of, shouldn't we revert a197b59ae6? Some arch don't have
> > > > DMA_ZONE at all.
> > > > and a197b59ae6 only care x86 embedded case. If we accept your patch, I
> > > > can imagine
> > > > other people will claim warn foold is a bug. ;)
> > > 
> > > I believe we should revert. It broke zaurus boot for metan...
> > 
> > Is it still a problem, or has it been fixed in the meantime?
> > 
> 
> This was revered in 3.0-rc2.

Cool, thanks!

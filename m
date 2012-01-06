Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552Ab2AFFF4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 00:05:56 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:49352 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750901Ab2AFFFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 00:05:53 -0500
X-Sasl-enc: JKPhyN91YhpxeQkim9flDtCbGbcly5gY4Mh+Lt9tTuRT 1325826352
Date: Thu, 5 Jan 2012 21:05:38 -0800
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dimitri Sivanich <sivanich@sgi.com>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: linux-next: build failure after merge of the akpm tree
Message-ID: <20120106050538.GC7633@kroah.com>
References: <20120105182949.e35b2430b915b50e4bb9bc04@canb.auug.org.au>
 <20120105155233.0d367bc3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120105155233.0d367bc3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 03:52:33PM -0800, Andrew Morton wrote:
> On Thu, 5 Jan 2012 18:29:49 +1100
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > Hi Andrew,
> > 
> > After merging the akpm tree, today's linux-next build (powerpc
> > ppc64_defconfig) failed like this:
> > 
> > kernel/time/tick-sched.c:874:7: warning: 'struct sysdev_attribute' declared inside parameter list [enabled by default]
> >
> > ...
> >
> > Caused by commit 629d589817da ("tick-sched: add specific do_timer_cpu
> > value for nohz off mode") interacting with the removal of sysdevs in the
> > driver-core tree.  This patch will need reworking for that.
> > 
> > I have reverted that commit for today.
> 
> Bah.  I dropped it.
> 
> I must say, this week was a maximally inappropriate time to merge all this
> sysdev stuff into linux-next.

It was merged the week before christmas, there was a fun vacation break
in there, and a "build warning turns to error" problem with the powerpc
tree that we missed which caused it to be dropped from linux-next for a
few days, which all combined to hit you now.

Sorry about that, a fallout of the time of the year.  It had been a
while since Kay and I had bothered a bunch of people, it was about time :)

greg k-h

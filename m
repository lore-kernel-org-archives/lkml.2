Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398Ab0EXXwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:52:14 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:41827 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932103Ab0EXXwN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:52:13 -0400
Message-ID: <20100524195200.etvygryty8g0gswc@imap.linux.ibm.com>
Date: Mon, 24 May 2010 19:52:00 -0400
From: Corinna Schultz <cschultz@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, djwong@linux.vnet.ibm.com
Subject: Re: [PATCH] calgary: Increase the maximum PHB bus number
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) H3 (4.1.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 06, 2010, Darrick J. Wong wrote:
> On Thu, Feb 18, 2010 at 10:37:50AM -0800, Darrick J. Wong wrote:
> > On Wed, Dec 09, 2009 at 11:03:46AM +0200, Muli Ben-Yehuda wrote:
> > > On Tue, Dec 08, 2009 at 04:59:01PM -0800, Darrick J. Wong wrote:
> > > > > > -#define MAX_NUM_OF_PHBS		 		 8 /* how many PHBs in total? */
> > > > -#define MAX_NUM_CHASSIS		 		 8 /* max number of chassis */
> > > > -/* MAX_PHB_BUS_NUM is the maximal possible dev->bus->number */
> > > > -#define MAX_PHB_BUS_NUM		 		 (MAX_NUM_OF_PHBS * MAX_NUM_CHASSIS * 2)
> > > > +/*
> > > > +   The maximum PHB bus number.
> > > > +   x3950M2 (rare): 8 chassis, 48 PHBs per chassis = 384
> > > > +   x3950M2: 4 chassis, 48 PHBs per chassis        = 192
> > > > +   x3950 (PCIE): 8 chassis, 32 PHBs per chassis   = 256
> > > > +   x3950 (PCIX): 8 chassis, 16 PHBs per chassis   = 128
> > > > +*/
> > > > +#define MAX_PHB_BUS_NUM		 		 384
> > > > +
> > > >  #define PHBS_PER_CALGARY		 4
> > > > > We'll end up wasting a few bytes on small systems, but I don't think
> > > it's enough to matter on these fairly large systems. As far as I'm
> > > concerned, patch is fine.
> > > > > Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>
> > > Hmm... has this patch been queued up by anyone for the .34 merge
> > window?
> Still not in 2.6.34-rc3.  Are there any objections to this patch?  I've not
> heard any complaints since my original posting... or did it simply  
> get lost in
> the noise?

This patch still hasn't been picked up by a maintainer.

Are there any objections?

-Corinna Schultz
IBM LTC


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254Ab0CaVy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 17:54:27 -0400
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:56028 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754872Ab0CaVyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 17:54:25 -0400
Date: Thu, 1 Apr 2010 08:53:32 +1100
From: Dave Chinner <david@fromorbit.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: 4 stable kernel review cycles starting
Message-ID: <20100331215332.GH7671@dastard>
References: <20100330230338.GA28642@kroah.com>
 <20100331044445.GU3335@dastard>
 <20100331173831.GA9180@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100331173831.GA9180@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 10:38:31AM -0700, Greg KH wrote:
> On Wed, Mar 31, 2010 at 03:44:45PM +1100, Dave Chinner wrote:
> > On Tue, Mar 30, 2010 at 04:03:38PM -0700, Greg KH wrote:
> > > Hi all,
> > > 
> > > Well, I up and moved cities and caused a bunch of stable patches to be
> > > backlogged.  I've caught up with all of the ones that were marked as
> > > being wished to be applied to the stable trees, and still have a bunch
> > > of pending requests still queued up in my mailbox.
> > > 
> > > But, due to the number of the current patches already applied, it is
> > > time to just let these go and work on the other pending stuff after
> > > this.
> > 
> > Greg, I send a series of 19 patches for XFS updates to stable@kernel.org
> > back on the 12th March for 2.6.32 (subject was "[PATCH 0/19] xfs:
> > 2.6.32.y stable tree updates").
> > 
> > The patches were cc'd to the XFS list and they made it there:
> > 
> > http://oss.sgi.com/archives/xfs/2010-03/msg00125.html
> > 
> > so I'm wondering if you've got them queued up or not or whether
> > I need to resend them to you....
> > 
> > > So don't worry, if anyone has asked for some patches to be applied to
> > > some stable trees, and you don't see it here, just give it some time,
> > > I'm still catching up on things (hey, I'm just happy I have an internet
> > > connection again...)
> > 
> > I sent these prior to the last stable release that had this same
> > comment, so I didn't get worried that they had been missed. Now they
> > are missing from the next stable release, I'm getting worried. :/
> 
> Yes, they are still in my "to-apply" queue.  I also have a series of
> ext4 and kvm patches as well as a mess of wireless patches to wade
> through, so you are in good company.

Ok, I just wanted to make sure they were in the queue and not some
bit bucket somewhere.

> The issue is that applying individual patches like this is more
> "difficult" than just handling patches that are already marked in
> Linus's kernel tree as to be added to the stable queues.  So it
> takes a bit more time and effort to get to those patches, while
> still keeping up with the series like you, and other developers,
> sent.

Understood. Would providing a git tree to pull from for large series
like the XFS one make this easier for you in future? I can do that
bit of extra work if that makes things easier for you...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

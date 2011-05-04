Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab1EDXPz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 19:15:55 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:8018 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932080Ab1EDXPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 19:15:54 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlQEAJrawU15LBzagWdsb2JhbACmHhUBARYmJcdtDoV5BJ4B
Date: Thu, 5 May 2011 09:15:49 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
        minchan.kim@gmail.com
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
Message-ID: <20110504231549.GA25956@dastard>
References: <20110501080149.GD13542@dastard>
 <alpine.DEB.2.01.1105012135260.18728@trent.utfs.org>
 <20110502121958.GA2978@dastard>
 <alpine.DEB.2.01.1105021247410.18728@trent.utfs.org>
 <20110503005114.GE2978@dastard>
 <alpine.DEB.2.01.1105031345090.18728@trent.utfs.org>
 <alpine.DEB.2.01.1105031740460.18728@trent.utfs.org>
 <20110504073615.GD9114@dastard>
 <20110504111211.GF9114@dastard>
 <alpine.DEB.2.01.1105041205340.18728@trent.utfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.1105041205340.18728@trent.utfs.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 12:10:04PM -0700, Christian Kujau wrote:
> On Wed, 4 May 2011 at 21:12, Dave Chinner wrote:
> >> Ok, that will be helpful. Also helpful is that I've (FINALLY!)
> >> reproduced this myself, and i think i can now reproduce it at will
> >> on a highmem i686 machine. I'll look into it more later tonight....
> 
> I've tried to reproduce it on an SMP i686 with 1024MB RAM, but there was 
> no OOM there.
> 
> > And here's a patch for you to try. It fixes the problem on my test
> > machine.....
> 
> Excellent! After one run with that patch, the machine does not go OOM any 
> more when running du(1) over this XFS filesystem.

Ok, That is good to know that we are seeing the same problem ;)

I'll push the fix through the XFS tree to mainline. Thanks for all
your effort helping me understand and debug the problem, Christian.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

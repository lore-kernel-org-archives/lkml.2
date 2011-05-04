Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751219Ab1EDHgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 03:36:20 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:61534 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750837Ab1EDHgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 03:36:19 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAFEAwU15LBza/2dsb2JhbACmIXjEZg6FeQSdeA
Date: Wed, 4 May 2011 17:36:15 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
        minchan.kim@gmail.com
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
Message-ID: <20110504073615.GD9114@dastard>
References: <alpine.DEB.2.01.1104291250480.18728@trent.utfs.org>
 <20110429201701.GA13166@x4.trippels.de>
 <alpine.DEB.2.01.1104291710340.18728@trent.utfs.org>
 <20110501080149.GD13542@dastard>
 <alpine.DEB.2.01.1105012135260.18728@trent.utfs.org>
 <20110502121958.GA2978@dastard>
 <alpine.DEB.2.01.1105021247410.18728@trent.utfs.org>
 <20110503005114.GE2978@dastard>
 <alpine.DEB.2.01.1105031345090.18728@trent.utfs.org>
 <alpine.DEB.2.01.1105031740460.18728@trent.utfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.1105031740460.18728@trent.utfs.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 05:46:14PM -0700, Christian Kujau wrote:
> And another one, please see the files marked with 15- here:
> 
>    https://trent.utfs.org/p/bits/2.6.39-rc4/oom/trace/
> 
> I tried to have more concise timestamps in each of these files, hope that 
> helps. Sadly though, trace-cmd reports still segfaults on the tracefile.

Ok, that will be helpful. Also helpful is that I've (FINALLY!)
reproduced this myself, and i think i can now reproduce it at will
on a highmem i686 machine. I'll look into it more later tonight....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

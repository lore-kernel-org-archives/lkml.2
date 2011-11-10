Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935277Ab1KJPkJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 10:40:09 -0500
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:38681 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933707Ab1KJPkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 10:40:08 -0500
Date: Thu, 10 Nov 2011 10:40:03 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: =?iso-8859-1?B?Suly9G1l?= Pinot <ngc891@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Evolution of kernel size
Message-ID: <20111110154003.GA14012@elliptictech.com>
References: <20111110143333.GA29457@comet.deepsky.org>
 <20111110145902.GA13619@elliptictech.com>
 <20111110151548.GA8557@comet.deepsky.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111110151548.GA8557@comet.deepsky.org>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-11-11 00:15 +0900, Jérôme Pinot wrote:
> On 11/10/11 09:59, Nick Bowler wrote:
> > On 2011-11-10 23:33 +0900, Jérôme Pinot wrote:
> > > I took some time to make a graph of the evolution of the size of the
> > > linux kernel tar.bz2 since version 1.0 till 3.1 (297 releases).
> > > It doesn't count the stable branches (2.6.x.y).
> > > 
> > > Impressive, it's mostly exponential.
> > > If dev keeps same pace, we should break the 100MB at
> > > linux 3.19.
> > > 
> > > You can get the graph on my blog, I provide the data and the
> > > gnuplot batch file for graphing/fitting:
> > > http://ngc891.blogdns.net/?p=92 
> > > 
> > > It may interest some people :-)
> > 
> > What scale did you use for the horizontal axis?  I see numbers assigned
> > to each version in your gnuplot file, but no indication of how you came
> > up with them.
> 
> It's just the release count, one step for one release.
> 
> Some release are missing, mostly at the very beginning, I didn't find
> tarball for them but it doesn't matter much for the shape of the curve.

The problem with this is that the releases were not made at fixed
intervals.  2.6.0 -> 3.0 represents more than double the amount of
development time as 2.4 -> 2.6, yet they get roughly the same amount
of horizontal space on your plot.

I think it would be much more interesting to scale by release dates, so
that the gap between releases is proportional to the time between them.
I suspect you'll see a very different shape.

Furthermore, looking at the raw data, you gave 2.4.37 (released in 2008)
a lower release number than 2.6.0 (released in 2003), which seems odd.

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

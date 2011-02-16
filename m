Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab1BPWAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 17:00:18 -0500
Received: from kroah.org ([198.145.64.141]:55307 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755118Ab1BPWAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 17:00:12 -0500
Date: Wed, 16 Feb 2011 13:50:02 -0800
From: Greg KH <greg@kroah.com>
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
        Mark Lord <kernel@teksavvy.com>, Dave Chinner <david@fromorbit.com>,
        stable@kernel.org, Alex Elder <aelder@sgi.com>
Subject: Re: [stable] [GIT PULL] XFS update for 2.6.38-rc3
Message-ID: <20110216215002.GJ5027@kroah.com>
References: <201101311642.p0VGgXTS018851@stout.americas.sgi.com>
 <4D482E21.5040803@teksavvy.com>
 <20110203000757.GT11040@dastard>
 <201102032302.31780.a.miskiewicz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102032302.31780.a.miskiewicz@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 03, 2011 at 11:02:31PM +0100, Arkadiusz Miskiewicz wrote:
> On Thursday 03 of February 2011, Dave Chinner wrote:
> > On Tue, Feb 01, 2011 at 11:00:33AM -0500, Mark Lord wrote:
> > > On 11-01-31 11:42 AM, Alex Elder wrote:
> > > > Linus, please accept the following updates for XFS, for 2.6.38-rc3
> > > > (if it's not too late) or 2.6.38-rc4.
> > > > 
> > > > They are all fixes for bugs that have some pretty undesirable
> > > > consequences. 
> 
> [...]
> 
> > > Are these bugs all new in 2.6.38, or should some of these fixes
> > > also go out to -stable for earlier revisions?
> > > >       xfs: fix dquot shaker deadlock
> > 
> > That's a regression, so maybe.
> 
> Definitely, xfs_fsr can hit this even few times a day (happened already).
> 
> Stable team, please include this one for 2.6.37.1:

Now queued up (it will make .2, sorry, not .1)

thanks,

greg k-h

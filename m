Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762127Ab0GUFWl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:22:41 -0400
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:37847 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751980Ab0GUFVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 01:21:32 -0400
Date: Wed, 21 Jul 2010 15:21:28 +1000
From: Dave Chinner <david@fromorbit.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Shrinker fixes for XFS for 2.6.36-rc6
Message-ID: <20100721052128.GU32635@dastard>
References: <20100720004630.GH23223@dastard>
 <20100720233238.GS32635@dastard>
 <AANLkTil1kuHOTWRGe0o3j2dmrD9TLJSOqdF2IINp4aDx@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTil1kuHOTWRGe0o3j2dmrD9TLJSOqdF2IINp4aDx@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 20, 2010 at 04:35:14PM -0700, Linus Torvalds wrote:
> On Tue, Jul 20, 2010 at 4:32 PM, Dave Chinner <david@fromorbit.com> wrote:
> >
> > Ijust rebased the series - the shrinker context patch did not pickup
> > the new shrinker in the TTM DRM code for radeon. New pull-request output
> > below.
> 
> Not good. I already pulled the earlier version yesterday. So a rebased
> series is useless.

OK, I checked your public tree and didn't see it there before I did
the rebase. I'll send you a delta patch shortly.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

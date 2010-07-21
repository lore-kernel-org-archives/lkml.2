Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857Ab0GUFux (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:50:53 -0400
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:60835 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751106Ab0GUFuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 01:50:52 -0400
Date: Wed, 21 Jul 2010 15:50:48 +1000
From: Dave Chinner <david@fromorbit.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Shrinker conversion fixes
Message-ID: <20100721055048.GV32635@dastard>
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

Ok, here's the commit to fix the missing bits.

The following changes since commit f4b23cc2d5dc78ef5acbc529eb1219cc41eb5b96:

  Merge branch 'drm-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6 (2010-07-20 18:29:25 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfsdev shrinker

Dave Chinner (1):
      mm: add context argument to shrinker callback to remaining shrinkers

 drivers/gpu/drm/ttm/ttm_page_alloc.c |    2 +-
 net/sunrpc/auth.c                    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

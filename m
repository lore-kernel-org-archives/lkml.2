Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759241Ab2HWTWf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 15:22:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36504 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758133Ab2HWTWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 15:22:32 -0400
Date: Thu, 23 Aug 2012 12:22:27 -0700
From: Tejun Heo <tj@kernel.org>
To: Chris Wilson <chris@chris-wilson.co.uk>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] i915: use alloc_ordered_workqueue() instead of
 explicit UNBOUND w/ max_active = 1
Message-ID: <20120823192227.GB14962@google.com>
References: <20120822234057.GR19212@google.com>
 <1345708607_3773@CP5-2952>
 <20120823084325.GA5418@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120823084325.GA5418@phenom.ffwll.local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Aug 23, 2012 at 10:43:25AM +0200, Daniel Vetter wrote:
> On Thu, Aug 23, 2012 at 08:56:37AM +0100, Chris Wilson wrote:
> > On Wed, 22 Aug 2012 16:40:57 -0700, Tejun Heo <tj@kernel.org> wrote:
> > > This is an equivalent conversion and will ease scheduled removal of
> > > WQ_NON_REENTRANT.
> > > 
> > > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
> 
> Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch> for merging through any
> tree that pleases you (if it makes merging easier for WQ_NON_REENTRANT
> removal). Or should I just merge this through drm-intel-next?

I think it would be better to route this one through drm-intel-next.
WQ_NON_REENTRANT won't be deprecated until after the next -rc1 anyway.

Thanks!

-- 
tejun

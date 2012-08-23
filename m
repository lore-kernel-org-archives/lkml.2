Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273Ab2HWIn1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 04:43:27 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:54427 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756619Ab2HWInK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 04:43:10 -0400
Date: Thu, 23 Aug 2012 10:43:25 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tejun Heo <tj@kernel.org>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] i915: use alloc_ordered_workqueue() instead of explicit
 UNBOUND w/ max_active = 1
Message-ID: <20120823084325.GA5418@phenom.ffwll.local>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Tejun Heo <tj@kernel.org>, intel-gfx@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <20120822234057.GR19212@google.com>
 <1345708607_3773@CP5-2952>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345708607_3773@CP5-2952>
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 08:56:37AM +0100, Chris Wilson wrote:
> On Wed, 22 Aug 2012 16:40:57 -0700, Tejun Heo <tj@kernel.org> wrote:
> > This is an equivalent conversion and will ease scheduled removal of
> > WQ_NON_REENTRANT.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>

Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch> for merging through any
tree that pleases you (if it makes merging easier for WQ_NON_REENTRANT
removal). Or should I just merge this through drm-intel-next?
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48

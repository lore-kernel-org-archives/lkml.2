Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287Ab1AMAsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 19:48:10 -0500
Received: from mga01.intel.com ([192.55.52.88]:59274 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756495Ab1AMAsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 19:48:07 -0500
Message-Id: <b7da2f$q4ct63@fmsmga001.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,315,1291622400"; 
   d="scan'208";a="877032643"
Date: Thu, 13 Jan 2011 00:48:03 +0000
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] drm/i915/execbuffer: Reorder relocations to match new object order
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Dave Airlie <airlied@linux.ie>,
        linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTi=qHW3esgZYq55dgSz15ZDpukXn6zO17nJ1fWzS@mail.gmail.com>
References: <1294877597-17843-1-git-send-email-chris@chris-wilson.co.uk> <AANLkTi=qHW3esgZYq55dgSz15ZDpukXn6zO17nJ1fWzS@mail.gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Jan 2011 16:27:46 -0800, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Wed, Jan 12, 2011 at 4:13 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> >
> > This is what I'm running with at the moment. It only appears to affect the
> > slow path which hopefully explains why it is relatively infrequent...
> 
> I think you're still missing some case.
> 
> This improves the video case a lot - I can't see any artifacts there -
> but I still get occasional corruption when moving between the "share"
> and "rate" buttons, and they end up drawing incorrectly.

Now we're probably drifting into other bug territory... ;-)

I'll look again in the morning. Usually running the conformance test
suites in parallel is enough to exercise the worst-case behaviour.
-Chris
 
-- 
Chris Wilson, Intel Open Source Technology Centre

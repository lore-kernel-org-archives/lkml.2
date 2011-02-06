Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789Ab1BFOr5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 09:47:57 -0500
Received: from mga09.intel.com ([134.134.136.24]:14651 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739Ab1BFOr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 09:47:56 -0500
Message-Id: <b9dded$hs5ggh@orsmga002.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,433,1291622400"; 
   d="scan'208";a="599966225"
Date: Sun, 06 Feb 2011 14:47:51 +0000
To: Jeff Chua <jeff.chua.linux@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: Re: Commit 500f7147cf5bafd139056d521536b10c2bc2e154 breaks _resume_
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <AANLkTi=h+H+N=f4m4pE+RZ4n5h7oxQuwzmK-qmmWAGtL@mail.gmail.com> <s5hfws1whq8.wl%tiwai@suse.de> <AANLkTi=iHL+eVPRPzFXRMBZkXU7nXwkeZQiQUcyqSS-H@mail.gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <AANLkTi=iHL+eVPRPzFXRMBZkXU7nXwkeZQiQUcyqSS-H@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Feb 2011 22:01:22 +0800, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> It's the commit below. I've checked it twice. Reverting it solves the
> problem. Suspend to Ram ok. Upon resume, screen is blank. Keyboard
> hangs. Had to do a hard reset.

> >> commit 500f7147cf5bafd139056d521536b10c2bc2e154
> >> Author: Chris Wilson <chris@chris-wilson.co.uk>
> >> Date:   Mon Jan 24 15:14:41 2011 +0000
> >>
> >>     drm/i915: Reset state after a GPU reset or resume

Makes no difference to my x201s.

I would have thought a bisection would have resulted in either
f3269058e7a80083dcdf89698bfcd1a6c6f8fd12 or 
5d1d0cc87fc0887921993ea0742932e0c8adeda0

Can you try reverting those two to see if either of those is the true
culprit?
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre

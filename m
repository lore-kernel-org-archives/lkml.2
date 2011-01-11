Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409Ab1AKWbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 17:31:48 -0500
Received: from mga03.intel.com ([143.182.124.21]:45350 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755662Ab1AKWbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 17:31:45 -0500
Message-Id: <849307$b3r9rt@azsmga001.ch.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,309,1291622400"; 
   d="scan'208";a="373139325"
Date: Tue, 11 Jan 2011 22:31:37 +0000
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [git pull] drm for rc1
Cc: Dave Airlie <airlied@gmail.com>, Dave Airlie <airlied@linux.ie>,
        Eric Anholt <eric@anholt.net>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
In-Reply-To: <AANLkTinLmrSQ9cYvdu-pfEHizOjNGL5df4HfcSigvYpX@mail.gmail.com>
References: <alpine.DEB.2.00.1101102250090.15019@skynet.skynet.ie> <AANLkTinW8Yp1K1w+G+BgLa-fPaFANkGsRjqH_W8N+9VL@mail.gmail.com> <AANLkTim5oVZqMBtan5_TMOxaWbqkF=aDcBYFNYy55kt_@mail.gmail.com> <0aea052d-70ff-41ea-8776-c6d974c10337@email.android.com> <AANLkTim0rn7Vem6YJM5tVKM0PX4YdnNmaeqmpS=Vp7rc@mail.gmail.com> <AANLkTi=eRHbgerpdPYdoOo45LruNTk0rNsWvOO-kYxyQ@mail.gmail.com> <20110111111203.279eae50@jbarnes-desktop> <AANLkTikMMG1S6qp0-jKnQUcR5DgC+WWVfgOo2PExFA2w@mail.gmail.com> <AANLkTinLmrSQ9cYvdu-pfEHizOjNGL5df4HfcSigvYpX@mail.gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Jan 2011 14:16:54 -0800, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> The BUG_ON() that triggers is appended. And as mentioned, the jerky
> thing really seems to start happening in the exact same circumstance
> when this BUG_ON triggered.

Yes, that is the race in IRQ refcounting that I have an outstanding fix
for.

I've put the patches up on drm-intel-staging as I begin retesting them
before sending the pull request. In particular you need
01a03331e5fe91861937f8b8e72c259f5e9eae67.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre

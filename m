Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab1DEPMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:12:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:36902 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753657Ab1DEPMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 11:12:06 -0400
Message-Id: <1bdc18$k458om@fmsmga002.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,304,1299484800"; 
   d="scan'208";a="675455766"
Date: Tue, 05 Apr 2011 16:12:02 +0100
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Keith Packard <keithp@keithp.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Disable all outputs early, before KMS takeover
Cc: Tomas Winkler <tomasw@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>
References: <AANLkTi=VqkYjdiDLJvM-OfmBSGx-EkRkt=4XCDEnvZsU@mail.gmail.com> <1301395589-8121-1-git-send-email-chris@chris-wilson.co.uk> <20110401114429.GA3526@viiv.ffwll.ch> <AANLkTik6njOQTLGsB4KzPP-J=fE=p4CHopAyvsDzdDSF@mail.gmail.com> <BANLkTimUZY+2E=kXG-as8-moAAS4+F5bTg@mail.gmail.com> <b7da2f$qvoau5@fmsmga001.fm.intel.com> <BANLkTinXZVOy9-j4TiJ7HMcTvv9Q8RS+DA@mail.gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <BANLkTinXZVOy9-j4TiJ7HMcTvv9Q8RS+DA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Apr 2011 07:42:14 -0700, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> NO.

And you seemed to have missed that patch has sat around waiting for Pekka
to give me some information on the failure on his machine.

I have been poking as many people as I could to get it reviewed and tested
on more machines so that someone else could either spot the problem or
capture the oops.

I was being facetious in order to get a response. Thanks for playing,
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre

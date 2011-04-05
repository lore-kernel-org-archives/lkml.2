Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041Ab1DEKax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 06:30:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:26753 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129Ab1DEKav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 06:30:51 -0400
Message-Id: <b7da2f$qvoau5@fmsmga001.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,303,1299484800"; 
   d="scan'208";a="905718725"
Date: Tue, 05 Apr 2011 11:30:47 +0100
To: Tomas Winkler <tomasw@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Disable all outputs early, before KMS takeover
References: <AANLkTi=VqkYjdiDLJvM-OfmBSGx-EkRkt=4XCDEnvZsU@mail.gmail.com> <1301395589-8121-1-git-send-email-chris@chris-wilson.co.uk> <20110401114429.GA3526@viiv.ffwll.ch> <AANLkTik6njOQTLGsB4KzPP-J=fE=p4CHopAyvsDzdDSF@mail.gmail.com> <BANLkTimUZY+2E=kXG-as8-moAAS4+F5bTg@mail.gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <BANLkTimUZY+2E=kXG-as8-moAAS4+F5bTg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Apr 2011 13:21:08 +0300, Tomas Winkler <tomasw@gmail.com> wrote:
> On Fri, Apr 1, 2011 at 2:51 PM, Pekka Enberg <penberg@kernel.org> wrote:
> > Unfortunately I get a blank screen with after boot:
> > Nacked-by: Pekka Enberg <penberg@kernel.org>

But until you can tell me where it explodes on your system, we fix
issues on several other machines...
 
> Not sure this is related, but when I enable DRM_I915_KMS=y I'm got
> stuck after boot too. When KMS is disabled I can at least get to the
> console (no graphics)
> This is with kernel 2.6.39-rc1.  It worked fine with 2.6.38. I don't
> have much time bisect and reboot.  Shell I  try to pull drm-fixes for
> rc2 or use try this patch?

Add drm.debug=0xe to your grub kernel parameters and attach the dmesg for
the failing boot. From that I should be able to recommend a course of
action.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre

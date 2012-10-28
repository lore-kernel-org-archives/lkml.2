Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab2J1LLH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 07:11:07 -0400
Received: from mga14.intel.com ([143.182.124.37]:28653 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644Ab2J1LLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 07:11:05 -0400
Message-Id: <eeac1e$4q1mqm@AZSMGA002.ch.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,665,1344236400"; 
   d="scan'208";a="161536854"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: drm i915 hangs on heavy io load
To: Norbert Preining <preining@logic.at>
Cc: Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org
In-Reply-To: <20121028024753.GA4254@gamma.logic.tuwien.ac.at>
References: <20121023053830.GA30776@gamma.logic.tuwien.ac.at> <6c3329$6sai31@orsmga002.jf.intel.com> <20121023053830.GA30776@gamma.logic.tuwien.ac.at> <CAPM=9txr4TzuG-BbL0bXeEK6AzkOK9pH0kh-nP=Njv53sgFZew@mail.gmail.com> <20121024003659.GA30962@gamma.logic.tuwien.ac.at> <b94cdc$72fm1r@fmsmga001.fm.intel.com> <20121028024753.GA4254@gamma.logic.tuwien.ac.at>
Date: Sun, 28 Oct 2012 11:10:12 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Oct 2012 11:47:53 +0900, Norbert Preining <preining@logic.at> wrote:
> I pulled the whole branch into my compile branch, and removed everything
> from kernel cmd line regarding rc6, and got the
> 	[drm:i915_hangcheck_hung] *ERROR* Hangcheck timer elapsed... GPU hung
> 	[drm] capturing error event; look for more information in /debug/dri/0/i915_error_state
> 	[drm:i915_hangcheck_hung] *ERROR* Hangcheck timer elapsed... GPU hung
> 	[drm:i915_reset] *ERROR* GPU hanging too fast, declaring wedged!
> 	[drm:i915_reset] *ERROR* Failed to reset chip.
> new i915_error_state.gz at the same place.
> 
> So it seems that the patches in the ilk-wa-pile branch do not help.

Yeah, looks like we have another issue to contend with, so can you
please file a bug on bugzilla.freedesktop.org (or bugzilla.kernel.org)
so that we don't lose track of it.

If your have the option, can you switch the ddx between using SNA and
UXA. They stress different paths through the driver which may provide a
lue. Thanks,
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre

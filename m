Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964921Ab2JXAhG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 20:37:06 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:43545 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933678Ab2JXAhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 20:37:03 -0400
Date: Wed, 24 Oct 2012 09:36:59 +0900
To: Dave Airlie <airlied@gmail.com>, Chris Wilson <chris@chris-wilson.co.uk>
Cc: linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org
Subject: Re: drm i915 hangs on heavy io load
Message-ID: <20121024003659.GA30962@gamma.logic.tuwien.ac.at>
References: <20121023053830.GA30776@gamma.logic.tuwien.ac.at> <6c3329$6sai31@orsmga002.jf.intel.com> <20121023053830.GA30776@gamma.logic.tuwien.ac.at> <CAPM=9txr4TzuG-BbL0bXeEK6AzkOK9pH0kh-nP=Njv53sgFZew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c3329$6sai31@orsmga002.jf.intel.com> <CAPM=9txr4TzuG-BbL0bXeEK6AzkOK9pH0kh-nP=Njv53sgFZew@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave, hi Chris,

thanks for your answers.

On Di, 23 Okt 2012, Dave Airlie wrote:
> Does booting with i915.i915_enable_rc6=0 help?

No,booted with that, it happened again on a completely idle
system (well, I believe completely idle, I was doing the
dishes ;-)

[12437.995026] [drm:i915_hangcheck_hung] *ERROR* Hangcheck timer elapsed... GPU hung
[12437.995034] [drm] capturing error event; look for more information in /debug/dri/0/i915_error_state
[12438.000213] [drm:init_ring_common] *ERROR* failed to set render ring head to zero ctl 00000000 head 5ee06f14 tail 00000000 start 00003000
[12438.054894] [drm:init_ring_common] *ERROR* render ring initialization failed ctl 0001f001 head 5ee06f14 tail 00000000 start 00003000
[12439.583064] [drm:i915_hangcheck_hung] *ERROR* Hangcheck timer elapsed... GPU hung
[12439.583176] [drm:i915_reset] *ERROR* GPU hanging too fast, declaring wedged!
[12439.583182] [drm:i915_reset] *ERROR* Failed to reset chip.

New output see here:
http://www.logic.at/people/preining/i915_error_state.gz

> http://cgit.freedesktop.org/~danvet/drm/commit/?h=ilk-wa-pile&id=0d5fed2de763b49bb1a90140758153481f043757
> is the missing ingredient.

I am compiling a kernel with this patch based on current git now.
Should I still use the above kernel cmd argument (i915...rc6=0)
or try without it?

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
What are you talking about?
Never mind, eat the fruit.
You know, this place almost looks like the Garden of Eden.
Eat the fruit.
Sounds quite like it too.
                 --- Douglas Adams, The Hitchhikers Guide to the Galaxy

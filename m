Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750974Ab2J3Ajt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 20:39:49 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:45894 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab2J3Ajr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 20:39:47 -0400
Date: Tue, 30 Oct 2012 09:39:43 +0900
From: Norbert Preining <preining@logic.at>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org
Subject: Re: drm i915 hangs on heavy io load
Message-ID: <20121030003942.GC6539@gamma.logic.tuwien.ac.at>
References: <20121023053830.GA30776@gamma.logic.tuwien.ac.at> <6c3329$6sai31@orsmga002.jf.intel.com> <20121023053830.GA30776@gamma.logic.tuwien.ac.at> <CAPM=9txr4TzuG-BbL0bXeEK6AzkOK9pH0kh-nP=Njv53sgFZew@mail.gmail.com> <20121024003659.GA30962@gamma.logic.tuwien.ac.at> <b94cdc$72fm1r@fmsmga001.fm.intel.com> <20121028024753.GA4254@gamma.logic.tuwien.ac.at> <eeac1e$4q1mqm@AZSMGA002.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eeac1e$4q1mqm@AZSMGA002.ch.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

On So, 28 Okt 2012, Chris Wilson wrote:
> > I pulled the whole branch into my compile branch, and removed everything
> > from kernel cmd line regarding rc6, and got the
> > 	[drm:i915_hangcheck_hung] *ERROR* Hangcheck timer elapsed... GPU hung
> > 	[drm] capturing error event; look for more information in /debug/dri/0/i915_error_state
> > 	[drm:i915_hangcheck_hung] *ERROR* Hangcheck timer elapsed... GPU hung
> > 	[drm:i915_reset] *ERROR* GPU hanging too fast, declaring wedged!
> > 	[drm:i915_reset] *ERROR* Failed to reset chip.
> > new i915_error_state.gz at the same place.
> > 
> > So it seems that the patches in the ilk-wa-pile branch do not help.
> 
> Yeah, looks like we have another issue to contend with, so can you
> please file a bug on bugzilla.freedesktop.org (or bugzilla.kernel.org)
> so that we don't lose track of it.

I have seen this here:
	https://bugs.freedesktop.org/show_bug.cgi?id=55984
does it make sense to start a new bug for that?

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
SCREMBY (n.)
The dehydrated felt-tip pen attached by a string to the 'Don't Forget'
board in the kitchen which has never worked in living memory but which
no one can be bothered to throw away.
			--- Douglas Adams, The Meaning of Liff

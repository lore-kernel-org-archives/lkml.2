Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526Ab2KEAdL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 19:33:11 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:54677 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab2KEAdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 19:33:08 -0500
Date: Mon, 5 Nov 2012 09:33:03 +0900
From: Norbert Preining <preining@logic.at>
To: Dave Airlie <airlied@gmail.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: drm i915 hangs on heavy io load
Message-ID: <20121105003301.GB26121@gamma.logic.tuwien.ac.at>
References: <20121024003659.GA30962@gamma.logic.tuwien.ac.at> <b94cdc$72fm1r@fmsmga001.fm.intel.com> <20121028024753.GA4254@gamma.logic.tuwien.ac.at> <eeac1e$4q1mqm@AZSMGA002.ch.intel.com> <A941F80C-7EDB-4FCF-A8DE-4AE5532D2CB5@logic.at> <20121029071715.GA17023@mac.home> <20121030004958.GA6976@gamma.logic.tuwien.ac.at> <CAPM=9tw_0vDcRG25i2ypJEKT+JNqWzkXw2+jg=qj6H5M1hoJXg@mail.gmail.com> <20121104004431.GG6196@gamma.logic.tuwien.ac.at> <CAPM=9txgXLHQPCP4egU57P0=pACmKZnAzwgj6fNxR5-4nwOF6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM=9txgXLHQPCP4egU57P0=pACmKZnAzwgj6fNxR5-4nwOF6A@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On So, 04 Nov 2012, Dave Airlie wrote:
> Yeah thats fine, bisecting works by going to where commits were
> originally committed, so drm-intel-next was 3.6.0-rc2 at some point
> was only merged into Linus later.

Ok, thanks, didn't know that. Have started the bisect game now,
coming back in about 1 year ;-)

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
SCOPWICK (n.)
The flap of skin which is torn off you lip when trying to smoke an
untipped cigarette.
			--- Douglas Adams, The Meaning of Liff

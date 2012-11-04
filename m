Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab2KDAoo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 20:44:44 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:46701 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab2KDAol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 20:44:41 -0400
Date: Sun, 4 Nov 2012 09:44:31 +0900
From: Norbert Preining <preining@logic.at>
To: Dave Airlie <airlied@gmail.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: drm i915 hangs on heavy io load
Message-ID: <20121104004431.GG6196@gamma.logic.tuwien.ac.at>
References: <20121023053830.GA30776@gamma.logic.tuwien.ac.at> <CAPM=9txr4TzuG-BbL0bXeEK6AzkOK9pH0kh-nP=Njv53sgFZew@mail.gmail.com> <20121024003659.GA30962@gamma.logic.tuwien.ac.at> <b94cdc$72fm1r@fmsmga001.fm.intel.com> <20121028024753.GA4254@gamma.logic.tuwien.ac.at> <eeac1e$4q1mqm@AZSMGA002.ch.intel.com> <A941F80C-7EDB-4FCF-A8DE-4AE5532D2CB5@logic.at> <20121029071715.GA17023@mac.home> <20121030004958.GA6976@gamma.logic.tuwien.ac.at> <CAPM=9tw_0vDcRG25i2ypJEKT+JNqWzkXw2+jg=qj6H5M1hoJXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM=9tw_0vDcRG25i2ypJEKT+JNqWzkXw2+jg=qj6H5M1hoJXg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On Di, 30 Okt 2012, Dave Airlie wrote:
> I would suggest starting a bisect on drivers/gpu/drm/i915 from 3.6
> final to 3.7-rc1 or maybe -rc2.

Sorry for my ignorance ... I did on master branch
	$ git checkout v3.7-rc1
	...
	$ git bisect start drivers/gpu/drm/i915
	$ git bisect bad
	$ git bisect good v3.6
	Bisecting: 121 revisions left to test after this (roughly 7 steps)
	[25c5b2665fe4cc5a93edd29b62e7c05c15dddd26] drm/i915: implement new set_mode code flow
	$
after that I am back somewhere around
	3.6.0-rc2
???

Am I doing something wrong? I thought I am bisecting between 3.6 and 3.7.-rc2?
How can I go back to 3.6.0-rc2?

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
SCREEB (n.)
To make the noise of a nylon anorak rubbing against a pair of corduroy
trousers.
			--- Douglas Adams, The Meaning of Liff

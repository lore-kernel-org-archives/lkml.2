Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971Ab2J3AuF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 20:50:05 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:58249 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab2J3AuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 20:50:03 -0400
Date: Tue, 30 Oct 2012 09:49:58 +0900
From: Norbert Preining <preining@logic.at>
To: Chris Wilson <chris@chris-wilson.co.uk>, Dave Airlie <airlied@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: drm i915 hangs on heavy io load
Message-ID: <20121030004958.GA6976@gamma.logic.tuwien.ac.at>
References: <20121023053830.GA30776@gamma.logic.tuwien.ac.at> <6c3329$6sai31@orsmga002.jf.intel.com> <20121023053830.GA30776@gamma.logic.tuwien.ac.at> <CAPM=9txr4TzuG-BbL0bXeEK6AzkOK9pH0kh-nP=Njv53sgFZew@mail.gmail.com> <20121024003659.GA30962@gamma.logic.tuwien.ac.at> <b94cdc$72fm1r@fmsmga001.fm.intel.com> <20121028024753.GA4254@gamma.logic.tuwien.ac.at> <eeac1e$4q1mqm@AZSMGA002.ch.intel.com> <A941F80C-7EDB-4FCF-A8DE-4AE5532D2CB5@logic.at> <20121029071715.GA17023@mac.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121029071715.GA17023@mac.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mo, 29 Okt 2012, Tino Keitel wrote:
> Section "Device"
>         Option     "AccelMethod" "SNA"
>         Identifier  "Card0"
>         Driver      "intel"
> EndSection

Thanks, running now with SNA. Let us see what happens.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
RECULVER (n.)
The sort of remark only ever made during Any Questions.
			--- Douglas Adams, The Meaning of Liff

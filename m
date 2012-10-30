Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab2J3DN2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 23:13:28 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:36056 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761Ab2J3DN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 23:13:27 -0400
Date: Tue, 30 Oct 2012 12:13:22 +0900
From: Norbert Preining <preining@logic.at>
To: Ben Widawsky <ben@bwidawsk.net>
Cc: Dave Airlie <airlied@gmail.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: drm i915 hangs on heavy io load
Message-ID: <20121030031322.GA14213@gamma.logic.tuwien.ac.at>
References: <20121024003659.GA30962@gamma.logic.tuwien.ac.at> <b94cdc$72fm1r@fmsmga001.fm.intel.com> <20121028024753.GA4254@gamma.logic.tuwien.ac.at> <eeac1e$4q1mqm@AZSMGA002.ch.intel.com> <A941F80C-7EDB-4FCF-A8DE-4AE5532D2CB5@logic.at> <20121029071715.GA17023@mac.home> <20121030004958.GA6976@gamma.logic.tuwien.ac.at> <CAPM=9tw_0vDcRG25i2ypJEKT+JNqWzkXw2+jg=qj6H5M1hoJXg@mail.gmail.com> <20121030010138.GB6976@gamma.logic.tuwien.ac.at> <20121029183739.47eeb944@bwidawsk.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121029183739.47eeb944@bwidawsk.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mo, 29 Okt 2012, Ben Widawsky wrote:
> Hi Norbert. In addition to the above, if this truly appears to be
> related to i/o, can we try to decrease the time to failure with some

I am *not* sure. As I said, the last thing was shotwell photo
editing. It might be some io while loading the photos, but
after that they are in the cache, and the only thing is done is
lots of displaying.

> serious i/o tests? Off the top of my head I am not sure what's

Anyway, that is my idea. I think I don't need google. A simple
	svn up
on my 15Gb svn repository creates enough io. And doing some git pull
or so on same sized repositories in parallel brings anyway the
laptop to its knees (actually, badly to its knees).

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
Far out in the uncharted backwaters of the unfashionable
end of the western spiral arm of the Galaxy lies a small
unregarded yellow sun.
                 --- Douglas Adams, The Hitchhikers Guide to the Galaxy

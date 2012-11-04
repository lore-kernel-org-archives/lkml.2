Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939Ab2KDGIu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 01:08:50 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46508 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914Ab2KDGIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 01:08:49 -0500
MIME-Version: 1.0
In-Reply-To: <20121104004431.GG6196@gamma.logic.tuwien.ac.at>
References: <20121023053830.GA30776@gamma.logic.tuwien.ac.at>
	<CAPM=9txr4TzuG-BbL0bXeEK6AzkOK9pH0kh-nP=Njv53sgFZew@mail.gmail.com>
	<20121024003659.GA30962@gamma.logic.tuwien.ac.at>
	<b94cdc$72fm1r@fmsmga001.fm.intel.com>
	<20121028024753.GA4254@gamma.logic.tuwien.ac.at>
	<eeac1e$4q1mqm@AZSMGA002.ch.intel.com>
	<A941F80C-7EDB-4FCF-A8DE-4AE5532D2CB5@logic.at>
	<20121029071715.GA17023@mac.home>
	<20121030004958.GA6976@gamma.logic.tuwien.ac.at>
	<CAPM=9tw_0vDcRG25i2ypJEKT+JNqWzkXw2+jg=qj6H5M1hoJXg@mail.gmail.com>
	<20121104004431.GG6196@gamma.logic.tuwien.ac.at>
Date: Sun, 4 Nov 2012 16:08:47 +1000
Message-ID: <CAPM=9txgXLHQPCP4egU57P0=pACmKZnAzwgj6fNxR5-4nwOF6A@mail.gmail.com>
Subject: Re: drm i915 hangs on heavy io load
From: Dave Airlie <airlied@gmail.com>
To: Norbert Preining <preining@logic.at>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 4, 2012 at 10:44 AM, Norbert Preining <preining@logic.at> wrote:
> Hi all,
>
> On Di, 30 Okt 2012, Dave Airlie wrote:
>> I would suggest starting a bisect on drivers/gpu/drm/i915 from 3.6
>> final to 3.7-rc1 or maybe -rc2.
>
> Sorry for my ignorance ... I did on master branch
>         $ git checkout v3.7-rc1
>         ...
>         $ git bisect start drivers/gpu/drm/i915
>         $ git bisect bad
>         $ git bisect good v3.6
>         Bisecting: 121 revisions left to test after this (roughly 7 steps)
>         [25c5b2665fe4cc5a93edd29b62e7c05c15dddd26] drm/i915: implement new set_mode code flow
>         $
> after that I am back somewhere around
>         3.6.0-rc2
> ???
>
> Am I doing something wrong? I thought I am bisecting between 3.6 and 3.7.-rc2?
> How can I go back to 3.6.0-rc2?

Yeah thats fine, bisecting works by going to where commits were
originally committed, so drm-intel-next was 3.6.0-rc2 at some point
was only merged into Linus later.

Dave.

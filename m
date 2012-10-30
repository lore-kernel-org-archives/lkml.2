Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636Ab2J3BpQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 21:45:16 -0400
Received: from 209-20-75-48.static.cloud-ips.com ([209.20.75.48]:32987 "EHLO
	shiva.chad-versace.us" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab2J3BpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 21:45:14 -0400
X-Greylist: delayed 463 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Oct 2012 21:45:13 EDT
Date: Mon, 29 Oct 2012 18:37:39 -0700
From: Ben Widawsky <ben@bwidawsk.net>
To: Norbert Preining <preining@logic.at>
Cc: Dave Airlie <airlied@gmail.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: drm i915 hangs on heavy io load
Message-ID: <20121029183739.47eeb944@bwidawsk.net>
In-Reply-To: <20121030010138.GB6976@gamma.logic.tuwien.ac.at>
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
	<20121030010138.GB6976@gamma.logic.tuwien.ac.at>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2012 10:01:38 +0900
Norbert Preining <preining@logic.at> wrote:

> Hi Dave,
> 
> On Di, 30 Okt 2012, Dave Airlie wrote:
> > > Thanks, running now with SNA. Let us see what happens.
> > 
> > Please don't, we ain't going to find the bug any quicker changing
> > variables, if the only thing that changed on your system was the
> 
> Sorry, didn't know. I supposed from the email of Chris that I should
> try it "to stress different code path" ... anyway, disabling it again.
> 
> > How long does it take you to reproduce, and does it happen when in
> 
> Very hard to say, most of the times it is in a few days scale.
> Though it happened also after a few hours once.
> 
> > actual use. On my laptop I've noticed I come back to it sometimes
> > and
> 
> Concerning actual use: I had instances on several occassions. Just
> 30min ago it was while working with shotwell on my photo collection,
> tagging photos. So there should not be a big disk activity or so, but
> a lot of screen redraws etc when going through the photos.
> On other times it was locked screen without screen saver.
> 
> Concerning coming back: For me it never worked. I always have to
> reboot to get a working state again. Ok, to be more specific. GNome3
> is dead. I can close the windows normally with kbd shortcuts and some
> mouse interaction, but no new windows, no moving etc.
> 
> > gnome-shell is dead. This never happened pre 3.7-rc's. But for me
> > its a 3-4 day window so far for it to die, which makes bisecting it
> > a bit
> 
> That sounds pretty much like my case, but since I often don't use
> the laptop for 2 days or so, it might be a bit longer.
> 
> > of a major problem. and I'm just finished bisecting the last
> > Ironlake regression that took over a month.
> 
> Ouch ...
> 
> > I would suggest starting a bisect on drivers/gpu/drm/i915 from 3.6
> > final to 3.7-rc1 or maybe -rc2.
> 
> Ok, thanks. I will try.
> 
> Best wishes
> 
> Norbert

Hi Norbert. In addition to the above, if this truly appears to be
related to i/o, can we try to decrease the time to failure with some
serious i/o tests? Off the top of my head I am not sure what's
available, but surely Google should be able to find something.

-- 
Ben Widawsky, Intel Open Source Technology Center

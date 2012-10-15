Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab2JOReo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 13:34:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49779 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab2JORen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 13:34:43 -0400
Date: Mon, 15 Oct 2012 10:34:39 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org
Subject: Re: [PATCH] drm/i915: disable cpu relocs on ilk and earlier
Message-ID: <20121015173439.GA27365@kroah.com>
References: <1350288682-6236-1-git-send-email-daniel.vetter@ffwll.ch>
 <20121015151119.GB30606@kroah.com>
 <CAKMK7uHWB3d+tBkk6r4Es7xDhStY2ZfDyMTczEh1EXnq2xqP-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uHWB3d+tBkk6r4Es7xDhStY2ZfDyMTczEh1EXnq2xqP-w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 07:16:26PM +0200, Daniel Vetter wrote:
> On Mon, Oct 15, 2012 at 5:11 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Mon, Oct 15, 2012 at 10:11:22AM +0200, Daniel Vetter wrote:
> >> Hi Greg&stable-team,
> >>
> >> The below patch papers over a graphics corruption issue in 3.5/3.6. The
> >> regression happened due to pwrite tunings in 3.5, which made cpu relocations
> >> much more likely.
> >>
> >> The issue seems to have disappeared in 3.7-rc1, but it takes a few days to test
> >> a patch, so we haven't figured out what exactly fixed things. Now users are
> >> taking out their pitchforks already, so instead of wasting more days (maybe
> >> weeks?) to fully understand the bug before backporting the fix, we've opted for
> >> the below disable patch, which should have minimal impact (at most it undoes the
> >> tuning improvements in 3.5).
> >>
> >> Patch is tested by reporters & acked by all relevant ppl, please apply to
> >> 3.5/3.6 series kernels.
> >
> > No, I'd really like to wait until you figure out what is happening in
> > 3.7-rc1 right now before applying the patch.  We have the rule, "it must
> > be in Linus's tree first" for a very good reason :)
> >
> > So, I'll hold onto this until you say what's up with 3.7-rc1, ok?
> 
> Can do, might send a few pitchforks I collect your way though ;-)

No problem at all, I can handle them :)

> While I have your attention (and now that -rc1 is out), can you please
> pick up my two console_lock patches into your tty tree for 3.8?

Let me catch up on my 3.7 patches first please, I'm still on the road
traveling to conferences on different continents, and am in a conference
this week as well.  The fact that I'm waking up at the right time is
amazing...

greg k-h

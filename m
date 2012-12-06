Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946494Ab2LFSO5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 13:14:57 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53545 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946471Ab2LFSOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 13:14:55 -0500
Date: Thu, 6 Dec 2012 10:14:52 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Josh Boyer <jwboyer@gmail.com>
Cc: "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [ 67/89] drm/radeon: properly track the crtc not_enabled case
 evergreen_mc_stop()
Message-ID: <20121206181452.GA14700@kroah.com>
References: <20121203143146.549859007@decadent.org.uk>
 <20121203143156.904709715@decadent.org.uk>
 <CA+5PVA6P9EDYgt2WSXyX_fNsN26rG3a9j=7vk4b2SncwQ7am+A@mail.gmail.com>
 <A3397C8B8B789E45844E7EC5DEAD89D02DC1AF91@sausexdag04.amd.com>
 <CA+5PVA5TcMC7LyinWyK8mQww7RDT87MTetNY0jb2DqXh0b4zCw@mail.gmail.com>
 <A3397C8B8B789E45844E7EC5DEAD89D02DC1B172@sausexdag04.amd.com>
 <CA+5PVA4UGePVRD7VPqiTb4UDKQMyMeJvWkgPZ+U7e0oBCmYr9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA4UGePVRD7VPqiTb4UDKQMyMeJvWkgPZ+U7e0oBCmYr9A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2012 at 09:35:04AM -0500, Josh Boyer wrote:
> On Mon, Dec 3, 2012 at 6:40 PM, Deucher, Alexander
> <Alexander.Deucher@amd.com> wrote:
> >> > The original patches should go into 3.6 kernels as well:
> >> >
> >> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=4
> >> a15903db02026728d0cf2755c6fabae16b8db6a
> >> >
> >> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=6
> >> 2444b7462a2b98bc78d68736c03a7c4e66ba7e2
> >> >
> >> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=8
> >> 04cc4a0ad3a896ca295f771a28c6eb36ced7903
> >> >
> >> > I've been meaning to follow up on it, but I haven't had the time.  Do I need
> >> to send explicit patches to stable@vger or can I just ask the above commits
> >> be cherrypicked to 3.6?
> >> >
> >>
> >> Normally the CC tag works.  Not entirely sure why it didn't for the one
> >> patch I asked about.  The other two commits you've highlighted here are
> >> lacking any sort of stable tag, so you'd have to pipe up here about them.
> >
> > The patches were not initially a bug fix per se, so I didn't cc stable.  It was only later that I got reports of the patches fixing issues for some people. Normally I add the stable cc if the patch is a bug fix.
> >
> >>
> >> I went ahead and tried the cherry-pick myself on top of 3.6.9, in the
> >> order you specified above.  The 62444b7462a has a trivial conflict coming
> >> back.  I've attached an mbox with these three patches.  If you want to
> >> give them a glance over and OK them, that would be great.
> >
> > They look good to me.  Thanks!
> >
> > Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
> 
> Thanks Alex.
> 
> We've had a couple of users successfully test a kernel with these 3
> patches applied for rhbz 855275.
> 
> Greg, is the mbox enough or would you like me to send them separately
> to the list?

No need, I've used the mbox's patches, thanks.

greg k-h

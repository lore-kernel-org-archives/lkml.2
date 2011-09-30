Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758610Ab1I3OFt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 10:05:49 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:56877 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754466Ab1I3OFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 10:05:48 -0400
X-Sasl-enc: +g8FRVZoL+EKYi82nz3JNvLjqaUj6QgJeZ21OZPpKwfH 1317391547
Date: Fri, 30 Sep 2011 06:57:05 -0700
From: Greg KH <greg@kroah.com>
To: Keith Packard <keithp@keithp.com>
Cc: Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org
Subject: Re: [PATCH 00/24] MacBook Air patch sequence (v2)
Message-ID: <20110930135705.GC18646@kroah.com>
References: <20110923085243.6e4b7b4c@jbarnes-x220>
 <1317344993-24945-1-git-send-email-keithp@keithp.com>
 <20110930033356.GA11621@kroah.com>
 <yunsjne8kzu.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yunsjne8kzu.fsf@aiko.keithp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 01:58:29AM -0700, Keith Packard wrote:
> On Thu, 29 Sep 2011 20:33:56 -0700, Greg KH <greg@kroah.com> wrote:
> 
> > Are these really all -stable material?
> 
> I think just the sequence that actually makes the machine work; the
> scarier patches are those which reduce the mode setting time from 5-10s
> down to .7s.
> 
> Is this stretching the bounds of what is acceptable for -stable? Would
> it look better as a single patch, instead of 14 separate ones?

No, actually this makes it easier for -stable as each individual patch
fixes a problem, so in re-reading them, I have no objection for them to
go into -stable.

Would these also work on 3.0?

> > I'm all for enabling new hardware like this, and overall, the patches
> > aren't that bad, just want to verify this.
> 
> Let me know what you think; they'll be queued for 3.2 once they've
> gotten review and (I hope) more testing. It's Jesse's fault there are
> so many little patches; he asked me to split things up into separate
> functional changes. It's either that, or I'm just looking to increase
> the number of patches I have in the kernel.
> 
> > And, I do have to tell you, "curses, now I have no excuse to not buy
> > that laptop!"
> 
> I'd rather have a 'regular' PC; getting Debian installed on this machine
> was no picnic.

Due to UEFI stuff?  Or something else?

> But, I haven't seen anything else in this form factor that includes a
> display port connector.

I agree, it is a very nice hardware form factor that no other
manufacturer can seem to duplicate for the same (well, any) price these
days.

greg k-h

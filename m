Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051Ab0IZTWX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 15:22:23 -0400
Received: from kroah.org ([198.145.64.141]:60814 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757090Ab0IZTWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 15:22:23 -0400
Date: Sun, 26 Sep 2010 12:21:42 -0700
From: Greg KH <greg@kroah.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg KH <gregkh@suse.de>, "Hans J. Koch" <hjk@linutronix.de>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/5] uio hotplug support
Message-ID: <20100926192142.GA7252@kroah.com>
References: <m1y6b48973.fsf@fess.ebiederm.org> <20100917205946.GF2522@local> <m139t451b4.fsf_-_@fess.ebiederm.org> <20100924104555.GC1819@silverbox.local> <m1hbhfcbdo.fsf@fess.ebiederm.org> <20100924173106.GA4966@silverbox.local> <m14ode662q.fsf@fess.ebiederm.org> <20100925003308.GA29910@suse.de> <m1wrqa4mg5.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1wrqa4mg5.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 06:54:34PM -0700, Eric W. Biederman wrote:
> Greg KH <gregkh@suse.de> writes:
> 
> > On Fri, Sep 24, 2010 at 05:05:17PM -0700, Eric W. Biederman wrote:
> >> "Hans J. Koch" <hjk@linutronix.de> writes:
> >> 
> >> >
> >> > Hmm, I applied your first series of 5 patches (which I signed-off). When
> >> > trying to apply your second series, I get this from quilt:
> >> >
> >> > Applying patch 2_1-Simplify-the-lifetime-logic-of-struct-uio_device.patch
> >> > patching file drivers/uio/uio.c
> >> > Hunk #2 succeeded at 287 (offset 8 lines).
> >> > Hunk #3 succeeded at 312 (offset 8 lines).
> >> > Hunk #4 FAILED at 339.
> >> > Hunk #5 succeeded at 806 (offset 17 lines).
> >> > Hunk #6 FAILED at 831.
> >> > Hunk #7 FAILED at 858.
> >> > Hunk #8 FAILED at 889.
> >> > 4 out of 8 hunks FAILED -- rejects in file drivers/uio/uio.c
> >> > Patch 2_1-Simplify-the-lifetime-logic-of-struct-uio_device.patch does not apply (enforce with -f)
> >> >
> >> > The first series applied without any fuzz against 2.6.36-rc5.
> >> 
> >> I am stumped.  Do you perhaps have some local uio changes?
> >> 
> >> Using 2.6.36-rc5 as a base I tried it twice.  Once by taking my patches
> >> that I sent, and again by saving my email and then applying the changes.
> >> 
> >> Both times the changes applied cleanly.  No offsets, and no fuzz.  At
> >> least that is what git-am said.
> >> 
> >> Should I perhaps make a git branch you could pull?
> >
> > Try it on linux-next, as I've applied your previous patches there
> > already.
> 
> Done.  git-am on my saved mbox works without problems.  The worst
> I get is a warning about trailing whitespace.   Nothing that
> looks like the above.

Can you resend your patches?  I no longer have them in my queue as I was
waiting for Hans's ack and then he said they didn't apply so I purged
them.

thanks,

greg k-h

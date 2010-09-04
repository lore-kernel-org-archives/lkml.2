Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355Ab0IDXQI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 19:16:08 -0400
Received: from THUNK.ORG ([69.25.196.29]:33682 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754066Ab0IDXQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 19:16:07 -0400
Date: Sat, 4 Sep 2010 19:16:03 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org
Subject: Re: stable? quality assurance?
Message-ID: <20100904231603.GF4887@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Martin Steigerwald <Martin@lichtvoll.de>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	linux-kernel@vger.kernel.org
References: <201007110918.42120.Martin@lichtvoll.de>
 <201009041839.09261.Martin@lichtvoll.de>
 <4C829CFF.8080905@s5r6.in-berlin.de>
 <201009042221.43862.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009042221.43862.Martin@lichtvoll.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 04, 2010 at 10:21:34PM +0200, Martin Steigerwald wrote:
> Am Samstag 04 September 2010 schrieb Stefan Richter:
> > Martin Steigerwald wrote:
> > > I think main problem is that the current development process does not
> > > give time for quality work and bug fixing.
> > 
> > This has little to do with process.
> > 
> > Put simply, the paid developers work on what they are paid for.  The
> > volunteers work on what they are interested in.
> 
> And they are paid for features instead of fixing bugs? I doubt enterprise 
> customers have this preference. I admit, they have no reason to pay for 
> fixing my bug, unless they experience it too, however.

Kernel developers are paid to work on feature, yes.  They are not paid
to fix bugs for random folks who want run the latest stable kernel.

There are separate groups of people who work on stablizing kernels for
the community and enterprise kernels.  These folks tend to spend about
3 months stablizing a community distribution, and probably 6-9 months
stablizing a kernel for an enterprise distribution.  These folks also
tend to do most performance tuning on kernels destined for enterprise
kernels as well.  Obviously some developeres who happen to be employed
by distributions will help out in stablizing an enterprise kernel, but
usually they get called in to fix a bug after the testers have found
it.

You can argue that this maybe shouldn't be the way things work, but
you're not the ones paying the salaries for the enterprise
distributions.  I'm sure if enough enterprise distribution customers
were willing to pay the enterprise distro folks to stablizing each
2.6.x kernel, the distro's would put their people on it.  I know there
are some kernel developers who would prefer it if enterprise distro's
didn't spend so long stablizing the tree, but instead worked on
stablizing each and every mainline release.

> I will think a bit more about this. But my first impression is that all of 
> these provisions are currently in conflict with time for feature work. If 
> there is no stabilization or sorta of freeze period, the speed won't calm 
> down in order to give stabilizitation a realistic chance.

Again, you can't force developers to work on stablization.  Many will
work on bugs because they want their driver or their file system to
have a good reputation.  And we do have people like Rafael who tracks
regressions; if there is a regression, and the patch isn't being
accepted by the maintainer, nag the maintainer; make sure it's in the
kernel bugzilla, and nag Rafael, who normally will also ping
maintainers when there is a know bug fix.  In the worst case, send
mail to Linus.  You are empowered to do this.   So do it!

And BTW, if the fix is reported in -rc7, to be fair, sometimes the
maintainer simply won't have time to test and quality control the
patch before Linus does a release.  So having something show up in a
2.6.x.y release really isn't the end of the world.  And the bug did
get fixed.  It just didn't get fixed in time for *your* needs, but
especially in the case of drivers (and your problems seemed to be
mostly driver related problems), remember that sometimes the driver
maintainer is a volunteer.

(One of the advantages of sticking with an Intel video chipset is that
maintainer is paid by Intel to support the Intel video drivers, and he
is normally quite responsive.  In contrast, the Radeon support is, if
I recall correctly all done by volunteers, and regardless of whether
or not the driver maintainers are paid full-time to work on supporting
the driver, or volunteers, people do go on vacation during the summer
months...)

As far as whether or not a kernel stable, I think the answer is, it's
stable if it's stable for *you*.  As I've said, with the hardware I've
chosen, very often it's stable by -rc3 or -rc4.  For others, they may
need to wait until several 2.6.x.y releases have gone by.  I tend to
complain when drivers I care about are broken in the -rc2 or -rc3 time
frame.  But if people wait until -rc7 to try out the kernel, then it
might not get fixed before 2.6.35 comes out.

						- Ted

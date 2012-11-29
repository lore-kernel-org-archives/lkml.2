Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991Ab2K2HmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 02:42:18 -0500
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1678 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab2K2HmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 02:42:17 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH v3 0/9] Media Controller capture driver for DM365
Date: Thu, 29 Nov 2012 08:40:40 +0100
User-Agent: KMail/1.13.7 (Linux/3.7.0-rc1-tschai; KDE/4.8.4; x86_64; ; )
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        devel@driverdev.osuosl.org,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Prabhakar Lad <prabhakar.lad@ti.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        LMML <linux-media@vger.kernel.org>
References: <1354099329-20722-1-git-send-email-prabhakar.lad@ti.com> <20121128212952.GP11248@mwanda> <50B6A29D.9050004@gmail.com>
In-Reply-To: <50B6A29D.9050004@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201211290840.40670.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu November 29 2012 00:47:41 Sylwester Nawrocki wrote:
> On 11/28/2012 10:29 PM, Dan Carpenter wrote:
> > On Wed, Nov 28, 2012 at 08:30:04PM +0100, Sylwester Nawrocki wrote:
> >> On 11/28/2012 01:22 PM, Dan Carpenter wrote:
> >>> In the end this is just a driver, and I don't especially care.  But
> >>> it's like not just this one which makes me frustrated.  I really
> >>> believe in linux-next and I think everything should spend a couple
> >>> weeks there before being merged.
> >>
> >> Couple of weeks in linux-next plus a couple of weeks of final patch
> >> series version awaiting to being reviewed and picked up by a maintainer
> >> makes almost entire kernel development cycle. These are huge additional
> >> delays, especially in the embedded world. Things like these certainly
> >> aren't encouraging for moving over from out-of-tree to the mainline
> >> development process. And in this case we are talking only about merging
> >> driver to the staging tree...
> >
> > Yeah.  A couple weeks is probably too long.  But I think a week is
> > totally reasonable.
> 
> Agreed, exactly that couple weeks requirement seemed a bit long to me.
> 
> > You have the process wrong.  The maintainer reviews it first, merges
> > it into his -next git tree.  It sits in linux-next for a bit.  The
> > merge window opens up.  It is merged.  It gets tested for 3 months.
> > It is released.
> 
> I believe what you're describing is true for most subsystems.  At
> linux-media the process looks roughly that you prepare a patch and post
> it to the mailing list for review.  Regular developers review it, you
> address the comments and submit again.  Repeat these steps until
> everyone's happy.  Then, when the patch looks like it is ready for
> merging it is preferred to send the maintainer a pull request.
> Now there can be a delay of up to couple weeks.  Afterwards the patch
> in most cases gets merged, with a few possible change requests. However
> it may happen the maintainer has different views on what's has been
> agreed before and you start everything again.

Yes, and the problem is that the maintainer (Mauro) tends to look at this
close to the merge window, generally leaving you with very little time to
make adjustments.

In all honesty, in this particular case the pull request came in late
because other reviewers asked TI to move the driver to staging because we
thought the driver wasn't quite ready yet.

If it would just be merged as a staging driver, then it would most likely
be sitting in linux-next by now since a few days, well in time for the merge
window. Instead we are having this whole discussion :-(

> With a few sub-maintainers recently appointed hopefully there can be
> seen some improvement.

I sincerely hope so. Of course, since I'm going to be one of the sub-maintainers
I'm going to see this from the other side as well, so I might get the same
critisism in the future :-)

> > It should work as a continuous even flow.  It shouldn't be a rush to
> > submit drivers right before the merge window opens.  It's not hard,
> > you can submit a driver to linux-next at any time.  It magically
> > flows through the process and is released some months later.
> >
> > It does suck to add a 3 month delay for people who miss the cut off.
> > Don't wait until the last minute.  In the embedded world you can
> > use git cherry-pick to get the driver from linux-next.
> 
> Yeah, it's not unusual to work with specific -rc tree with multiple
> subsystem -next branches on top of it.
> 
> It's just those cases where you're told to get feature A in the kernel
> release X and it is already late in the development cycle... But it
> might just be a matter of planning the work adequately with proper
> understanding of the whole process.

Well, it would work if you can rely on patches being reviewed and merged
in a timely manner. Hopefully that will happen when the sub-maintainers
can start next year. It should make everything more predictable.

Regards,

	Hans

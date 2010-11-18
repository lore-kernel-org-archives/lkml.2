Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043Ab0KRHRt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 02:17:49 -0500
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3530 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856Ab0KRHRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 02:17:48 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Pavan Savoy <pavan_savoy@ti.com>
Subject: Re: [PATCH v4 0/6] FM V4L2 drivers for WL128x
Date: Thu, 18 Nov 2010 08:17:39 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc2-tschai; KDE/4.4.5; x86_64; ; )
Cc: "Ohad Ben-Cohen" <ohad@wizery.com>, mchehab@infradead.org,
        manjunatha_halli@ti.com, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
References: <1289913494-21590-1-git-send-email-manjunatha_halli@ti.com> <AANLkTi=ZT0E=A9ZYAM86qu4P8eStkF2PLep6-DofCX-s@mail.gmail.com> <AANLkTinyaZ07HBFNHNyR9eK6__QdZtG6O1gQX1F+YRB9@mail.gmail.com>
In-Reply-To: <AANLkTinyaZ07HBFNHNyR9eK6__QdZtG6O1gQX1F+YRB9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201011180817.39801.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 18, 2010 06:54:16 Pavan Savoy wrote:
> Hans, Mauro, Ohad,
> 
> On Wed, Nov 17, 2010 at 6:32 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> > Hi Manjunatha,
> >
> > On Tue, Nov 16, 2010 at 3:18 PM,  <manjunatha_halli@ti.com> wrote:
> >>  drivers/staging/ti-st/Kconfig        |   10 +
> >>  drivers/staging/ti-st/Makefile       |    2 +
> >>  drivers/staging/ti-st/fmdrv.h        |  259 ++++
> >>  drivers/staging/ti-st/fmdrv_common.c | 2141 ++++++++++++++++++++++++++++++++++
> >>  drivers/staging/ti-st/fmdrv_common.h |  458 ++++++++
> >>  drivers/staging/ti-st/fmdrv_rx.c     |  979 ++++++++++++++++
> >>  drivers/staging/ti-st/fmdrv_rx.h     |   59 +
> >>  drivers/staging/ti-st/fmdrv_tx.c     |  461 ++++++++
> >>  drivers/staging/ti-st/fmdrv_tx.h     |   37 +
> >>  drivers/staging/ti-st/fmdrv_v4l2.c   |  757 ++++++++++++
> >>  drivers/staging/ti-st/fmdrv_v4l2.h   |   32 +
> >>  11 files changed, 5195 insertions(+), 0 deletions(-)
> >
> > Usually when a driver is added to staging, it should also have a TODO
> > file specifying what needs to be done before the driver can be taken
> > out of staging (at least as far as the author knows of today).
> >
> > It helps keeping track of the open issues in the driver, which is good
> > for everyone - the author, the random contributor/observer, and
> > probably even the staging maintainer.
> >
> > Can you please add such a TODO file ?
> >
> > Thanks,
> > Ohad.
> 
> Thanks Ohad, for the comments, We do have an internal TODO.
> In terms of functionality we have stuff like TX RDS which already has
> few CIDs in the extended controls.
> extend V4L2 for complete-scan, add in stop search during hw_seek .. etc...
> But I just wanted to ask whether this is good enough to be staged.
> Because as we begin to implement and add in the items in TODO - the
> patch set will keep continuing to grow.
> 
> So Hans, Mauro, What do you think ?
> It would be real helpful - if this can be staged, it is becoming
> difficult to maintain for us.

I have no problem with it going to staging. It is not yet ready for the
mainline. I'll try to do a quick review and point out what needs to be
changed.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco

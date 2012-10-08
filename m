Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab2JHPUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 11:20:38 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:43184 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab2JHPUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 11:20:32 -0400
MIME-Version: 1.0
In-Reply-To: <201210081104.58789.hverkuil@xs4all.nl>
References: <1337620326-18593-1-git-send-email-manjunatha_halli@ti.com> <201210081104.58789.hverkuil@xs4all.nl>
From: halli manjunatha <hallimanju@gmail.com>
Date: Mon, 8 Oct 2012 10:20:09 -0500
Message-ID: <CAMT6PyccUxdkT1jrrzHbQFw-UMBO9XXBWbCnatOz+Gt591T9dQ@mail.gmail.com>
Subject: Re: [PATCH V7 0/5] [Media] Radio: Fixes and New features for FM
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Manjunatha Halli <x0130808@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans,

Sure.. right now I am busy with some other work so I will submit the
V8 within few days :)

Manju

On Mon, Oct 8, 2012 at 4:04 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> Hi Manjunatha,
>
> Can you make a v8? The tuner band issues have been settled and are now
> merged,
> so it would be good to finalize this.
>
> On Mon May 21 2012 19:12:01 manjunatha_halli@ti.com wrote:
> > From: Manjunatha Halli <x0130808@ti.com>
> >
> > Mauro and the list,
> >
> > This version 7 of patchset resolves the comments received from
> > Han's on patchset v6. Also removed the frequency band handling
> > from this patch set.
> >
> > This patchset creates new control class 'V4L2_CTRL_CLASS_FM_RX' for FM
> > RX,
> > introduces 2 new CID's for FM RX and and 1 new CID for FM TX. Also adds
> > 1
> > field in struct v4l2_hw_freq_seek.
> >
> > This patch adds few new features to TI's FM driver features
> > are listed below,
> >
> > 1) FM TX RDS Support (RT, PS, AF, PI, PTY)
> > 2) FM RX Russian band support
> > 3) FM RX AF set/get
> > 4) FM RX De-emphasis mode set/get
> >
> > Along with new features this patch also fixes few issues in the driver
> > like default rssi level for seek, unnecessory logs etc.
> >
> > Manjunatha Halli (5):
> >   WL128x: Add support for FM TX RDS
> >   New control class and features for FM RX
> >   Add new CID for FM TX RDS Alternate Frequency
> >   Media: Update docs for V4L2 FM new features
> >   WL12xx: Add support for FM new features
> >
> >  Documentation/DocBook/media/v4l/compat.xml         |    3 +
> >  Documentation/DocBook/media/v4l/controls.xml       |   77
> > ++++++++++++++++++++
> >  Documentation/DocBook/media/v4l/dev-rds.xml        |    5 +-
> >  .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |    7 ++
> >  drivers/media/radio/wl128x/fmdrv.h                 |    2 +-
> >  drivers/media/radio/wl128x/fmdrv_common.c          |   30 +++++---
> >  drivers/media/radio/wl128x/fmdrv_common.h          |   25 +++++--
> >  drivers/media/radio/wl128x/fmdrv_rx.c              |   13 +++-
> >  drivers/media/radio/wl128x/fmdrv_tx.c              |   41 +++++------
> >  drivers/media/radio/wl128x/fmdrv_tx.h              |    3 +-
> >  drivers/media/radio/wl128x/fmdrv_v4l2.c            |   74
> > +++++++++++++++++++
> >  drivers/media/video/v4l2-ctrls.c                   |   18 ++++-
> >  include/linux/videodev2.h                          |   10 +++
> >  13 files changed, 255 insertions(+), 53 deletions(-)
> >
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




--
Regards
Halli

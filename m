Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506Ab2JHJFK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 05:05:10 -0400
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3317 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab2JHJFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 05:05:05 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: manjunatha_halli@ti.com
Subject: Re: [PATCH V7 0/5] [Media] Radio: Fixes and New features for FM
Date: Mon, 8 Oct 2012 11:04:58 +0200
User-Agent: KMail/1.13.7 (Linux/3.6.0-rc5-tschai; KDE/4.8.4; x86_64; ; )
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Manjunatha Halli <x0130808@ti.com>
References: <1337620326-18593-1-git-send-email-manjunatha_halli@ti.com>
In-Reply-To: <1337620326-18593-1-git-send-email-manjunatha_halli@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201210081104.58789.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Manjunatha,

Can you make a v8? The tuner band issues have been settled and are now merged,
so it would be good to finalize this.

On Mon May 21 2012 19:12:01 manjunatha_halli@ti.com wrote:
> From: Manjunatha Halli <x0130808@ti.com>
> 
> Mauro and the list,
> 
> This version 7 of patchset resolves the comments received from
> Han's on patchset v6. Also removed the frequency band handling
> from this patch set.
> 
> This patchset creates new control class 'V4L2_CTRL_CLASS_FM_RX' for FM RX,
> introduces 2 new CID's for FM RX and and 1 new CID for FM TX. Also adds 1
> field in struct v4l2_hw_freq_seek.
> 
> This patch adds few new features to TI's FM driver features
> are listed below,
> 
> 1) FM TX RDS Support (RT, PS, AF, PI, PTY)          
> 2) FM RX Russian band support
> 3) FM RX AF set/get
> 4) FM RX De-emphasis mode set/get
> 
> Along with new features this patch also fixes few issues in the driver
> like default rssi level for seek, unnecessory logs etc.
> 
> Manjunatha Halli (5):
>   WL128x: Add support for FM TX RDS
>   New control class and features for FM RX
>   Add new CID for FM TX RDS Alternate Frequency
>   Media: Update docs for V4L2 FM new features
>   WL12xx: Add support for FM new features
> 
>  Documentation/DocBook/media/v4l/compat.xml         |    3 +
>  Documentation/DocBook/media/v4l/controls.xml       |   77 ++++++++++++++++++++
>  Documentation/DocBook/media/v4l/dev-rds.xml        |    5 +-
>  .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |    7 ++
>  drivers/media/radio/wl128x/fmdrv.h                 |    2 +-
>  drivers/media/radio/wl128x/fmdrv_common.c          |   30 +++++---
>  drivers/media/radio/wl128x/fmdrv_common.h          |   25 +++++--
>  drivers/media/radio/wl128x/fmdrv_rx.c              |   13 +++-
>  drivers/media/radio/wl128x/fmdrv_tx.c              |   41 +++++------
>  drivers/media/radio/wl128x/fmdrv_tx.h              |    3 +-
>  drivers/media/radio/wl128x/fmdrv_v4l2.c            |   74 +++++++++++++++++++
>  drivers/media/video/v4l2-ctrls.c                   |   18 ++++-
>  include/linux/videodev2.h                          |   10 +++
>  13 files changed, 255 insertions(+), 53 deletions(-)
> 
> 

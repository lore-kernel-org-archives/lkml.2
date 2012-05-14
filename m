Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481Ab2ENVqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 17:46:18 -0400
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4662 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932425Ab2ENVqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 17:46:17 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: manjunatha_halli@ti.com
Subject: Re: [PATCH V6 0/5] [Media] Radio: Fixes and New features for FM
Date: Mon, 14 May 2012 23:46:12 +0200
User-Agent: KMail/1.13.7 (Linux/3.4.0-rc3-durdane; KDE/4.7.4; x86_64; ; )
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Manjunatha Halli <x0130808@ti.com>
References: <1337027244-2595-1-git-send-email-manjunatha_halli@ti.com>
In-Reply-To: <1337027244-2595-1-git-send-email-manjunatha_halli@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205142346.12781.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon May 14 2012 22:27:19 manjunatha_halli@ti.com wrote:
> From: Manjunatha Halli <x0130808@ti.com>
> 
> Mauro and the list,
>     
> This version 6 of patchset resolves the comments received from
> Han's on patchset v5.
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

For the whole patch series (just report a fixed version of patch 2/5):

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> 
> Manjunatha Halli (5):
>   WL128x: Add support for FM TX RDS
>   New control class and features for FM RX
>   Add new CID for FM TX RDS Alternate Frequency
>   Media: Update docs for V4L2 FM new features
>   WL12xx: Add support for FM new features.
> 
>  Documentation/DocBook/media/v4l/compat.xml         |    3 +
>  Documentation/DocBook/media/v4l/controls.xml       |   77 ++++++++++
>  Documentation/DocBook/media/v4l/dev-rds.xml        |    5 +-
>  .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |    7 +
>  Documentation/DocBook/media/v4l/vidioc-g-tuner.xml |   25 ++++
>  .../DocBook/media/v4l/vidioc-s-hw-freq-seek.xml    |   38 +++++-
>  drivers/media/radio/wl128x/fmdrv.h                 |    3 +-
>  drivers/media/radio/wl128x/fmdrv_common.c          |   55 ++++++--
>  drivers/media/radio/wl128x/fmdrv_common.h          |   43 +++++-
>  drivers/media/radio/wl128x/fmdrv_rx.c              |   92 ++++++++++---
>  drivers/media/radio/wl128x/fmdrv_rx.h              |    2 +-
>  drivers/media/radio/wl128x/fmdrv_tx.c              |   41 +++---
>  drivers/media/radio/wl128x/fmdrv_tx.h              |    3 +-
>  drivers/media/radio/wl128x/fmdrv_v4l2.c            |  148 +++++++++++++++++++-
>  drivers/media/video/v4l2-ctrls.c                   |   18 ++-
>  include/linux/videodev2.h                          |   25 +++-
>  16 files changed, 503 insertions(+), 82 deletions(-)
> 
> 

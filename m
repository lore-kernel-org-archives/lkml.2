Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab2FNSi2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 14:38:28 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:54458 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab2FNSi0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 14:38:26 -0400
MIME-Version: 1.0
In-Reply-To: <1337620326-18593-1-git-send-email-manjunatha_halli@ti.com>
References: <1337620326-18593-1-git-send-email-manjunatha_halli@ti.com>
From: halli manjunatha <hallimanju@gmail.com>
Date: Thu, 14 Jun 2012 13:38:04 -0500
Message-ID: <CAMT6PyfWOiL2rPBiRARTfmF=uLLrDGNQY_1SM2685ObO6U3-Bw@mail.gmail.com>
Subject: Re: [PATCH V7 0/5] [Media] Radio: Fixes and New features for FM
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Manjunatha Halli <x0130808@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

Please pull these patches to K3.6, these patches are reviewed and Acked-By Hans.

Regards
Manju

On Mon, May 21, 2012 at 12:12 PM,  <manjunatha_halli@ti.com> wrote:
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
>  WL128x: Add support for FM TX RDS
>  New control class and features for FM RX
>  Add new CID for FM TX RDS Alternate Frequency
>  Media: Update docs for V4L2 FM new features
>  WL12xx: Add support for FM new features
>
>  Documentation/DocBook/media/v4l/compat.xml         |    3 +
>  Documentation/DocBook/media/v4l/controls.xml       |   77 ++++++++++++++++++++
>  Documentation/DocBook/media/v4l/dev-rds.xml        |    5 +-
>  .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |    7 ++
>  drivers/media/radio/wl128x/fmdrv.h                 |    2 +-
>  drivers/media/radio/wl128x/fmdrv_common.c          |   30 +++++---
>  drivers/media/radio/wl128x/fmdrv_common.h          |   25 +++++--
>  drivers/media/radio/wl128x/fmdrv_rx.c              |   13 +++-
>  drivers/media/radio/wl128x/fmdrv_tx.c              |   41 +++++------
>  drivers/media/radio/wl128x/fmdrv_tx.h              |    3 +-
>  drivers/media/radio/wl128x/fmdrv_v4l2.c            |   74 +++++++++++++++++++
>  drivers/media/video/v4l2-ctrls.c                   |   18 ++++-
>  include/linux/videodev2.h                          |   10 +++
>  13 files changed, 255 insertions(+), 53 deletions(-)
>
> --
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Regards
Halli

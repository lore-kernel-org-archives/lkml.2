Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751202Ab2DREdZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 00:33:25 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59956 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab2DREdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 00:33:24 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH 00/12] Fix use of version.h
Date: Wed, 18 Apr 2012 01:30:00 -0300
Message-Id: <1334723412-5034-1-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

After run "make versioncheck", the output of the tool show some places that we 
need to include the header version.h, and some places that we need to remove.

This patch set aims to fix all issues of using version.h.

This is my first patch set, so if I forgot something, please let me know :)

Marcos Paulo de Souza (12):
  drivers: block: mtip32xx: mtip32xx.h: Remove unnneeded include of
    version.h
  drivers: gpu: drm: gma500: mdfld_dsi_output.h: Remove not unneeded
    include of version.h
  drivers: media: dvb: ddbridge: ddbridge-code: Remove unneeded include
    of version.h
  drivers: media: radio: radio-keene.c: Remove unneeded include of
    version.h
  drivers: media: video: adp1653.c: Remove unneeded include of
    version.h
  drivers: media: video: tlg2300: pd-video.c: Include version.h header
  drivers: media: video: tm6000: tm6000.h: Include version.h header
  drivers: staging: media: as102: as102fe.c: Remove include of
    version.h
  drivers: staging: media: as102: as102_usb_drv.h: Remove include of
    version.h
  drivers: staging: media: easycap: easycap_ioctl: Include version.h
    header
  drivers: staging: rtl8172: Remove unneeded include of version.h
  drivers: staging: vme: devices: Remove unneeded include version.h

 drivers/block/mtip32xx/mtip32xx.h             |    1 -
 drivers/gpu/drm/gma500/mdfld_dsi_output.h     |    1 -
 drivers/media/dvb/ddbridge/ddbridge-core.c    |    1 -
 drivers/media/radio/radio-keene.c             |    1 -
 drivers/media/video/adp1653.c                 |    1 -
 drivers/media/video/tlg2300/pd-video.c        |    1 +
 drivers/media/video/tm6000/tm6000.h           |   13 +++++++------
 drivers/staging/media/as102/as102_fe.c        |    2 --
 drivers/staging/media/as102/as102_usb_drv.h   |    2 --
 drivers/staging/media/easycap/easycap_ioctl.c |    1 +
 drivers/staging/rtl8712/osdep_service.h       |    1 -
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c |    1 -
 drivers/staging/vme/devices/vme_pio2_core.c   |    1 -
 drivers/staging/vme/devices/vme_pio2_gpio.c   |    1 -
 14 files changed, 9 insertions(+), 19 deletions(-)

-- 
1.7.7.6


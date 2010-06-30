Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071Ab0F3PYc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 11:24:32 -0400
Received: from kroah.org ([198.145.64.141]:39958 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756715Ab0F3PY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 11:24:28 -0400
Date: Wed, 30 Jun 2010 08:23:34 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [GIT PATCH] STAGING fixes for 2.6.35-git
Message-ID: <20100630152334.GC11236@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a few bugfixes for the drivers/staging tree as well as a few
device id updates.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/staging-2.6.git/

All of these patches have been in the linux-next and mm trees.

The patches will be sent as a follow-on to this message to the
driver-devel list for people to see.

thanks,

greg k-h

--------------

 drivers/staging/batman-adv/bat_sysfs.c             |   24 +++++-----
 drivers/staging/batman-adv/device.c                |    2 +-
 drivers/staging/comedi/drivers/adl_pci9111.c       |    9 +++-
 drivers/staging/comedi/drivers/cb_pcidda.c         |    3 +-
 drivers/staging/hv/channel_mgmt.c                  |   41 +++++++++++++-----
 drivers/staging/hv/hv_utils.c                      |   28 ++++++++++++
 drivers/staging/hv/vmbus.h                         |    2 +
 drivers/staging/hv/vmbus_drv.c                     |    3 +
 drivers/staging/mrst-touchscreen/intel-mid-touch.c |    2 +-
 drivers/staging/rt2860/usb_main_dev.c              |    1 +
 drivers/staging/rtl8187se/r8180_core.c             |    2 -
 drivers/staging/rtl8192su/r8192U_core.c            |   43 +++++++++---------
 drivers/staging/rtl8192u/r8192U_core.c             |    2 +
 drivers/staging/usbip/usbip_common.c               |   46 ++++++++++++++------
 drivers/staging/wlags49_h2/wl_enc.c                |    1 +
 drivers/staging/wlags49_h2/wl_sysfs.h              |    4 +-
 16 files changed, 145 insertions(+), 68 deletions(-)

---------------

Ben Hutchings (2):
      Staging: rtl8192s_usb: Remove duplicate device ID
      Staging: rtl8192u_usb: Add LG device ID 043e:7a01

Dan Carpenter (3):
      Staging: batman-adv: return -EFAULT on copy_to_user errors
      Staging: mrst-touchscreen: fix dereferencing free memory
      Staging: comedi: fix read past end of array in cb_pcidda_attach()

Florian Schilhabel (2):
      Staging: rtl8192su: remove device ids
      Staging: rtl8192su: add device ids

Haiyang Zhang (2):
      staging: hv: Fix race condition on vmbus channel initialization
      Staging: hv: fix hv_utils module to properly autoload

Himanshu Chauhan (1):
      staging: usbip: usbip_common: kill rx thread on tx thread creation error.

Ian Abbott (1):
      Staging: comedi: drivers: adl_pci9111: Fix AI commands in TRIG_FOLLOW case

Javier Martinez Canillas (2):
      Staging: batman-adv: fix function prototype
      Staging: wlags49_h2: Fix build error when CONFIG_SYSFS is not set

Jeff Mahoney (1):
      Staging: wlags49_h2: add missing <linux/string.h> for strlen

Larry Finger (1):
      Staging: rtl8187se: Fix compile warnings in 2.6.35-rc2

Ozan Çağlayan (1):
      Staging: rt2870: add device id for Zyxel NWD-270N


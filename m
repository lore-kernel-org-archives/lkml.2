Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422Ab0CYFRX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 01:17:23 -0400
Received: from mail.perches.com ([173.55.12.10]:1075 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204Ab0CYFRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 01:17:22 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org
Subject: [PATCH 00/13] drivers/staging: Hoist assigns from if
Date: Wed, 24 Mar 2010 22:16:54 -0700
Message-Id: <cover.1269493047.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.14.g7e948
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used scripts/cvt_kernel.style.pl: --convert-hoist_assigns_from_if
and verified visually.

checkpatch errors ignored

Joe Perches (13):
  drivers/staging/cx25821: Hoist assign from if
  drivers/staging/dt3155: Hoist assign from if
  drivers/staging/otus/80211core: Hoist assign from if
  drivers/staging/otus: Hoist assign from if
  drivers/staging/rt2860: Hoist assign from if
  drivers/staging/rt2870: Hoist assign from if
  drivers/staging/rtl8187se: Hoist assign from if
  drivers/staging/rtl8192e: Hoist assign from if
  drivers/staging/rtl8192su: Hoist assign from if
  drivers/staging/rtl8192u: Hoist assign from if
  drivers/staging/vt6655: Hoist assign from if
  drivers/staging/vt6656: Hoist assign from if
  drivers/staging/wlags49_h2: Hoist assign from if

 drivers/staging/cx25821/cx25821-core.c             |    3 +-
 drivers/staging/dt3155/dt3155_drv.c                |   20 ++-
 drivers/staging/dt3155/dt3155_isr.c                |    3 +-
 drivers/staging/otus/80211core/cagg.c              |   34 +++--
 drivers/staging/otus/80211core/ccmd.c              |    3 +-
 drivers/staging/otus/80211core/cfunc.c             |    3 +-
 drivers/staging/otus/80211core/cic.c               |    9 +-
 drivers/staging/otus/80211core/cinit.c             |    3 +-
 drivers/staging/otus/80211core/cmm.c               |  144 +++++++++++++-------
 drivers/staging/otus/80211core/cmmap.c             |  103 +++++++++-----
 drivers/staging/otus/80211core/cmmsta.c            |  123 +++++++++++------
 drivers/staging/otus/80211core/coid.c              |    3 +-
 drivers/staging/otus/80211core/cpsmgr.c            |    3 +-
 drivers/staging/otus/80211core/ctxrx.c             |   81 +++++++----
 drivers/staging/otus/80211core/queue.c             |    5 +-
 drivers/staging/otus/80211core/ratectrl.c          |    3 +-
 drivers/staging/otus/hal/hpmain.c                  |   30 +++--
 drivers/staging/otus/usbdrv.c                      |    6 +-
 drivers/staging/otus/zdusb.c                       |    3 +-
 drivers/staging/rt2860/common/cmm_data.c           |    6 +-
 drivers/staging/rt2860/common/cmm_wpa.c            |   18 +--
 drivers/staging/rt2860/common/spectrum.c           |    7 +-
 drivers/staging/rt2860/pci_main_dev.c              |    6 +-
 drivers/staging/rt2860/rt_linux.c                  |    7 +-
 drivers/staging/rt2870/common/rtusb_bulk.c         |   15 ++-
 drivers/staging/rt2870/common/rtusb_io.c           |   10 +-
 .../rtl8187se/ieee80211/ieee80211_softmac.c        |    3 +-
 drivers/staging/rtl8187se/r8180_core.c             |    6 +-
 .../staging/rtl8192e/ieee80211/ieee80211_softmac.c |    3 +-
 drivers/staging/rtl8192e/r8192E_core.c             |    6 +-
 .../rtl8192su/ieee80211/ieee80211_softmac.c        |    3 +-
 .../staging/rtl8192u/ieee80211/ieee80211_softmac.c |    3 +-
 drivers/staging/vt6655/desc.h                      |    6 +-
 drivers/staging/vt6655/device.h                    |    6 +-
 drivers/staging/vt6655/device_main.c               |    3 +-
 drivers/staging/vt6655/iwctl.c                     |    3 +-
 drivers/staging/vt6656/main_usb.c                  |   12 +-
 drivers/staging/vt6656/usbpipe.c                   |   21 ++-
 drivers/staging/wlags49_h2/hcf.c                   |   15 ++-
 drivers/staging/wlags49_h2/wl_main.c               |    3 +-
 drivers/staging/wlags49_h2/wl_netdev.c             |   12 +-
 drivers/staging/wlags49_h2/wl_priv.c               |    9 +-
 drivers/staging/wlags49_h2/wl_sysfs.c              |    3 +-
 43 files changed, 496 insertions(+), 272 deletions(-)


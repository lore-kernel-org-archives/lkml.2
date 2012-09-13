Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab2IMRoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 13:44:34 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:56464 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510Ab2IMRoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 13:44:32 -0400
Date: Thu, 13 Sep 2012 10:44:27 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PATCH] staging fixes for 3.6-rc6
Message-ID: <20120913174427.GA21900@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit fea7a08acb13524b47711625eebea40a0ede69a0:

  Linux 3.6-rc3 (2012-08-22 13:29:06 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.6-rc6

for you to fetch changes up to 94254edc9c5b4e864767c97bfa0e4ccff2ecb5e5:

  drm/omap: add more new timings fields (2012-09-10 16:04:21 -0700)

----------------------------------------------------------------
Staging tree fixes for 3.6-rc6

Here are a few staging tree fixes for problems that have been reported.

Nothing major, just a number of tiny driver fixes.  All of these have
been in the linux-next tree for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Dae S. Kim (1):
      Staging: Android alarm: IOCTL command encoding fix

Dan Carpenter (1):
      staging:iio: prevent divide by zero bugs

Emil Goode (1):
      staging: wlan-ng: Fix problem with wrong arguments

Eric Dumazet (1):
      staging: r8712u: fix bug in r8712_recv_indicatepkt()

Greg Kroah-Hartman (1):
      Merge tag 'v3.6-rc1-iio-fixes-2' of git://git.kernel.org/.../jic23/iio into staging-linus

Ian Abbott (8):
      staging: comedi: amplc_pci224: Fix PCI ref count
      staging: comedi: amplc_dio200: Fix PCI ref count
      staging: comedi: amplc_pc236: Fix PCI ref count
      staging: comedi: amplc_pc263: Fix PCI ref count
      staging: comedi: amplc_pci230: Fix PCI ref count
      staging: comedi: das08: Fix PCI ref count
      staging: comedi: das08: Correct AI encoding for das08jr-16-ao
      staging: comedi: das08: Correct AO output for das08jr-16-ao

Julia Lawall (1):
      drivers/iio/adc/at91_adc.c: adjust inconsistent IS_ERR and PTR_ERR

Malcolm Priestley (1):
      staging: vt6656: [BUG] - Failed connection, incorrect endian.

Peter Meerwald (1):
      staging iio: fix potential memory leak in lis3l02dq_ring.c

Rob Clark (2):
      drm/omap: update for interlaced
      drm/omap: add more new timings fields

Seth Jennings (1):
      staging: zcache: fix cleancache race condition with shrinker

Tomas Winkler (1):
      staging: ozwpan: fix memcmp() test in oz_set_active_pd()

 drivers/iio/adc/at91_adc.c                    |    2 +-
 drivers/staging/android/android_alarm.h       |    4 +++-
 drivers/staging/comedi/drivers/amplc_dio200.c |    7 +++++++
 drivers/staging/comedi/drivers/amplc_pc236.c  |    7 +++++++
 drivers/staging/comedi/drivers/amplc_pc263.c  |    7 +++++++
 drivers/staging/comedi/drivers/amplc_pci224.c |    7 +++++++
 drivers/staging/comedi/drivers/amplc_pci230.c |    7 +++++++
 drivers/staging/comedi/drivers/das08.c        |   11 +++++++++--
 drivers/staging/iio/accel/lis3l02dq_ring.c    |    4 +++-
 drivers/staging/iio/adc/ad7192.c              |    2 ++
 drivers/staging/iio/gyro/adis16260_core.c     |    2 ++
 drivers/staging/iio/imu/adis16400_core.c      |    2 ++
 drivers/staging/iio/meter/ade7753.c           |    2 ++
 drivers/staging/iio/meter/ade7754.c           |    2 ++
 drivers/staging/iio/meter/ade7759.c           |    2 ++
 drivers/staging/omapdrm/omap_connector.c      |   41 ++++++++++++++++++++++++++++++++---------
 drivers/staging/ozwpan/ozcdev.c               |    3 ++-
 drivers/staging/rtl8712/recv_linux.c          |    7 +------
 drivers/staging/vt6656/dpc.c                  |    2 +-
 drivers/staging/vt6656/rxtx.c                 |   38 +++++++++++++++++++-------------------
 drivers/staging/wlan-ng/cfg80211.c            |    4 ++--
 drivers/staging/zcache/zcache-main.c          |    7 +++----
 22 files changed, 123 insertions(+), 47 deletions(-)

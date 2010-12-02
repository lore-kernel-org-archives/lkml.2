Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995Ab0LBUwQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 15:52:16 -0500
Received: from kroah.org ([198.145.64.141]:60366 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753318Ab0LBUwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 15:52:15 -0500
Date: Thu, 2 Dec 2010 12:48:23 -0800
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PATCH] STAGING fixes for .37-rc
Message-ID: <20101202204823.GA5927@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a number of staging tree fixes for your .37-rc tree.

It's a lot of attribute permission fixes, and some other minor things
that have been reported for build errors or other stuff.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/staging-2.6.git/ staging-linus

All of these patches have been in the -next trees for a while.
These patches will be sent to the linux driver project list for all to
see.

thanks,

greg k-h

--------------

 drivers/staging/asus_oled/asus_oled.c              |    8 +-
 drivers/staging/batman-adv/hard-interface.c        |   19 ++-
 drivers/staging/batman-adv/soft-interface.c        |   14 +-
 drivers/staging/brcm80211/README                   |    8 +-
 drivers/staging/brcm80211/TODO                     |    2 +
 drivers/staging/comedi/drivers/usbdux.c            |    4 +-
 drivers/staging/easycap/easycap.h                  |    1 +
 drivers/staging/frontier/tranzport.c               |    2 +-
 drivers/staging/iio/accel/adis16220_core.c         |    2 +-
 .../staging/intel_sst/intel_sst_stream_encoded.c   |    2 +-
 drivers/staging/line6/control.c                    |  204 ++++++++++----------
 drivers/staging/line6/midi.c                       |    4 +-
 drivers/staging/line6/pcm.c                        |    4 +-
 drivers/staging/line6/pod.c                        |   32 ++--
 drivers/staging/line6/toneport.c                   |    4 +-
 drivers/staging/line6/variax.c                     |   12 +-
 drivers/staging/quickstart/quickstart.c            |   10 +-
 drivers/staging/rt2860/usb_main_dev.c              |    1 +
 drivers/staging/rtl8187se/r8185b_init.c            |   32 +++-
 drivers/staging/rtl8712/usb_halinit.c              |    2 +-
 drivers/staging/samsung-laptop/samsung-laptop.c    |    2 +-
 drivers/staging/speakup/fakekey.c                  |    1 -
 drivers/staging/spectra/ffsport.c                  |    2 +-
 drivers/staging/udlfb/udlfb.c                      |    2 +-
 drivers/staging/winbond/sysdef.h                   |    3 +
 drivers/staging/zram/zram_sysfs.c                  |    4 +-
 26 files changed, 211 insertions(+), 170 deletions(-)

---------------------

Arend van Spriel (1):
      staging: brcm80211: updated maintainers contact information

Dan Carpenter (4):
      Staging: speakup: free after input_unregister_device()
      Staging: quickstart: free after input_unregister_device()
      Staging: rtl8712: signedness bug in init
      Staging: intel_sst: fix memory leak

Greg Kroah-Hartman (14):
      Staging: asus_oled: fix up some sysfs attribute permissions
      Staging: frontier: fix up some sysfs attribute permissions
      Staging: iio: adis16220: fix up some sysfs attribute permissions
      Staging: samsung-laptop: fix up some sysfs attribute permissions
      Staging: udlfb: fix up some sysfs attribute permissions
      Staging: zram: fix up some sysfs attribute permissions
      Staging: line6: fix up some sysfs attribute permissions
      Staging: asus_oled: fix up my fixup for some sysfs attribute permissions
      Staging: frontier: fix up my fixup for some sysfs attribute permissions
      Staging: iio: adis16220: fix up my fixup for some sysfs attribute permissions
      Staging: samsung-laptop: fix up my fixup for some sysfs attribute permissions
      Staging: udlfb: fix up my fixup for some sysfs attribute permissions
      Staging: zram: fix up my fixup for some sysfs attribute permissions
      Staging: line6: fix up my fixup for some sysfs attribute permissions

John Tapsell (1):
      Staging: rt2870: Add USB ID for Buffalo Airstation WLI-UC-GN

Larry Finger (1):
      staging: rtl8187se: Change panic to warn when RF switch turned off

Marek Lindner (1):
      Staging: batman-adv: ensure that eth_type_trans gets linear memory

Nicolas Kaiser (1):
      staging: comedi: fix memory leak

Randy Dunlap (2):
      staging: fix winbond build, needs delay.h
      staging: easycap needs smp_lock.h, fixes build error

Sven Eckelmann (1):
      Staging: batman-adv: Don't remove interface with spinlock held

Yong Wang (1):
      staging: spectra: fix build error


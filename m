Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab0IDCKn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 22:10:43 -0400
Received: from kroah.org ([198.145.64.141]:48487 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754050Ab0IDCKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 22:10:10 -0400
Date: Fri, 3 Sep 2010 19:09:55 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [GIT PATCH] STAGING fixes for 2.6.36-git
Message-ID: <20100904020955.GD28645@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a bunch of tiny staging bugfixes and a few new device ids for
your 2.6.36-git tree.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/staging-2.6.git/

All of these patches have been in the linux-next and mm trees.

The patches will be sent as a follow-on to this message to the
driver-devel list for people to see.

thanks,

greg k-h

--------------


 drivers/staging/comedi/drivers/das08_cs.c |    1 -
 drivers/staging/hv/netvsc_drv.c           |    3 ++
 drivers/staging/hv/ring_buffer.c          |    3 +-
 drivers/staging/hv/storvsc_api.h          |    4 +-
 drivers/staging/hv/storvsc_drv.c          |   11 +++++---
 drivers/staging/octeon/Kconfig            |    2 +-
 drivers/staging/rt2860/usb_main_dev.c     |   41 +++++++++++++++++++++++++++-
 drivers/staging/spectra/Kconfig           |    1 +
 drivers/staging/spectra/ffsport.c         |    1 +
 drivers/staging/wlan-ng/cfg80211.c        |    3 ++
 drivers/staging/zram/zram_drv.c           |    1 +
 11 files changed, 59 insertions(+), 12 deletions(-)

---------------

Andreas Bombe (1):
      staging: comedi das08_cs.c: Fix io_req_t conversion

Ben Hutchings (1):
      Staging: rt2870sta: Add more device IDs from vendor drivers

Geert Uytterhoeven (1):
      staging: spectra needs <linux/slab.h>

Haiyang Zhang (2):
      staging: hv: Fix missing functions for net_device_ops
      staging: hv: Fixed the value of the 64bit-hole inside ring buffer

Hank Janssen (3):
      staging: hv: Fixed bounce kmap problem by using correct index
      staging: hv: Increased storvsc ringbuffer and max_io_requests
      staging: hv: Fixed lockup problem with bounce_buffer scatter list

Jeff Mahoney (1):
      Staging: spectra: depend on X86_MRST

Karl Relton (1):
      Staging: wlan-ng: Explicitly set some fields in cfg80211 interface

Randy Dunlap (1):
      Staging: octeon: depends on NETDEVICES

Shahar Havivi (1):
      Staging: zram: free device memory when init fails


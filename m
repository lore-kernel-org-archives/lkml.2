Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994Ab1EDVHw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 17:07:52 -0400
Received: from kroah.org ([198.145.64.141]:39015 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169Ab1EDVHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 17:07:50 -0400
Date: Wed, 4 May 2011 14:01:39 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PATCH] STAGING fixes for .39 - try 2
Message-ID: <20110504210139.GA2922@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a number of minor staging driver fixes for your .39-rc tree, again.
One more fix has been added since I sent this to you for the .39-rc5 tree, so
that pull request would generate a different diff than this one.

All of these fix errors that have been reported by people.  There is one
usbip bugfix for a runtime issue as well.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/staging-2.6.git/ staging-linus

All of these patches have been in the mm and -next trees for a while.

These patches will be sent to the linux driver project list for all to
see.

thanks,

greg k-h

--------------

 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c   |    4 ----
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c |    3 ---
 drivers/staging/gma500/Kconfig                     |    2 +-
 drivers/staging/intel_sst/intelmid_v1_control.c    |    1 +
 drivers/staging/intel_sst/intelmid_v2_control.c    |    1 +
 drivers/staging/olpc_dcon/olpc_dcon_xo_1.c         |    1 +
 drivers/staging/rts_pstor/debug.h                  |    2 +-
 drivers/staging/rts_pstor/ms.c                     |    1 +
 drivers/staging/rts_pstor/rtsx_chip.c              |    5 +++--
 drivers/staging/rts_pstor/rtsx_scsi.c              |    1 +
 drivers/staging/rts_pstor/sd.c                     |    4 ++--
 drivers/staging/rts_pstor/trace.h                  |    2 +-
 drivers/staging/rts_pstor/xd.c                     |    1 +
 drivers/staging/solo6x10/Kconfig                   |    1 +
 drivers/staging/usbip/vhci_hcd.c                   |    9 ++++-----
 drivers/staging/usbip/vhci_sysfs.c                 |    7 ++++---
 drivers/staging/wlan-ng/cfg80211.c                 |    2 +-
 17 files changed, 24 insertions(+), 23 deletions(-)

---------------

Harry Wei (1):
      staging: Remove a warning for drivers/staging/wlan-ng/cfg80211.c

Jeff Mahoney (5):
      staging: olpc: Add <linux/delay.h>
      staging: gma500: Depend on X86
      staging: rts_pstor: Add <linux/vmalloc.h>
      staging: rts_pstor: use #ifdef instead of #if
      staging: ft1000: Remove unnecessary EXPORT_SYMBOLs

Max Vozeler (1):
      staging: usbip: vhci: fix oops on subsequent attach

Peter Foley (1):
      staging: solo6x10: add select SND_PCM to fix build error

Randy Dunlap (1):
      staging: intel_sst: intelmid needs delay.h


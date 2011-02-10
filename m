Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab1BJUPw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 15:15:52 -0500
Received: from kroah.org ([198.145.64.141]:40789 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114Ab1BJUPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 15:15:49 -0500
Date: Thu, 10 Feb 2011 12:15:33 -0800
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PATCH] STAGING fixes for .38
Message-ID: <20110210201533.GB18283@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a few bug fixes for the staging tree for .38

Not much really, a broadcom driver fix, zram fix, and other small
things.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/staging-2.6.git/ staging-linus

All of these patches have been in the -next trees for a while.

These patches will be sent to the linux driver project list for all to
see.

thanks,

greg k-h

--------------

 drivers/staging/brcm80211/sys/wl_mac80211.c     |   12 ++++++++++--
 drivers/staging/brcm80211/sys/wlc_mac80211.c    |   13 +++++++++++++
 drivers/staging/brcm80211/sys/wlc_pub.h         |    2 ++
 drivers/staging/comedi/Kconfig                  |    5 ++++-
 drivers/staging/comedi/drivers/mite.c           |    2 --
 drivers/staging/comedi/drivers/ni_6527.c        |    4 ++++
 drivers/staging/comedi/drivers/ni_65xx.c        |    4 ++++
 drivers/staging/comedi/drivers/ni_660x.c        |    4 ++++
 drivers/staging/comedi/drivers/ni_670x.c        |    4 ++++
 drivers/staging/comedi/drivers/ni_pcidio.c      |    4 ++++
 drivers/staging/comedi/drivers/ni_pcimio.c      |    4 ++++
 drivers/staging/hv/netvsc_drv.c                 |    1 +
 drivers/staging/intel_sst/intelmid_v2_control.c |    5 ++++-
 drivers/staging/zram/zram_drv.c                 |    4 ++++
 14 files changed, 62 insertions(+), 6 deletions(-)

---------------

Haiyang Zhang (1):
      staging: hv: Enable sending GARP packet after live migration

Harsha Priya (1):
      staging: sst: Fix for dmic capture on v2 pmic

Ian Abbott (2):
      Staging: comedi: Add MODULE_LICENSE and similar to NI modules
      Staging: Comedi: Fix a few NI module dependencies

Nitin Gupta (1):
      staging: zram: fix data corruption issue

Roland Vossen (1):
      staging: brcm80211: bugfix for softmac crash on multi cpu configurations


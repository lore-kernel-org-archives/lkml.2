Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051Ab1GEJgv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 05:36:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:47317 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755013Ab1GEJgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 05:36:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,478,1304319600"; 
   d="scan'208";a="26378200"
Date: Tue, 5 Jul 2011 11:37:17 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Axel Lin <axel.lin@gmail.com>,
        Keshava Munegowda <Keshava_mgowda@ti.com>,
        Kevin Hilman <khilman@ti.com>
Subject: [GIT PULL] MFD fixes for 3.0
Message-ID: <20110705093717.GW3021@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is a small set of MFD fixes for 3.0. Mostly, we have an OMAP usbhs revert
because the original commit can potentially lead to an oops.
Also, a couple of leftover from the mfd_get_data() cleanup and a build fix for
the tps65911 comparator.

Thanks in advance for pulling those in.

The following changes since commit fe0d42203cb5616eeff68b14576a0f7e2dd56625:

  Linux 3.0-rc6 (2011-07-04 15:56:24 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git for-linus

Axel Lin (2):
      mfd: Fix build error for tps65911-comparator.c
      mfd: Add Makefile and Kconfig Entries for tps65911 comparator

Keshava Munegowda (1):
      Revert "mfd: Add omap-usbhs runtime PM support"

Samuel Ortiz (2):
      input: pmic8xxx-keypad: Do not use mfd_get_data()
      input: pmic8xxx-pwrkey: Do not use mfd_get_data()

 drivers/input/keyboard/pmic8xxx-keypad.c |    3 +-
 drivers/input/misc/pmic8xxx-pwrkey.c     |    3 +-
 drivers/mfd/Kconfig                      |    3 +
 drivers/mfd/Makefile                     |    1 +
 drivers/mfd/omap-usb-host.c              |  131 +++++++++++++++++++++++++++--
 drivers/mfd/tps65911-comparator.c        |    2 +-
 6 files changed, 131 insertions(+), 12 deletions(-)
-- 
Intel Open Source Technology Centre
http://oss.intel.com/

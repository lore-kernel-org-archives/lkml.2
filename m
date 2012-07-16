Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab2GPTmw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 15:42:52 -0400
Received: from gir.skynet.ie ([193.1.99.77]:53838 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963Ab2GPTmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 15:42:47 -0400
Date: Mon, 16 Jul 2012 20:42:46 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: [git pull] drm gma500 fixes
Message-ID: <alpine.DEB.2.00.1207162041400.28607@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hi Linus,

Sorry been travelling and a bit neglectful of some of Alan's 
patches,

These all look necessary for -fixes,

Dave.

The following changes since commit ac7d181e323a888015e19e2e4d776095a0433787:

  Merge branch 'hwmon-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging (2012-07-13 11:01:03 -0700)

are available in the git repository at:


  ssh://people.freedesktop.org/~airlied/linux.git drm-fixes

for you to fetch changes up to a3928c6b5f43bcd561802b52049b6024b8da675f:

  gma500,cdv: Fix the brightness base (2012-07-17 04:35:06 +1000)

----------------------------------------------------------------
Alan Cox (4):
      gma500: Fix frequency detection
      gma500: Fix lid related crash
      gma500: move the ASLE enable
      gma500,cdv: Fix the brightness base

 drivers/gpu/drm/gma500/cdv_device.c |   36 +++++++++++++++++++----------------
 drivers/gpu/drm/gma500/opregion.c   |    8 +++-----
 drivers/gpu/drm/gma500/opregion.h   |    5 +++++
 drivers/gpu/drm/gma500/psb_device.c |   13 +++++--------
 drivers/gpu/drm/gma500/psb_drv.c    |    1 +
 5 files changed, 34 insertions(+), 29 deletions(-)

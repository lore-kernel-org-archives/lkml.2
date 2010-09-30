Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab0I3TBu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 15:01:50 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54662 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682Ab0I3TBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 15:01:49 -0400
From: pavan_savoy@ti.com
To: gregkh@suse.de, alan@lxorguk.ukuu.org.uk
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 0/3] prepare TI_ST to move out of staging
Date: Thu, 30 Sep 2010 16:13:27 -0400
Message-Id: <1285877610-3043-1-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

Greg,

As suggested, the patch has been modified to set of 3 patches.
1. to add the new line discipline number to tty.h
2. rm the __KERNEL__ since the header is no more required for user-space
3. mv the header file to include/linux/

Please review.

Pavan Savoy (3):
  include:linux: tty.h: new ldisc for TI WiLink ST
  drivers:staging:ti-st: drop the __KERNEL__
  drivers:staging:ti-st: mv ti_wilink_st header

 drivers/staging/ti-st/bt_drv.c       |    2 +-
 drivers/staging/ti-st/st_core.c      |    2 +-
 drivers/staging/ti-st/st_kim.c       |    2 +-
 drivers/staging/ti-st/st_ll.c        |    2 +-
 drivers/staging/ti-st/ti_wilink_st.h |  409 ----------------------------------
 include/linux/ti_wilink_st.h         |  402 +++++++++++++++++++++++++++++++++
 include/linux/tty.h                  |    1 +
 7 files changed, 407 insertions(+), 413 deletions(-)
 delete mode 100644 drivers/staging/ti-st/ti_wilink_st.h
 create mode 100644 include/linux/ti_wilink_st.h


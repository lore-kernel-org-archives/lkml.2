Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab0IQOzK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 10:55:10 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41326 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754282Ab0IQOzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 10:55:08 -0400
From: pavan_savoy@ti.com
To: gregkh@suse.de, alan@lxorguk.ukuu.org.uk
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 0/2] prepare ti-st to mv out of staging
Date: Fri, 17 Sep 2010 12:06:09 -0400
Message-Id: <1284739571-19451-1-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

Greg,

As suggested, the patch has been spilt to 2 patches:
1. correction of the data types
2. moving headers to ti_wilink_st.h and source modifications for it

and application of individual patches doesn't break the build :)

Pavan Savoy (2):
  drivers:staging:ti-st: set right the data types
  drivers:staging:ti-st: mv headers to ti_wilink_st

 drivers/staging/ti-st/bt_drv.c       |    2 +-
 drivers/staging/ti-st/fm.h           |   13 -
 drivers/staging/ti-st/st.h           |   83 -------
 drivers/staging/ti-st/st_core.c      |   10 +-
 drivers/staging/ti-st/st_core.h      |  128 -----------
 drivers/staging/ti-st/st_kim.c       |    5 +-
 drivers/staging/ti-st/st_kim.h       |  180 ---------------
 drivers/staging/ti-st/st_ll.c        |    4 +-
 drivers/staging/ti-st/st_ll.h        |   69 ------
 drivers/staging/ti-st/ti_wilink_st.h |  409 ++++++++++++++++++++++++++++++++++
 10 files changed, 417 insertions(+), 486 deletions(-)
 delete mode 100644 drivers/staging/ti-st/fm.h
 delete mode 100644 drivers/staging/ti-st/st.h
 delete mode 100644 drivers/staging/ti-st/st_core.h
 delete mode 100644 drivers/staging/ti-st/st_kim.h
 delete mode 100644 drivers/staging/ti-st/st_ll.h
 create mode 100644 drivers/staging/ti-st/ti_wilink_st.h


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856Ab0GVKcZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 06:32:25 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:46768 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754464Ab0GVKcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 06:32:23 -0400
From: pavan_savoy@ti.com
To: gregkh@suse.de, alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        pavan_savoy@sify.com, Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 0/3] drivers:staging:ti-st: patches
Date: Thu, 22 Jul 2010 05:32:04 -0500
Message-Id: <1279794727-7669-1-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

The following patches cleanup bit of a mess and also adds functionality to protocol drivers.
with the 3rd patch now providing context to even the protocol drivers, the single device limit
or support for multiple devices would be easier to implement.

These patches depend on the previously submitted
0001-drivers-staging-ti-st-make-use-of-linux-err-codes.patch
commit d39d49b393d94f4137cee4f64526a4695352f183

Pavan Savoy (3):
  drivers:staging:ti-st: smarten, reduce logs
  drivers:staging:ti-st: cleanup code comments
  drivers:staging:ti-st: give proto drivers context

 drivers/staging/ti-st/bt_drv.c  |   23 +++++---
 drivers/staging/ti-st/st.h      |   52 +++++++++--------
 drivers/staging/ti-st/st_core.c |  118 +++++++++++++++++++--------------------
 drivers/staging/ti-st/st_core.h |   74 +++++++++++++++++--------
 drivers/staging/ti-st/st_kim.c  |   73 ++++++++++++++----------
 drivers/staging/ti-st/st_kim.h  |   77 ++++++++++++++++---------
 drivers/staging/ti-st/st_ll.c   |    4 +-
 drivers/staging/ti-st/st_ll.h   |    9 +++-
 8 files changed, 255 insertions(+), 175 deletions(-)


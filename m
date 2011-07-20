Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab1GTOad (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 10:30:33 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39864 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865Ab1GTOab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 10:30:31 -0400
From: <pavan_savoy@ti.com>
To: <greg@kroah.com>, <linux-kernel@vger.kernel.org>
CC: pavan_savoy@sify.com, Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 0/4] drivers:misc: ti-st: platform specifics
Date: Wed, 20 Jul 2011 09:30:16 -0500
Message-ID: <1311172225-17678-1-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>


Greg,

resending,
since I didn't see these up on lkml.org
(issues with my git send-email configuration)

These are the some of the patches which have gone on top of Texas Instrument's
shared transport driver which fixes issues found during field testing.
These include:
a. removing an annoying and misleading debug message
b. various platform hooks for enabling/disabling chip and communicating PM
states of the WiLink chip.
c. Re-initializing completion for make sure failed firmware download doesn't
create a problem the next time around.
d. fail-safe fix which happens upon corner cases when UART drops
bytes or chip is too busy and hence sends across h/w error events.



Pavan Savoy (3):
  drivers:misc: ti-st: avoid a misleading dbg msg
  drivers:misc:ti-st: platform hooks for chip states
  drivers:misc: ti-st: reinit completion on ver read

Vijay Badawadagi (1):
  drivers:misc: ti-st: fail-safe on wrong pkt type

 drivers/misc/ti-st/st_core.c |    9 ++++++++-
 drivers/misc/ti-st/st_kim.c  |   13 +++++++++++++
 drivers/misc/ti-st/st_ll.c   |   19 +++++++++++++++++++
 include/linux/ti_wilink_st.h |   27 ++++++++++++++++++++++++++-
 4 files changed, 66 insertions(+), 2 deletions(-)

-- 
1.7.4.1


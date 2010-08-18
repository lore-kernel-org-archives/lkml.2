Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072Ab0HRGUk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 02:20:40 -0400
Received: from smtp.nokia.com ([192.100.122.230]:61258 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932Ab0HRGUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 02:20:25 -0400
From: felipe.balbi@nokia.com
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Felipe Balbi <felipe.balbi@nokia.com>
Subject: [PATCH 0/4] twl PROTECT_KEY usage cleanup
Date: Wed, 18 Aug 2010 09:19:33 +0300
Message-Id: <1282112377-1335-1-git-send-email-felipe.balbi@nokia.com>
X-Mailer: git-send-email 1.7.2.1.6.g61bf12
X-OriginalArrivalTime: 18 Aug 2010 06:19:46.0236 (UTC) FILETIME=[5AAE6FC0:01CB3E9D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felipe Balbi <felipe.balbi@nokia.com>

Hi all,

the following patches are cleaning up the usage
of PROTECT_KEY register.

Boot-tested on custom OMAP3 board.

Felipe Balbi (4):
  i2c: twl: add register defines for pm master module
  mfd: twl-core: switch over to defines in twl.h
  mfd: twl4030-power: switch over to defines in twl.h
  usb: otg: twl4030-usb: switch over to defines in twl.h

 drivers/mfd/twl-core.c        |   21 ++++++++----------
 drivers/mfd/twl4030-power.c   |   30 ++++++++++++++------------
 drivers/usb/otg/twl4030-usb.c |   13 ++++++++---
 include/linux/i2c/twl.h       |   46 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 80 insertions(+), 30 deletions(-)

-- 
1.7.2.1.6.g61bf12


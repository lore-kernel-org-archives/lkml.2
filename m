Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759153Ab1LOQid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 11:38:33 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:53106 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759112Ab1LOQia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 11:38:30 -0500
From: <pavan_savoy@ti.com>
To: <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
CC: <pavan_savoy@sify.com>, Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH v2 0/3] robustness fixes for ti-st
Date: Thu, 15 Dec 2011 10:38:19 -0600
Message-ID: <1323967102-13380-1-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>


Greg,
Please review and merge.
This is patchset v2 of the fixes.

The following patches are fixes for some of the issues found during some robustness
tests carried out on ti-st.
With all 3 technologies (BT, FM and GPS) working over this transport along with WLAN's
SDIO driver - there were certain issues where the chip didn't respond over UART as expected.
The patch also includes 1 debug related change - which allows anyone who is porting ti-st to
new platforms with doubt-able UARTs to debug various UART devices and baud-rates.

Pavan Savoy (3):
  drivers:misc: ti-st: protect registrations
  drivers:misc: ti-st: flush UART upon fw failure
  drivers:misc: ti-st: DEBUG uart, baud rate mods

 drivers/misc/ti-st/st_core.c |   18 +++++++--
 drivers/misc/ti-st/st_kim.c  |   84 +++++++++++++++++++++++++++---------------
 2 files changed, 68 insertions(+), 34 deletions(-)

-- 
1.7.4.1


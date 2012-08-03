Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab2HCTqk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 15:46:40 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58005 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876Ab2HCTq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 15:46:26 -0400
From: <pavan_savoy@ti.com>
To: <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
CC: <pavan_savoy@sify.com>, Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH v2 0/6] drivers/misc/ti-st: updates & fixes
Date: Fri, 3 Aug 2012 14:46:11 -0500
Message-ID: <1344023177-21167-1-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

Resending - Since I'm not sure the first mail was went through.
This time adding a patch from Matthias Kaehlcke.

Greg,

Please find attached the patch-set which fixes/updates the WiLink shared
transport driver hosted at drivers/misc/ti-st/

Among the following set of patches:-
The gpio handling patch, disabling chip upon firmware download timeout &
fixing the read fw version command comes from testing the driver on various
platforms with a variety of serial driver working underneath.
The other 2 patches comes in form of removing sparse warnings and a nicer
update from existing wait for completion usage.


Matthias Kaehlcke (1):
  drivers/misc/ti-st: check chip_awake NULL check

Pavan Savoy (5):
  drivers/misc/ti-st: remove gpio handling
  drivers/misc/ti-st: remove sparse warnings
  drivers/misc/ti-st: chip_disable on timeout
  drivers/misc/ti-st: use cpu friendly completions
  drivers/misc/ti-st: fix read fw version cmd

 drivers/misc/ti-st/st_core.c |   12 +++--
 drivers/misc/ti-st/st_kim.c  |  109 +++++++++++++++++-------------------------
 drivers/misc/ti-st/st_ll.c   |    2 +-
 include/linux/ti_wilink_st.h |    3 +-
 4 files changed, 54 insertions(+), 72 deletions(-)

-- 
1.7.4.1


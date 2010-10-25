Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab0JYNRl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 09:17:41 -0400
Received: from cluster-d.mailcontrol.com ([85.115.60.190]:56690 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146Ab0JYNRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 09:17:40 -0400
Message-ID: <4CC58365.1000305@csr.com>
Date: Mon, 25 Oct 2010 14:17:25 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Kernel development list <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] UWB/WLP subsystem updates for 2.6.37-rc1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Oct 2010 13:17:25.0405 (UTC) FILETIME=[F7332CD0:01CB7446]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull my final set of changes for the UWB/WLP subsystems that a)
removes entire WLP subsystem and the single driver and b) orphans the
UWB/WUSB subsystems.

The WLP subsystem is being removed because there was never any
commercially available hardware for it and there is little prospect of
such hardware ever existing in the future.

Thanks.

David

The following changes since commit 229aebb873e29726b91e076161649cf45154b0bf:
  Linus Torvalds (1):
        Merge branch 'for-next' of git://git.kernel.org/.../jikos/trivial

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dvrabel/uwb.git for-upstream

David Vrabel (2):
      uwb: Remove the WLP subsystem and drivers
      uwb: Orphan the UWB and WUSB subsystems

 MAINTAINERS                               |   18 +-
 drivers/uwb/Kconfig                       |   20 +-
 drivers/uwb/Makefile                      |    1 -
 drivers/uwb/i1480/Makefile                |    1 -
 drivers/uwb/i1480/i1480-wlp.h             |  200 ----
 drivers/uwb/i1480/i1480u-wlp/Makefile     |    8 -
 drivers/uwb/i1480/i1480u-wlp/i1480u-wlp.h |  283 -----
 drivers/uwb/i1480/i1480u-wlp/lc.c         |  424 -------
 drivers/uwb/i1480/i1480u-wlp/netdev.c     |  331 ------
 drivers/uwb/i1480/i1480u-wlp/rx.c         |  474 --------
 drivers/uwb/i1480/i1480u-wlp/sysfs.c      |  407 -------
 drivers/uwb/i1480/i1480u-wlp/tx.c         |  584 ----------
 drivers/uwb/wlp/Makefile                  |   10 -
 drivers/uwb/wlp/driver.c                  |   43 -
 drivers/uwb/wlp/eda.c                     |  415 -------
 drivers/uwb/wlp/messages.c                | 1798
-----------------------------
 drivers/uwb/wlp/sysfs.c                   |  708 ------------
 drivers/uwb/wlp/txrx.c                    |  354 ------
 drivers/uwb/wlp/wlp-internal.h            |  224 ----
 drivers/uwb/wlp/wlp-lc.c                  |  560 ---------
 drivers/uwb/wlp/wss-lc.c                  |  959 ---------------
 include/linux/wlp.h                       |  736 ------------
 22 files changed, 3 insertions(+), 8555 deletions(-)
 delete mode 100644 drivers/uwb/i1480/i1480-wlp.h
 delete mode 100644 drivers/uwb/i1480/i1480u-wlp/Makefile
 delete mode 100644 drivers/uwb/i1480/i1480u-wlp/i1480u-wlp.h
 delete mode 100644 drivers/uwb/i1480/i1480u-wlp/lc.c
 delete mode 100644 drivers/uwb/i1480/i1480u-wlp/netdev.c
 delete mode 100644 drivers/uwb/i1480/i1480u-wlp/rx.c
 delete mode 100644 drivers/uwb/i1480/i1480u-wlp/sysfs.c
 delete mode 100644 drivers/uwb/i1480/i1480u-wlp/tx.c
 delete mode 100644 drivers/uwb/wlp/Makefile
 delete mode 100644 drivers/uwb/wlp/driver.c
 delete mode 100644 drivers/uwb/wlp/eda.c
 delete mode 100644 drivers/uwb/wlp/messages.c
 delete mode 100644 drivers/uwb/wlp/sysfs.c
 delete mode 100644 drivers/uwb/wlp/txrx.c
 delete mode 100644 drivers/uwb/wlp/wlp-internal.h
 delete mode 100644 drivers/uwb/wlp/wlp-lc.c
 delete mode 100644 drivers/uwb/wlp/wss-lc.c
 delete mode 100644 include/linux/wlp.h
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/


Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770Ab2GIB7Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 21:59:25 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:54236 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab2GIB7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 21:59:24 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: gregkh@linuxfoundation.org
Cc: andriy.shevchenko@linux.intel.com, jj@chaosbits.net,
        forest@alittletooquiet.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH 0/5] staging: vt6656: Cleanup in usage of macros
Date: Sun,  8 Jul 2012 22:55:45 -0300
Message-Id: <1341798950-11215-1-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi kernel guys!
  
This patchset aims to clean all the macros from vt6656 driver.
With the forgotten-macros tool(https://github.com/marcosps/forgotten_macros), we 
can find all unused macros, commented macros and a little more. :)
  
As I don't have the hardware, I will be grateful if anyone could test theses 
changes.

All the changes were based in staging-next tree.

Comments are welcome!

Marcos Paulo de Souza (5):
  staging: vt6656: desc.h: Remove commented macros and useless comments
  staging: vt6656: hostap.c: Remove unused macros and some useless
    comments
  staging: vt6656: hostap.c: Remove commented code
  staging: vt6656: Remove all commented macros
  staging: vt6656: Remove unsed macros

 drivers/staging/vt6656/80211hdr.h |    2 --
 drivers/staging/vt6656/bssdb.h    |    2 --
 drivers/staging/vt6656/card.c     |    1 -
 drivers/staging/vt6656/card.h     |    1 -
 drivers/staging/vt6656/channel.c  |    2 --
 drivers/staging/vt6656/desc.h     |   19 -----------
 drivers/staging/vt6656/device.h   |    4 ---
 drivers/staging/vt6656/hostap.c   |   63 -------------------------------------
 drivers/staging/vt6656/main_usb.c |    5 ---
 drivers/staging/vt6656/mib.h      |    1 -
 drivers/staging/vt6656/rxtx.c     |    2 --
 drivers/staging/vt6656/tether.h   |    2 --
 drivers/staging/vt6656/usbpipe.c  |    3 --
 13 files changed, 107 deletions(-)

-- 
1.7.10.4


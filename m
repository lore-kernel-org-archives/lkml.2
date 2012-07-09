Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585Ab2GICyJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 22:54:09 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:51545 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab2GICyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 22:54:06 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: gregkh@linuxfoundation.org
Cc: andriy.shevchenko@linux.intel.com, jj@chaosbits.net,
        forest@alittletooquiet.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH 0/6] staging: vt6655: Cleanup in usage of macros
Date: Sun,  8 Jul 2012 23:51:20 -0300
Message-Id: <1341802286-28281-1-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi kernel guys!

This patchset aims to clean all unused and commented macros.

For this challenge, forgotten-macros tool helped us.

As I don't have any vt665x hardware, I will be grateful if anyone can test these changes!

This patchset was based in staging-next tree.

I hope you enjoy :)

Marcos Paulo de Souza (6):
  staging: vt6655: Remove all "if 0" blocks from driver
  staging: vt6655: mac.h: Remove all commented macros
  staging: vt6655: rf.c: Remove all unused macros
  staging: vt6655: baseband.h: Remove all unused macros
  staging: vt6655: Remove all commented macros
  staging: vt6655: hostap.c: Remove all unused macros

 drivers/staging/vt6655/80211hdr.h    |    2 -
 drivers/staging/vt6655/baseband.c    |    2 -
 drivers/staging/vt6655/baseband.h    |   30 -------------
 drivers/staging/vt6655/bssdb.c       |    1 -
 drivers/staging/vt6655/desc.h        |   11 -----
 drivers/staging/vt6655/device.h      |   15 -------
 drivers/staging/vt6655/device_main.c |   37 ----------------
 drivers/staging/vt6655/dpc.c         |    1 -
 drivers/staging/vt6655/hostap.c      |    6 ---
 drivers/staging/vt6655/iwctl.c       |   36 ----------------
 drivers/staging/vt6655/mac.h         |   24 -----------
 drivers/staging/vt6655/mib.h         |    2 -
 drivers/staging/vt6655/rf.c          |   78 ----------------------------------
 drivers/staging/vt6655/rf.h          |    1 -
 drivers/staging/vt6655/tether.h      |    3 --
 drivers/staging/vt6655/vntwifi.c     |    2 -
 drivers/staging/vt6655/wcmd.c        |   24 -----------
 17 files changed, 275 deletions(-)

-- 
1.7.10.4


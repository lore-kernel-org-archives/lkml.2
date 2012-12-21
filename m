Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008Ab2LUKlJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 05:41:09 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:44549 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594Ab2LUKk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 05:40:59 -0500
MIME-Version: 1.0
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 21 Dec 2012 16:10:38 +0530
Message-ID: <CA+V-a8s=ykTn1AW3iSZZG1qQWH9L-sEs2Fu=DN_gjGu2Dv5-tQ@mail.gmail.com>
Subject: [GIT PULL FOR v3.9] Davinci VPBE Trivial Fixes
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        dlos <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Prabhakar Lad <prabhakar.lad@ti.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

Please pull the following patches for DaVinci VPBE driver.
One of the patch has ARM changes and is Acked-by the ARM
maintainer.

Thanks and Regards,
--Prabhakar Lad


The following changes since commit 4bb891ebf60eb43ebd04e09bbcad24013067873f:

  [media] ivtv: ivtv-driver: Replace 'flush_work_sync()' (2012-12-20
15:22:30 -0200)

are available in the git repository at:
  git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git davinci_media

Lad, Prabhakar (2):
      davinci: vpbe: pass different platform names to handle different ip's
      media: davinci: vpbe: enable building of vpbe driver for DM355 and DM365

Wei Yongjun (3):
      media: davinci: vpbe: fix return value check in vpbe_display_reqbufs()
      media: davinci: vpbe: return error code on error in vpbe_display_g_crop()
      davinci: vpbe: remove unused variable in vpbe_initialize()

 arch/arm/mach-davinci/board-dm644x-evm.c      |    8 ++--
 arch/arm/mach-davinci/dm644x.c                |   10 +---
 drivers/media/platform/davinci/Kconfig        |   22 ++------
 drivers/media/platform/davinci/Makefile       |    4 +-
 drivers/media/platform/davinci/vpbe.c         |    6 +--
 drivers/media/platform/davinci/vpbe_display.c |    9 ++--
 drivers/media/platform/davinci/vpbe_osd.c     |   35 ++++++++++----
 drivers/media/platform/davinci/vpbe_venc.c    |   65 +++++++++++++++++--------
 include/media/davinci/vpbe_osd.h              |    5 +-
 include/media/davinci/vpbe_venc.h             |    5 +-
 10 files changed, 95 insertions(+), 74 deletions(-)

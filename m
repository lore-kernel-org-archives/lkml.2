Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab1F3WET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 18:04:19 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:42992 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752103Ab1F3WER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 18:04:17 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Greg Kroah-Hartman" <greg@kroah.com>
Cc: Marek Belisko <marek.belisko@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH 00/28] staging: ft1000-pcmcia: various fixes
Date: Fri,  1 Jul 2011 00:03:29 +0200
Message-Id: <1309471437-12633-1-git-send-email-linux@rainbow-software.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix various things in ft1000-pcmcia driver.

Ondrej Zary (28):
      staging: ft1000-pcmcia: don't crash on load
      staging: ft1000-pcmcia: fix compilation with FT_DEBUG enabled
      staging: ft1000-pcmcia: delete ft1000.conf
      staging: ft1000-pcmcia: get rid of ft1000_dev.h
      staging: ft1000-pcmcia: remove PSEUDO_HDR typedefs
      staging: ft1000-pcmcia: remove DRVMSG typedefs
      staging: ft1000-pcmcia: remove MEDIAMSG typedefs
      staging: ft1000-pcmcia: delete unused TIMEMSG typedefs
      staging: ft1000-pcmcia: remove DSPINITMSG typedefs
      staging: ft1000-pcmcia: delete unused DSPHIBERNATE typedefs
      staging: ft1000-pcmcia: delete unused APP_INFO_BLOCK typedefs
      staging: ft1000-pcmcia: remove PROV_RECORD typedefs
      staging: ft1000-pcmcia: remove FT1000_INFO typedefs
      staging: ft1000-pcmcia: delete unused DPRAM_BLK typedefs
      staging: ft1000-pcmcia: delete local_info_t typedef
      staging: ft1000-pcmcia: remove firmware download typedefs
      staging: ft1000-pcmcia: remove unused fields from struct ft1000_info
      staging: ft1000-pcmcia: remove custom defines for standard types
      staging: ft1000-pcmcia: remove useless defines from ft1000_cs.c
      staging: ft1000-pcmcia: remove useless debugging from ft1000_cs.c
      staging: ft1000-pcmcia: remove misleading and template comments from ft1000_cs.c
      staging: ft1000-pcmcia: remove unused ft1000_asic_read and ft1000_asic_write functions
      staging: ft1000-pcmcia: coding style fixes in ft1000_cs.c
      staging: ft1000-pcmcia: remove unused includes from ft1000_cs.c
      staging: ft1000-pcmcia: remove useless ft1000_release() function
      staging: ft1000-pcmcia: CodingStyle fixes in ft1000.h
      staging: ft1000-pcmcia: remove PSEUDOSZ, use sizeof(struct pseudo_hdr) instead
      staging: ft1000-pcmcia: remove support for v5 firmware


 drivers/staging/ft1000/ft1000-pcmcia/ft1000.conf   |   14 -
 drivers/staging/ft1000/ft1000-pcmcia/ft1000.h      |  697 +++++++++-----------
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c   |  190 +-----
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_dev.h  |   66 --
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c |  561 ++++++----------
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c   |  224 +++----
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c |   26 +-
 7 files changed, 625 insertions(+), 1153 deletions(-)

-- 
Ondrej Zary



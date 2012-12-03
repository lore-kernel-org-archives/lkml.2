Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab2LCKkE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 05:40:04 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50149 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab2LCKkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 05:40:01 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LAK <linux-arm-kernel@lists.infradead.org>, Sekhar Nori <nsekhar@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Prabhakar Lad <prabhakar.lad@ti.com>
Subject: [PATCH v4 0/2] ARM: davinci: dm355: add support for vpbe display
Date: Mon,  3 Dec 2012 16:09:48 +0530
Message-Id: <1354531190-11073-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunath Hadli <manjunath.hadli@ti.com>

This patch series enables VPBE display driver on DM355.

Changes for v4:
1: pass different platform names to handle different ip's.

Changes for v3:
1: Replaced obsolete preset API by timings API.

Changes for v2:
1: Removed VPSS clock alias for master and slave which was
   sent for VPSS driver. since this patch was dependent on
   patch[1]. I will revist this patch once MC(captrure driver)
   goes into mainline.
[1] http://www.spinics.net/lists/linux-media/msg50562.html

Manjunath Hadli (2):
  ARM: davinci: dm355: add support for v4l2 video display
  ARM: davinci: dm355 EVM: add support for VPBE display

 arch/arm/mach-davinci/board-dm355-evm.c |   73 +++++++++++-
 arch/arm/mach-davinci/davinci.h         |    2 +-
 arch/arm/mach-davinci/dm355.c           |  202 +++++++++++++++++++++++++++++--
 3 files changed, 266 insertions(+), 11 deletions(-)

-- 
1.7.4.1


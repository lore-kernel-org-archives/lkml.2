Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274Ab2HHNO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 09:14:58 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36285 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758127Ab2HHNO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 09:14:57 -0400
From: Prabhakar Lad <prabhakar.lad@ti.com>
To: LAK <linux-arm-kernel@lists.infradead.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        Prabhakar Lad <prabhakar.lad@ti.com>
Subject: [PATCH v3 0/2] ARM: davinci: add support for dm355 vpbe display
Date: Wed, 8 Aug 2012 18:44:35 +0530
Message-ID: <1344431677-32030-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series enables VPBE display driver on DM355. 

This patch series is dependent on this patches posted 
http://www.spinics.net/lists/arm-kernel/msg188234.html

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
 arch/arm/mach-davinci/dm355.c           |  203 +++++++++++++++++++++++++++++--
 3 files changed, 267 insertions(+), 11 deletions(-)


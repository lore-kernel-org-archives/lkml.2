Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075Ab2HHMbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 08:31:34 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41474 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753583Ab2HHMbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 08:31:32 -0400
From: Prabhakar Lad <prabhakar.lad@ti.com>
To: LMML <linux-media@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
        Hans Verkuil <hansverk@cisco.com>, <linux-kernel@vger.kernel.org>,
        Sekhar Nori <nsekhar@ti.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Prabhakar Lad <prabhakar.lad@ti.com>
Subject: [PATCH 0/2] Replace the obsolete preset API by timings API
Date: Wed, 8 Aug 2012 18:00:18 +0530
Message-ID: <1344429020-27616-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This first patch replaces the obsolete preset API by timings
API for davinci VPBE, appropriate chnages in machine file for
dm644x in which VPBE is enabled. And the second patch adds support for 
timings API for ths7303 driver. Sending them as s series 
since VPBE uses the ths7303 driver.

Hans Verkuil (1):
  dm644x: replace the obsolete preset API by the timings API.

Manjunath Hadli (1):
  ths7303: enable THS7303 for HD modes

 arch/arm/mach-davinci/board-dm644x-evm.c   |   15 ++--
 arch/arm/mach-davinci/dm644x.c             |   17 +---
 drivers/media/video/davinci/vpbe.c         |  110 ++++++++++++----------------
 drivers/media/video/davinci/vpbe_display.c |   60 +++++++--------
 drivers/media/video/davinci/vpbe_venc.c    |   25 +++---
 drivers/media/video/ths7303.c              |  107 +++++++++++++++++++++++----
 include/media/davinci/vpbe.h               |   14 ++--
 include/media/davinci/vpbe_types.h         |    8 +--
 include/media/davinci/vpbe_venc.h          |    2 +-
 9 files changed, 202 insertions(+), 156 deletions(-)


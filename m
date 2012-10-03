Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab2JCKDt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 06:03:49 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33407 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960Ab2JCKDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 06:03:48 -0400
Message-ID: <506C0D6F.1070700@ti.com>
Date: Wed, 3 Oct 2012 15:33:27 +0530
From: Prabhakar Lad <prabhakar.lad@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: LMML <linux-media@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Sekhar Nori <nsekhar@ti.com>
Subject: [GIT PULL FOR v3.7] Davinci VPBE feature enhancement and fixes
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

Can you please pull the following patches for davinci VPBE driver.
Some of the patches include platform changes for which Sekhar has Acked it.

Thanks and Regards,
--Prabhakar Lad

The following changes since commit 2425bb3d4016ed95ce83a90b53bd92c7f31091e4:

  em28xx: regression fix: use DRX-K sync firmware requests on em28xx
(2012-10-02 17:15:22 -0300)

are available in the git repository at:
  git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git vpbe_3.7_pull

Hans Verkuil (1):
      dm644x: replace the obsolete preset API by the timings API.

Lad, Prabhakar (2):
      media: davinci: vpbe: fix build warning
      davinci: vpbe: replace V4L2_OUT_CAP_CUSTOM_TIMINGS with
V4L2_OUT_CAP_DV_TIMINGS

Manjunath Hadli (1):
      ths7303: enable THS7303 for HD modes

 arch/arm/mach-davinci/board-dm644x-evm.c      |   15 ++--
 arch/arm/mach-davinci/dm644x.c                |   17 +---
 drivers/media/i2c/ths7303.c                   |  106
++++++++++++++++++++----
 drivers/media/platform/davinci/vpbe.c         |  110
+++++++++++--------------
 drivers/media/platform/davinci/vpbe_display.c |   80 +++++++++---------
 drivers/media/platform/davinci/vpbe_venc.c    |   25 +++---
 include/media/davinci/vpbe.h                  |   14 ++--
 include/media/davinci/vpbe_types.h            |    8 +--
 include/media/davinci/vpbe_venc.h             |    2 +-
 9 files changed, 211 insertions(+), 166 deletions(-)

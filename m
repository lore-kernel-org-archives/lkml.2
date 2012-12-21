Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352Ab2LUH72 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 02:59:28 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:41272 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab2LUH7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 02:59:20 -0500
MIME-Version: 1.0
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 21 Dec 2012 13:28:59 +0530
Message-ID: <CA+V-a8vWKNdVHEopPxAVrdzq=yzE=YxWQ1Pvv8Tm+242_FDUPQ@mail.gmail.com>
Subject: [GIT PULL FOR v3.9] Davinci VPSS Updates
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media <linux-media@vger.kernel.org>,
        dlos <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Prabhakar Lad <prabhakar.lad@ti.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

Please pull the following patches for DaVinci VPSS driver.
These patches have undergone under enormous reviews and
are ready to be queued.

Thanks and Regards,
--Prabhakar Lad

The following changes since commit 4bb891ebf60eb43ebd04e09bbcad24013067873f:

  [media] ivtv: ivtv-driver: Replace 'flush_work_sync()' (2012-12-20
15:22:30 -0200)

are available in the git repository at:
  git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git for_mauro

Manjunath Hadli (3):
      davinci: vpss: dm365: enable ISP registers
      davinci: vpss: dm365: set vpss clk ctrl
      davinci: vpss: dm365: add vpss helper functions to be used in
the main driver for setting hardware parameters

 drivers/media/platform/davinci/vpss.c |   70 ++++++++++++++++++++++++++++++++-
 include/media/davinci/vpss.h          |   16 +++++++
 2 files changed, 85 insertions(+), 1 deletions(-)

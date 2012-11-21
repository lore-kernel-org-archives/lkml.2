Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab2KULVx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 06:21:53 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54882 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387Ab2KULVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 06:21:51 -0500
MIME-Version: 1.0
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 21 Nov 2012 16:51:30 +0530
Message-ID: <CA+V-a8s=1CO9=kQFz0ALGEwS606Gcz3fxZBsvrnJpkWJn3KAPA@mail.gmail.com>
Subject: [GIT PULL FOR v3.8] Davinci VPIF trivial fixes
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        dlos <davinci-linux-open-source@linux.davincidsp.com>,
        Prabhakar Lad <prabhakar.lad@ti.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

Can you please pull the following patches for vpif, which fixes
some trivial issues.

Thanks and Regards,
--Prabhakar Lad

The following changes since commit 2c4e11b7c15af70580625657a154ea7ea70b8c76:

  [media] siano: fix RC compilation (2012-11-07 11:09:08 +0100)

are available in the git repository at:
  git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git pull_vpif

Hans Verkuil (2):
      vpif_capture: protect dma_queue by a spin_lock.
      vpif_display: protect dma_queue by a spin_lock.

Wei Yongjun (3):
      davinci: vpif_capture: fix return type check for v4l2_subdev_call()
      davinci: vpif_display: fix return type check for v4l2_subdev_call()
      davinci: vpif: fix return value check for vb2_dma_contig_init_ctx()

 drivers/media/platform/davinci/vpif_capture.c |   34 +++++++++++++++++++-----
 drivers/media/platform/davinci/vpif_display.c |   28 +++++++++++++++++---
 2 files changed, 50 insertions(+), 12 deletions(-)

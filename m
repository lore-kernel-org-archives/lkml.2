Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369Ab1CJURK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 15:17:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17131 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069Ab1CJURI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 15:17:08 -0500
Message-ID: <4D7931A0.7070609@redhat.com>
Date: Thu, 10 Mar 2011 17:16:32 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v2.6.38-rc8] drivers/media fixes
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git media_fixes

For a couple of random fixes, including a some regressions.

Thanks!
Mauro.

The following changes since commit 100b33c8bd8a3235fd0b7948338d6cbb3db3c63d:

  Linux 2.6.38-rc4 (2011-02-07 16:03:55 -0800)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git media_fixes

Andy Walls (2):
      [media] cx23885: Revert "Check for slave nack on all transactions"
      [media] cx23885: Remove unused 'err:' labels to quiet compiler warning

Antti Seppälä (1):
      [media] Fix sysfs rc protocol lookup for rc-5-sz

Arnaud Patard (1):
      [media] mantis_pci: remove asm/pgtable.h include

Devin Heitmueller (2):
      [media] au0828: fix VBI handling when in V4L2 streaming mode
      [media] cx18: Add support for Hauppauge HVR-1600 models with s5h1411

Jarod Wilson (3):
      [media] nuvoton-cir: fix wake from suspend
      [media] mceusb: don't claim multifunction device non-IR parts
      [media] tda829x: fix regression in probe functions

Malcolm Priestley (1):
      [media] DM04/QQBOX memcpy to const char fix

Mauro Carvalho Chehab (1):
      [media] ir-raw: Properly initialize the IR event (BZ#27202)

Michael (1):
      [media] ivtv: Fix corrective action taken upon DMA ERR interrupt to avoid hang

Olivier Grenie (1):
      [media] DiB7000M: add pid filtering

Pawel Osciak (1):
      [media] Fix double free of video_device in mem2mem_testdev

Sven Barth (1):
      [media] cx25840: fix probing of cx2583x chips

sensoray-dev (1):
      [media] s2255drv: firmware re-loading changes

 drivers/media/common/tuners/tda8290.c       |   14 +++---
 drivers/media/dvb/dvb-usb/dib0700_devices.c |   21 +++++++++-
 drivers/media/dvb/dvb-usb/lmedm04.c         |    6 +-
 drivers/media/dvb/frontends/dib7000m.c      |   19 +++++++++
 drivers/media/dvb/frontends/dib7000m.h      |   15 +++++++
 drivers/media/dvb/mantis/mantis_pci.c       |    1 -
 drivers/media/rc/ir-raw.c                   |    3 +-
 drivers/media/rc/mceusb.c                   |   27 +++++++------
 drivers/media/rc/nuvoton-cir.c              |    5 +-
 drivers/media/rc/nuvoton-cir.h              |    7 ++-
 drivers/media/rc/rc-main.c                  |    2 +-
 drivers/media/video/au0828/au0828-video.c   |   28 +++++++++++--
 drivers/media/video/cx18/cx18-cards.c       |   50 ++++++++++++++++++++++-
 drivers/media/video/cx18/cx18-driver.c      |   25 +++++++++++-
 drivers/media/video/cx18/cx18-driver.h      |    3 +-
 drivers/media/video/cx18/cx18-dvb.c         |   38 +++++++++++++++++
 drivers/media/video/cx23885/cx23885-i2c.c   |   10 -----
 drivers/media/video/cx25840/cx25840-core.c  |    3 +-
 drivers/media/video/ivtv/ivtv-irq.c         |   58 +++++++++++++++++++++++---
 drivers/media/video/mem2mem_testdev.c       |    1 -
 drivers/media/video/s2255drv.c              |   10 +++--
 21 files changed, 283 insertions(+), 63 deletions(-)


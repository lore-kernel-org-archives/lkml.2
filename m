Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359Ab0FADXZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 23:23:25 -0400
Received: from mail.perches.com ([173.55.12.10]:2461 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752957Ab0FADXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 23:23:24 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 00/21] Remove unnecessary kmalloc casts
Date: Mon, 31 May 2010 20:23:02 -0700
Message-Id: <cover.1275360951.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.3.311.g6a6955
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches (21):
  arch/cris: Remove unnecessary kmalloc casts
  arch/powerpc: Remove unnecessary kmalloc casts
  arch/x86/kernel/tlb_uv.c: Remove unnecessary kmalloc casts
  drivers/block/cciss_scsi.c: Remove unnecessary kmalloc casts
  drivers/gpu/drm: Remove unnecessary kmalloc casts
  drivers/i2c/i2c-dev.c: Remove unnecessary kmalloc casts
  drivers/isdn/capi/capidrv.c: Remove unnecessary kmalloc casts
  drivers/media: Remove unnecesary kmalloc casts
  drivers/message/i2o/i20_config.c: Remove unnecessary kmalloc casts
  drivers/net/gianfar.c: Remove unnecessary kmalloc casts
  drivers/net/tulip/eeprom.c: Remove unnecessary kmalloc casts
  drivers/net/vxge/vxge-main.c: Remove unnecessary kmalloc casts
  drivers/net/wireless/ipw2x00/ipw2100.c: Remove unnecessary kmalloc casts
  drivers/parisc/iosapic.c: Remove unnecessary kzalloc cast
  drivers/s390: Remove unnecessary kmalloc casts
  drivers/serial/icom.c: Remove unnecessary kmalloc casts
  drivers/usb/storage/isd200.c: Remove unnecessary kmalloc casts
  fs/ufs/util.c: Remove unnecessary kmalloc casts
  net/ipv4/igmp.c: Remove unnecessary kmalloc casts
  net/ipv6/mcast.c: Remove unnecessary kmalloc casts
  net/sctp/protocol.c: Remove unnecessary kmalloc casts

 arch/cris/arch-v32/mm/intmem.c         |   13 +++++--------
 arch/powerpc/kernel/nvram_64.c         |    3 +--
 arch/powerpc/kvm/book3s.c              |    4 ++--
 arch/x86/kernel/tlb_uv.c               |   15 +++++++--------
 drivers/block/cciss_scsi.c             |    3 +--
 drivers/gpu/drm/drm_sman.c             |    4 +---
 drivers/gpu/drm/i915/i915_dma.c        |    3 +--
 drivers/i2c/i2c-dev.c                  |    4 +---
 drivers/isdn/capi/capidrv.c            |    3 +--
 drivers/media/dvb/siano/smscoreapi.c   |    4 +---
 drivers/media/video/w9968cf.c          |    3 +--
 drivers/message/i2o/i2o_config.c       |    3 +--
 drivers/net/gianfar.c                  |    8 ++++----
 drivers/net/tulip/eeprom.c             |   10 +++++-----
 drivers/net/vxge/vxge-main.c           |    4 +---
 drivers/net/wireless/ipw2x00/ipw2100.c |   18 +++++++-----------
 drivers/parisc/iosapic.c               |    4 ++--
 drivers/s390/block/dasd_devmap.c       |    3 +--
 drivers/s390/char/con3215.c            |    4 ++--
 drivers/serial/icom.c                  |    3 +--
 drivers/usb/storage/isd200.c           |    3 +--
 fs/ufs/util.c                          |    3 +--
 net/ipv4/igmp.c                        |    3 +--
 net/ipv6/mcast.c                       |    3 +--
 net/sctp/protocol.c                    |    3 +--
 25 files changed, 51 insertions(+), 80 deletions(-)


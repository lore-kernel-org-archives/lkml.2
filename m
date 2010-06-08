Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab0FHDur (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 23:50:47 -0400
Received: from mail.perches.com ([173.55.12.10]:2756 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082Ab0FHDuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 23:50:46 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/12] treewide: Remove unnecessary kmalloc casts
Date: Mon,  7 Jun 2010 20:50:32 -0700
Message-Id: <cover.1275968594.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.244.gbdc4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial cleanups

Joe Perches (12):
  arch/cris: Remove unnecessary kmalloc casts
  arch/powerpc: Remove unnecessary kmalloc casts
  arch/x86/kernel/tlb_uv.c: Remove unnecessary kmalloc casts
  drivers/gpu/drm: Remove unnecessary kmalloc casts
  drivers/isdn/capi/capidrv.c: Remove unnecessary kmalloc casts
  drivers/media: Remove unnecesary kmalloc casts
  drivers/message/i2o/i20_config.c: Remove unnecessary kmalloc casts
  drivers/parisc/iosapic.c: Remove unnecessary kzalloc cast
  drivers/s390: Remove unnecessary kmalloc casts
  drivers/serial/icom.c: Remove unnecessary kmalloc casts
  drivers/usb/storage/isd200.c: Remove unnecessary kmalloc casts
  fs/ufs/util.c: Remove unnecessary kmalloc casts


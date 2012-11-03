Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab2KCWCs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 18:02:48 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48038 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab2KCWCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 18:02:46 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/9] Fixups for issues when running 'make randconfig'
Date: Sat,  3 Nov 2012 23:02:21 +0100
Message-Id: <1351980150-24145-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set is the result of fixing some problems encountered when
building the kernel with randconfig and a when running a script I wrote
to identify unused structures.

 arch/arm/mach-at91/at91sam9263_devices.c |   20 --------------------
 arch/arm/mach-integrator/cpu.c           |   12 ------------
 arch/x86/kernel/quirks.c                 |    4 ++--
 drivers/isdn/i4l/isdn_common.c           |    1 -
 drivers/virtio/virtio_mmio.c             |    2 +-
 fs/quota/quota.c                         |    4 ++++
 kernel/sched/fair.c                      |    4 ++++
 net/bridge/br_private.h                  |    8 ++++----
 sound/soc/codecs/Kconfig                 |    2 +-
 9 files changed, 16 insertions(+), 41 deletions(-)


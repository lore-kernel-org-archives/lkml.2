Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab0ELATA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 20:19:00 -0400
Received: from blue-ld-261.synserver.de ([217.119.54.83]:58045 "EHLO
	smtp-out-072.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752742Ab0ELASw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 20:18:52 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 21078
From: Lars-Peter Clausen <lars@metafoo.de>
To: sameo@linux.intel.com
Cc: fercerpav@gmail.com, linux-kernel@vger.kernel.org,
       Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 0/4] MFD: pcf50633: Fixes and updates
Date: Wed, 12 May 2010 02:10:52 +0200
Message-Id: <1273623056-1243-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This patch series contains fixes and updates for the pcf50633 mfd and adc
driver.

Lars-Peter Clausen (4):
  MFD: pcf50633: Fix bitfield logic in interrupt handler
  MFD: pcf50633-adc: Fix potential race pcf50633_adc_sync_read
  MFD: pcf50633: Use threaded irq
  MFD: pcf50633: Move irq related functions to its own file.

 drivers/mfd/Makefile        |    3 +-
 drivers/mfd/pcf50633-adc.c  |   39 ++---
 drivers/mfd/pcf50633-core.c |  344 ++-----------------------------------------
 drivers/mfd/pcf50633-irq.c  |  318 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 346 insertions(+), 358 deletions(-)
 create mode 100644 drivers/mfd/pcf50633-irq.c


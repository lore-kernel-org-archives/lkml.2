Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab0H3LrM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 07:47:12 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:48522 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab0H3LrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 07:47:11 -0400
Date: Mon, 30 Aug 2010 20:46:59 +0900
From: Kyungmin Park <kmpark@infradead.org>
Subject: [PATCH 0/3] ARM: Samsung: Move/use the S3C/S5P common GPIO IRQ type
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: jy0922.shim@samsung.com, m.szyprowski@samsung.com, ben-linux@fluff.org,
        kgene.kim@samsung.com
Message-id: <20100830114659.GA13136@july>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 30 Aug 2010 11:47:08.0287 (UTC)
 FILETIME=[133690F0:01CB4839]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 29cfcddc0e745b515ec360ffe2ee4e7a4015efd8:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6 (2010-08-28 15:42:44 -0700)

Kyungmin Park (3):
      ARM: Samsung S5P: Move the common Samsung S5P series GPIO level type
      ARM: Samsung S5P: Use the Samsung S5P series common IRQ type
      ARM: Samsung S3C: Move/use the S3C common GPIO IRQ type

 arch/arm/mach-s3c64xx/irq-eint.c                  |   12 ++++++------
 arch/arm/mach-s5pc100/include/mach/regs-gpio.h    |    7 -------
 arch/arm/mach-s5pc100/irq-gpio.c                  |   16 +++++-----------
 arch/arm/mach-s5pv210/include/mach/regs-gpio.h    |    7 -------
 arch/arm/plat-s3c24xx/irq.c                       |   14 +++++++-------
 arch/arm/plat-s5p/irq-eint.c                      |   13 ++++++-------
 arch/arm/plat-samsung/include/plat/gpio-core.h    |   12 ++++++++++++
 arch/arm/plat-samsung/include/plat/regs-irqtype.h |   21 ---------------------
 8 files changed, 36 insertions(+), 66 deletions(-)
 delete mode 100644 arch/arm/plat-samsung/include/plat/regs-irqtype.h


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab2AEO7S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 09:59:18 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:32811 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438Ab2AEO7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 09:59:17 -0500
Message-ID: <4F05BAC1.1000706@gmail.com>
Date: Thu, 05 Jan 2012 08:59:13 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PULL] gpio pl061 for 3.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant,

Since it seems irqdomain issues aren't going to get sorted out for 3.3,
please pull the pl061 changes which are not dependent on irqdomain.
Sorry it is a bit late.

The following changes since commit 5f0a6e2d503896062f641639dacfe5055c2f593b:

  Linux 3.2-rc7 (2011-12-23 21:51:06 -0800)

are available in the git repository at:
  git://sources.calxeda.com/kernel/linux.git gpio-for-grant

Rob Herring (5):
      gpio: pl061: use chained_irq_* functions in irq handler
      gpio: pl061: convert to use 0 for no irq
      ARM: realview: convert pl061 no irq to 0 instead of -1
      gpio: pl061: convert to use generic irq chip
      gpio: pl061: remove combined interrupt

 arch/arm/mach-realview/realview_eb.c     |    3 -
 arch/arm/mach-realview/realview_pb1176.c |    3 -
 arch/arm/mach-realview/realview_pb11mp.c |    3 -
 arch/arm/mach-realview/realview_pba8.c   |    3 -
 arch/arm/mach-realview/realview_pbx.c    |    3 -
 drivers/gpio/Kconfig                     |    1 +
 drivers/gpio/gpio-pl061.c                |  132
++++++++++--------------------
 include/linux/amba/pl061.h               |    2 +-
 8 files changed, 44 insertions(+), 106 deletions(-)

Rob

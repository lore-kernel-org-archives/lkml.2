Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934315Ab1KCRB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 13:01:56 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14847 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934085Ab1KCRBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 13:01:53 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 03 Nov 2011 10:01:04 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Paul Mundt <lethal@linux-sh.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        David Brown <davidb@codeaurora.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-sh@vger.kernel.org>
Subject: [PATCH 0/3] Change ARCH_NR_GPIO into a Kconfig variable
Date: Thu, 3 Nov 2011 19:00:44 +0200
Message-ID: <1320339647-30255-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset converts ARCH_NR_GPIO to a Kconfig variable as suggested by
Russel King. It also converts some platforms to the new model.

Peter De Schrijver (3):
  ARM: ARCH_NR_GPIO: Make ARCH_NR_GPIO a Kconfig variable
  ARM: mach-shmobile: Use CONFIG_ARCH_NR_GPIO
  ARM: mach-ux500 Use CONFIG_ARCH_NR_GPIO

 arch/arm/Kconfig                           |   10 ++++++++++
 arch/arm/include/asm/gpio.h                |    4 ++++
 arch/arm/mach-shmobile/include/mach/gpio.h |    2 --
 arch/arm/mach-ux500/include/mach/gpio.h    |    5 -----
 4 files changed, 14 insertions(+), 7 deletions(-)

-- 
1.7.7.rc0.72.g4b5ea.dirty


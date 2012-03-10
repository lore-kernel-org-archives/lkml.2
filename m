Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829Ab2CJSpG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 13:45:06 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48309 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab2CJSo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 13:44:26 -0500
From: Alan Ott <alan@signal11.us>
To: Russell King <linux@arm.linux.org.uk>, Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Arnd Bergmann <arnd@arndb.de>, Alan Ott <alan@signal11.us>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Alan Ott <alan@signal11.us>
Subject: [PATCH 0/2] ARM: AT91: cleanup patches from Arnd Bergmann
Date: Sat, 10 Mar 2012 13:44:09 -0500
Message-Id: <1331405049-3186-1-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm helping Arnd Bergmann get some of his cleanup patches upstream. This
set covers the AT91 and is based off of torvalds/linux.git.

Thanks,

Alan.

Arnd Bergmann (2):
  ARM: at91: only RM9200 has ISA-style PIO
  ARM: at91: Use proper __iomem annotations

 arch/arm/Kconfig                           |    1 +
 arch/arm/mach-at91/at91rm9200.c            |    2 +-
 arch/arm/mach-at91/include/mach/hardware.h |    4 ++++
 arch/arm/mach-at91/setup.c                 |    4 ++--
 4 files changed, 8 insertions(+), 3 deletions(-)


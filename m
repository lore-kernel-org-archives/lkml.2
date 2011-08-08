Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887Ab1HHIum (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 04:50:42 -0400
Received: from mail0.scram.de ([78.47.204.202]:49013 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499Ab1HHIul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 04:50:41 -0400
Authentication-Results: localhost; dkim=pass (1024-bit key)
	header.i=@scram.de; dkim-asp=signed
X-Spam-Flag: NO
X-Spam-Score: -4.376
Authentication-Results: amavis.colab.de (amavisd-new); dkim=pass
	header.i=@scram.de
From: Jochen Friedrich <jochen@scram.de>
To: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        bryan.wu@canonical.com, kristoffer.ericson@gmail.com
Cc: linux-kernel@vger.kernel.org, Jochen Friedrich <jochen@scram.de>
Subject: [PATCH 3.2 0/4] ARM: simpad: Add support for GPIO attached hardware
Date: Mon,  8 Aug 2011 10:49:35 +0200
Message-Id: <1312793379-6020-1-git-send-email-jochen@scram.de>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series enables GPIO API on UCB1x00 and implements the GPIO
API on the CS3 latch. The third patch finally registers platform
devices for the GPIO attached LED, buttons and I2C bus.

ARM: simpad: Add ucb1x00 GPIO definitions and register GPIO
ARM: simpad: Cleanup CS3 accessors and add GPIO API
ARM: simpad: add GPIO based device definitions
ARM: simpad: replace ARM specific LED code

Overall diffstat:

 arch/arm/mach-sa1100/leds-simpad.c           |  100 ------------
 b/arch/arm/mach-sa1100/Makefile              |    1 
 b/arch/arm/mach-sa1100/include/mach/simpad.h |   94 +++++++++--
 b/arch/arm/mach-sa1100/leds.c                |    2 
 b/arch/arm/mach-sa1100/leds.h                |    1 
 b/arch/arm/mach-sa1100/simpad.c              |  213 +++++++++++++++++++++++----
 b/drivers/pcmcia/sa1100_simpad.c             |   35 ++--
 7 files changed, 275 insertions(+), 171 deletions(-)

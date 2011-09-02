Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab1IBSad (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 14:30:33 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:47248 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935Ab1IBSac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 14:30:32 -0400
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: x86@kernel.org
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/4] Support for the TS-5500 platform
Date: Fri,  2 Sep 2011 14:30:20 -0400
Message-Id: <1314988224-13162-1-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to H. Peter Anvin and Mark Brown for the comments and
explanations given in the previous versions of this patch set.

This is the third version, which brings support for
the Technologic Systems TS-5500 Single Board Computer.
The code is rebased on v3.1-rc4.

The first patch adds the base for the support of the board in
/arch/x86/platform/ts5500 and a documentation file in
Documentation/ABI/testing/sysfs-platform-ts5500.

The second patch adds support for GPIO.

The third patch adds support for the on-board LED.

The fourth patch brings support for the Analogic/Digital converter.

Jerome Oufella (1):
  platform: (TS-5500) add GPIO support

Jonas Fonseca (2):
  platform: (TS-5500) add LED support
  platform: (TS-5500) add ADC support

Vivien Didelot (1):
  platform: (TS-5500) add base support

 Documentation/ABI/testing/sysfs-platform-ts5500 |   46 +++
 MAINTAINERS                                     |    5 +
 arch/x86/Kconfig                                |    2 +
 arch/x86/platform/Makefile                      |    1 +
 arch/x86/platform/ts5500/Kconfig                |   28 ++
 arch/x86/platform/ts5500/Makefile               |    4 +
 arch/x86/platform/ts5500/ts5500.c               |  468 +++++++++++++++++++++++
 arch/x86/platform/ts5500/ts5500_adc.c           |  326 ++++++++++++++++
 arch/x86/platform/ts5500/ts5500_adc.h           |   62 +++
 arch/x86/platform/ts5500/ts5500_gpio.c          |  413 ++++++++++++++++++++
 arch/x86/platform/ts5500/ts5500_gpio.h          |   60 +++
 arch/x86/platform/ts5500/ts5500_led.c           |  115 ++++++
 12 files changed, 1530 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-platform-ts5500
 create mode 100644 arch/x86/platform/ts5500/Kconfig
 create mode 100644 arch/x86/platform/ts5500/Makefile
 create mode 100644 arch/x86/platform/ts5500/ts5500.c
 create mode 100644 arch/x86/platform/ts5500/ts5500_adc.c
 create mode 100644 arch/x86/platform/ts5500/ts5500_adc.h
 create mode 100644 arch/x86/platform/ts5500/ts5500_gpio.c
 create mode 100644 arch/x86/platform/ts5500/ts5500_gpio.h
 create mode 100644 arch/x86/platform/ts5500/ts5500_led.c

-- 
1.7.6


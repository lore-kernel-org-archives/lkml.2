Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab2ASADj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 19:03:39 -0500
Received: from mail.savoirfairelinux.com ([209.172.62.77]:41624 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748Ab2ASADh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 19:03:37 -0500
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: x86@kernel.org
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        "Ingo Molnar" <mingo@redhat.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/4] Support for the TS-5500 platform
Date: Wed, 18 Jan 2012 18:52:07 -0500
Message-Id: <1326930731-21215-1-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support for the Technologic Systems TS-5500 Single Board Computer.

This fourth version of the patches set fixes a small Kconfig dependency issue,
pointed out by Ingo, and turns GPIO, LED, and ADC drivers into modules, as
suggested by HPA. The code is rebased on v3.2.

The first patch adds the base support for the board in
/arch/x86/platform/ts5500 and a documentation file in
Documentation/ABI/testing/sysfs-platform-ts5500.

The second patch adds support for GPIO.

The third patch adds support for the on-board LED.

The fourth patch brings support for the Analogic/Digital converter.

Jerome Oufella (1):
  x86/platform: (TS-5500) add GPIO support

Jonas Fonseca (2):
  x86/platform: (TS-5500) add LED support
  x86/platform: (TS-5500) add ADC support

Vivien Didelot (1):
  x86/platform: (TS-5500) add platform base support

 Documentation/ABI/testing/sysfs-platform-ts5500 |   46 +++
 MAINTAINERS                                     |    5 +
 arch/x86/Kconfig                                |    2 +
 arch/x86/platform/Makefile                      |    1 +
 arch/x86/platform/ts5500/Kconfig                |   29 ++
 arch/x86/platform/ts5500/Makefile               |    4 +
 arch/x86/platform/ts5500/ts5500.c               |  302 ++++++++++++++
 arch/x86/platform/ts5500/ts5500.h               |   35 ++
 arch/x86/platform/ts5500/ts5500_adc.c           |  478 ++++++++++++++++++++++
 arch/x86/platform/ts5500/ts5500_gpio.c          |  479 +++++++++++++++++++++++
 arch/x86/platform/ts5500/ts5500_gpio.h          |   60 +++
 arch/x86/platform/ts5500/ts5500_led.c           |  180 +++++++++
 12 files changed, 1621 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-platform-ts5500
 create mode 100644 arch/x86/platform/ts5500/Kconfig
 create mode 100644 arch/x86/platform/ts5500/Makefile
 create mode 100644 arch/x86/platform/ts5500/ts5500.c
 create mode 100644 arch/x86/platform/ts5500/ts5500.h
 create mode 100644 arch/x86/platform/ts5500/ts5500_adc.c
 create mode 100644 arch/x86/platform/ts5500/ts5500_gpio.c
 create mode 100644 arch/x86/platform/ts5500/ts5500_gpio.h
 create mode 100644 arch/x86/platform/ts5500/ts5500_led.c

-- 
1.7.6.5


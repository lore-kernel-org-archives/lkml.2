Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483Ab1GDV5P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 17:57:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53980 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406Ab1GDV5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 17:57:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] arm soc tree, at91 patches for 3.0
Date: Mon, 4 Jul 2011 23:53:22 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Victor <linux@maxim.org.za>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, tglx@linutronix.de
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201107042353.22970.arnd@arndb.de>
X-Provags-ID: V02:K0:y0A/nwMb0to7KUJbeQULI5tiMuIFXwtwKjnJxNKxv7h
 fUC8J59tcvtKyM/S9E/ikLL1Ie6VlNo8m4dz9HlUdeAX5/ELv3
 VZOhEFlahDVWKch/74k91gW7g9ebdy6QnsGe/CocZt871lGffa
 uERJwV686YpqX4wBSsBTLd+GiLsDpcHZleOLYgwtNw0uGVwmpH
 8nZ7A27vnBTabixX2+zsQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the first pull request for the new arm-soc tree. These are all bug
fixes for the at91 subarchitecture that we'd still like to see merged in 3.0.

	Arnd

The following changes since commit c66a86d0cdce3bad2da794f114cc37377d242c3d:

  Merge branch 'drm-intel-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/keithp/linux-2.6 (2011-07-01 16:38:59 -0700)

are available in the git repository at:

  git+ssh://master.kernel.org/pub/scm/linux/kernel/git/arm/linux-2.6-arm-soc.git/ at91/fixes

Jean-Christophe PLAGNIOL-VILLARD (3):
      at91: fix at91_set_serial_console: use platform device id
      atmel_serial: fix internal port num
      at91: fix udc, ehci and mmc clock device name for cap9/9g45/9rl

Joachim Eastwood (1):
      at91: Use "pclk" as con_id on at91cap9 and at91rm9200

Nicolas Ferre (1):
      AT91: Change nand buswidth logic to match hardware default configuration

 arch/arm/mach-at91/at91cap9.c                |    8 ++++----
 arch/arm/mach-at91/at91cap9_devices.c        |    2 +-
 arch/arm/mach-at91/at91rm9200.c              |    6 +++---
 arch/arm/mach-at91/at91rm9200_devices.c      |    2 +-
 arch/arm/mach-at91/at91sam9260_devices.c     |    2 +-
 arch/arm/mach-at91/at91sam9261_devices.c     |    2 +-
 arch/arm/mach-at91/at91sam9263_devices.c     |    2 +-
 arch/arm/mach-at91/at91sam9g45.c             |   10 +++++-----
 arch/arm/mach-at91/at91sam9g45_devices.c     |    2 +-
 arch/arm/mach-at91/at91sam9rl.c              |    4 ++--
 arch/arm/mach-at91/at91sam9rl_devices.c      |    2 +-
 arch/arm/mach-at91/board-cap9adk.c           |    2 +-
 arch/arm/mach-at91/board-sam9260ek.c         |    2 +-
 arch/arm/mach-at91/board-sam9261ek.c         |    2 +-
 arch/arm/mach-at91/board-sam9263ek.c         |    2 +-
 arch/arm/mach-at91/board-sam9g20ek.c         |    2 +-
 arch/arm/mach-at91/board-sam9m10g45ek.c      |    2 +-
 arch/arm/mach-at91/include/mach/system_rev.h |   10 +++++-----
 drivers/tty/serial/atmel_serial.c            |    3 ++-
 19 files changed, 34 insertions(+), 33 deletions(-)

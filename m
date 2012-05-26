Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961Ab2EZHXY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 03:23:24 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63447 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab2EZHXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 03:23:11 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 5/8] arm-soc: add stmp-dev library code
Date: Sat, 26 May 2012 00:22:35 -0700
Message-Id: <1338016958-7887-6-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.1.488.g05fbf7a
In-Reply-To: <1338016958-7887-1-git-send-email-olof@lixom.net>
References: <1338016958-7887-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A number of devices are using a common register layout, this adds support
code for it in lib/stmp_device.c so we do not need to duplicate it in
each driver.

----------------------------------------------------------------

The following changes since commit 0ac1de7ff6397b16530c23fcd31961a21498cff0:

  Merge tag 'clock' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/stmp-dev

for you to fetch changes up to 3f81b2c49d31e763a9c1da831ceb6cef087cf6c6:

  Merge branch 'stmp_device' of git://git.pengutronix.de/git/wsa/linux into next/stmp-dev

----------------------------------------------------------------

Arnd Bergmann (1):
      Merge branch 'stmp_device' of git://git.pengutronix.de/git/wsa/linux into next/stmp-dev

Wolfram Sang (2):
      lib: add support for stmp-style devices
      i2c: mxs: use global reset function


 drivers/i2c/busses/Kconfig   |  1 +
 drivers/i2c/busses/i2c-mxs.c |  7 +---
 include/linux/stmp_device.h  | 20 ++++++++++
 lib/Kconfig                  |  3 ++
 lib/Makefile                 |  2 +
 lib/stmp_device.c            | 80 +++++++++++++++++++++++++++++++++++++++
 6 files changed, 108 insertions(+), 5 deletions(-)
 create mode 100644 include/linux/stmp_device.h
 create mode 100644 lib/stmp_device.c

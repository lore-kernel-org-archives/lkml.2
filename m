Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419Ab2L0XVJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 18:21:09 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:65008 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab2L0XVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 18:21:08 -0500
From: Tony Prisk <linux@prisktech.co.nz>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH 0/4] arm: vt8500: Add new models and remove single-platform.
Date: Fri, 28 Dec 2012 12:20:48 +1300
Message-Id: <1356650452-16559-1-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd/Olaf,

These patches should be pretty self explanatory.

#1 - Adds support for WM8750 and WM8850.
#2 - Remove the single-platform Kconfig options.
#3 - Move the early debug code so it can be used for multiplatform.
#4 - Cleanup the unused headers in arch/arm/mach-vt8500/include.

Tony Prisk (4):
  arm: vt8500: Add support for Wondermedia WM8750/WM8850
  arm: vt8500: Remove single platform Kconfig options
  arm: vt8500: Convert debug-macro.S to be multiplatform friendly
  arm: vt8500: Remove remaining mach includes

 Documentation/devicetree/bindings/arm/vt8500.txt |    8 +++++
 arch/arm/Kconfig                                 |   16 ----------
 arch/arm/Kconfig.debug                           |    8 +++++
 arch/arm/mach-vt8500/Kconfig                     |   26 +++++++++++++--
 arch/arm/mach-vt8500/include/mach/debug-macro.S  |   31 ------------------
 arch/arm/mach-vt8500/include/mach/timex.h        |   26 ---------------
 arch/arm/mach-vt8500/include/mach/uncompress.h   |   37 ----------------------
 arch/arm/mach-vt8500/vt8500.c                    |    2 ++
 8 files changed, 41 insertions(+), 113 deletions(-)
 delete mode 100644 arch/arm/mach-vt8500/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-vt8500/include/mach/timex.h
 delete mode 100644 arch/arm/mach-vt8500/include/mach/uncompress.h

-- 
1.7.9.5


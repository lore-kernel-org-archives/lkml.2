Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab2CHBgg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 20:36:36 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:51755 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002Ab2CHBew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 20:34:52 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>
Subject: [PATCH 00/11] staging: Android updates (take 2)
Date: Wed,  7 Mar 2012 17:34:27 -0800
Message-Id: <1331170478-30538-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030801-9360-0000-0000-000004571189
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg, 
	Once again, here's the Android updates to the staging-next tree
so they can be queued for 3.4. This time w/ commit style changes you
requested I've pulled these from the common/android-3.3 branch, and made
only some minor changes to keep everything in the staging dir and to avoid
compile issues on x86.

The patches can be browsed over here:
http://git.linaro.org/gitweb?p=people/jstultz/android-dev.git;a=shortlog;h=refs/heads/dev/android-staging-updates

thanks
-john

CC: Greg KH <gregkh@linuxfoundation.org>
CC: Android Kernel Team <kernel-team@android.com>

Colin Cross (9):
  android: ram_console: move footer strings
  android: ram_console: drop early buffer support
  android: ram_console: drop verbose ram_console support
  android: ram_console: split out persistent ram
  android: persistent_ram: refactor ecc support
  android: persistent_ram: handle reserving and mapping memory
  android: persistent_ram: make persistent_ram_write atomic
  android: persistent_ram: add notrace to persistent_ram_write
  android: staging: ram_console: fix crash in ram_console_late_init

Dima Zavin (1):
  android: ram_console: set CON_ANYTIME console flag

Nick Kralevich (1):
  android: ram_console: honor dmesg_restrict

 drivers/staging/android/Kconfig          |   60 +----
 drivers/staging/android/Makefile         |    1 +
 drivers/staging/android/persistent_ram.c |  470 ++++++++++++++++++++++++++++++
 drivers/staging/android/persistent_ram.h |   78 +++++
 drivers/staging/android/ram_console.c    |  412 +++++---------------------
 5 files changed, 629 insertions(+), 392 deletions(-)
 create mode 100644 drivers/staging/android/persistent_ram.c
 create mode 100644 drivers/staging/android/persistent_ram.h

-- 
1.7.3.2.146.gca209


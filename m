Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758599Ab2CGWAq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 17:00:46 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:51055 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754926Ab2CGV6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:58:41 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>
Subject: [PATCH 00/13] staging: Android updates
Date: Wed,  7 Mar 2012 13:58:10 -0800
Message-Id: <1331157503-3413-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030721-7182-0000-0000-000000FDF960
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg, 
        Just wanted to send along some Android updates to the staging-next tree
so they can be queued for 3.4. I've pulled these from the
common/android-3.3 branch, and made only some minor changes to keep
everything in the staging dir and to avoid compile issues on x86.

The patches can be browsed over here:
http://git.linaro.org/gitweb?p=people/jstultz/android-dev.git;a=shortlog;h=refs/heads/dev/android-staging-updates

thanks
-john

CC: Greg KH <gregkh@linuxfoundation.org>
CC: Android Kernel Team <kernel-team@android.com>

Colin Cross (10):
  android: ram_console: move footer strings
  android: ram_console: drop early buffer support
  android: ram_console: drop verbose ram_console support
  android: ram_console: split out persistent ram
  android: persistent_ram: refactor ecc support
  android: persistent_ram: handle reserving and mapping memory
  android: persistent_ram: make persistent_ram_write atomic
  android: persistent_ram: add notrace to persistent_ram_write
  android: persistent_trace: ftrace into persistent_ram
  android: staging: ram_console: fix crash in ram_console_late_init

Dima Zavin (1):
  android: ram_console: set CON_ANYTIME console flag

John Stultz (1):
  android: lowmemorykiller: Fix warning on 64bit

Nick Kralevich (1):
  android: ram_console: honor dmesg_restrict

 drivers/staging/android/Kconfig            |   70 +---
 drivers/staging/android/Makefile           |    4 +
 drivers/staging/android/lowmemorykiller.c  |    2 +-
 drivers/staging/android/persistent_ram.c   |  470 ++++++++++++++++++++++++++++
 drivers/staging/android/persistent_ram.h   |   78 +++++
 drivers/staging/android/ram_console.c      |  412 +++++--------------------
 drivers/staging/android/trace_persistent.c |  242 ++++++++++++++
 7 files changed, 887 insertions(+), 391 deletions(-)
 create mode 100644 drivers/staging/android/persistent_ram.c
 create mode 100644 drivers/staging/android/persistent_ram.h
 create mode 100644 drivers/staging/android/trace_persistent.c

-- 
1.7.3.2.146.gca209


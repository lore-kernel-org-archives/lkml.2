Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030350Ab2CGVeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:34:21 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:33947 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758278Ab2CGVeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:34:16 -0500
Message-ID: <1331156046.2191.185.camel@work-vm>
Subject: [GIT PULL] staging: Android updates
From: John Stultz <john.stultz@linaro.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Android Kernel Team <kernel-team@android.com>,
        lkml <linux-kernel@vger.kernel.org>
Date: Wed, 07 Mar 2012 13:34:06 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030721-7408-0000-0000-00000348FC2D
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


The following changes since commit 1ec41a31fb695682cab7fc7c1f6ced84d188b6f9:

  staging: ozwpan: remove debug allocator (2012-03-02 16:51:09 -0800)

are available in the git repository at:
  git://git.linaro.org/people/jstultz/android-dev.git dev/android-staging-updates

Colin Cross (11):
      android: binder: fix warning
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
 drivers/staging/android/binder.c           |    2 +-
 drivers/staging/android/lowmemorykiller.c  |    2 +-
 drivers/staging/android/persistent_ram.c   |  470 ++++++++++++++++++++++++++++
 drivers/staging/android/persistent_ram.h   |   78 +++++
 drivers/staging/android/ram_console.c      |  412 +++++--------------------
 drivers/staging/android/trace_persistent.c |  242 ++++++++++++++
 8 files changed, 888 insertions(+), 392 deletions(-)
 create mode 100644 drivers/staging/android/persistent_ram.c
 create mode 100644 drivers/staging/android/persistent_ram.h
 create mode 100644 drivers/staging/android/trace_persistent.c



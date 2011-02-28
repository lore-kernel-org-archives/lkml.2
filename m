Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab1B1Dik (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 22:38:40 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57985 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab1B1Dij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 22:38:39 -0500
MIME-Version: 1.0
Date: Sun, 27 Feb 2011 21:38:38 -0600
Message-ID: <AANLkTi=rxzrnt0QZQPJFRboSW_Fyt6zQ5S9KD4Lp=hnU@mail.gmail.com>
Subject: [GIT PULL] Generic PWM Device API
From: Bill Gatliff <bgat@billgatliff.com>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-embedded@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, Linus:


The git repository described in the following pull request implements
a generic PWM device driver API.  This API is intended to eventually
supercede the existing PWM device drivers, but during a migration
period will coexist peacefully with them.

This code has been discussed at length on the linux-embedded mailing
list.  Noteworthy threads include:

v6 (final) patches:
   http://www.mail-archive.com/linux-embedded@vger.kernel.org/msg03291.html

v5 patches:
   http://www.mail-archive.com/linux-embedded@vger.kernel.org/msg03279.html

v4 patches:
   http://www.mail-archive.com/linux-embedded@vger.kernel.org/msg03263.html


Thanks!


b.g.
---
Bill Gatliff
bgat@billgatliff.com

--------

The following changes since commit 493f3358cb289ccf716c5a14fa5bb52ab75943e5:

  Merge branch 'pm-fixes' of
git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6
(2011-02-25 15:15:17 -0800)

are available in the git repository at:

  git://git.billgatliff.com/pwm.git linux-next

Bill Gatliff (3):
      PWM: Implement a generic PWM framework
      PWM: GPIO+hrtimer device emulation
      PWM: Atmel PWMC driver

 Documentation/pwm.txt    |  277 +++++++++++++++++++++
 MAINTAINERS              |    8 +
 drivers/Kconfig          |    2 +
 drivers/Makefile         |    2 +
 drivers/pwm/Kconfig      |   29 +++
 drivers/pwm/Makefile     |    7 +
 drivers/pwm/atmel-pwmc.c |  494 +++++++++++++++++++++++++++++++++++++
 drivers/pwm/gpio-pwm.c   |  348 ++++++++++++++++++++++++++
 drivers/pwm/pwm.c        |  610 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pwm/pwm.h  |  155 ++++++++++++
 10 files changed, 1932 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/pwm.txt
 create mode 100644 drivers/pwm/Kconfig
 create mode 100644 drivers/pwm/Makefile
 create mode 100644 drivers/pwm/atmel-pwmc.c
 create mode 100644 drivers/pwm/gpio-pwm.c
 create mode 100644 drivers/pwm/pwm.c
 create mode 100644 include/linux/pwm/pwm.h

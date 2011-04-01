Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751049Ab1DAEAM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 00:00:12 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:38084 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab1DAEAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 00:00:07 -0400
From: Bill Gatliff <bgat@billgatliff.com>
To: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org
Cc: Bill Gatliff <bgat@billgatliff.com>
Subject: [PWM v9 0/3] Implement a generic PWM framework
Date: Thu, 31 Mar 2011 22:59:49 -0500
Message-Id: <1301630392-20793-1-git-send-email-bgat@billgatliff.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series contains the ninth attempt at implementation of a
generic PWM device interface framework.  Think gpiolib, but for
devices and pseudo-devices that generate pulse-wave-modulated outputs.

Compared to the previous version, this patch series:

 * Fixes an unbalanced get_device()/put_device()

A git tree containing these patches may be found here:

    http://git.billgatliff.com/pwm.git


Regards,


b.g.

Bill Gatliff (3):
  PWM: Implement a generic PWM framework
  PWM: GPIO+hrtimer device emulation
  PWM: Atmel PWMC driver

 Documentation/pwm.txt    |  276 ++++++++++++++++++++++
 MAINTAINERS              |    8 +
 drivers/Kconfig          |    2 +
 drivers/Makefile         |    2 +
 drivers/pwm/Kconfig      |   29 +++
 drivers/pwm/Makefile     |    7 +
 drivers/pwm/atmel-pwmc.c |  452 ++++++++++++++++++++++++++++++++++++
 drivers/pwm/gpio-pwm.c   |  332 ++++++++++++++++++++++++++
 drivers/pwm/pwm.c        |  580 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pwm/pwm.h  |  143 ++++++++++++
 10 files changed, 1831 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/pwm.txt
 create mode 100644 drivers/pwm/Kconfig
 create mode 100644 drivers/pwm/Makefile
 create mode 100644 drivers/pwm/atmel-pwmc.c
 create mode 100644 drivers/pwm/gpio-pwm.c
 create mode 100644 drivers/pwm/pwm.c
 create mode 100644 include/linux/pwm/pwm.h

-- 
1.7.4.1


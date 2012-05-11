Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941Ab2EKKi5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 06:38:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55121 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755542Ab2EKKiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 06:38:55 -0400
From: Ravishankar Karkala Mallikarjunayya <ravishankarkm32@gmail.com>
To: gregkh@linuxfoundation.org, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Staging: comedi: Clean up patch series.
Date: Fri, 11 May 2012 16:07:48 +0530
Message-Id: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series fixes some style issues in drivers/staging/comedi/drivers
and fix some issues found by checkpatch.pl script.

Ravishankar Karkala Mallikarjunayya (25):
      Staging: comedi: fix printk issue in usbduxfast.c
      Staging: comedi: fix printk issues in usbduxfast.c
      Staging: comedi: fix printk issue in usbduxfast.c
      Staging: comedi: fix printk issue in usbduxfast.c
      Staging: comedi: fix printk issue in usbduxfast.c
      Staging: comedi: fix printk issue in usbduxfast.c
      Staging: comedi: fix printk issues in usbduxfast.c
      Staging: comedi: fix printk issue in rti800.c
      Staging: comedi: fix printk issue in rti802.c
      Staging: comedi: fix printk issue in s526.c
      Staging: comedi: fix printk issue in s626.c
      Staging: comedi: Checkpatch cleanups.
      Staging: comedi: Checkpatch cleanups.
      Staging: comedi: fix printk issue in serial2002.c
      Staging: comedi: fix printk issue in unioxx5.c
      Staging: comedi: fix printk issues in unioxx5.c
      Staging: comedi: fix line over 80 character issue in unioxx5.c
      Staging: comedi: Checkpatch cleanups.
      Staging: comedi: Checkpatch cleanups.
      Staging: comedi: Checkpatch cleanups.
      Staging: comedi: fix printk issue in pcmmio.c.
      Staging: comedi: fix printk issue in pcmad.c
      Staging: comedi: fix printk issue in poc.c
      Staging: comedi: fix printk issue in ni_pcimio.c
      Staging: comedi: fix printk issue in ni_660x.c

 drivers/staging/comedi/drivers/das6402.c     |    2 +-
 drivers/staging/comedi/drivers/ni_660x.c     |   12 +-
 drivers/staging/comedi/drivers/ni_pcimio.c   |   16 +-
 drivers/staging/comedi/drivers/pcmad.c       |    7 +-
 drivers/staging/comedi/drivers/pcmmio.c      |   34 +-
 drivers/staging/comedi/drivers/poc.c         |   13 +-
 drivers/staging/comedi/drivers/rti800.c      |   26 +-
 drivers/staging/comedi/drivers/rti802.c      |    6 +-
 drivers/staging/comedi/drivers/s526.c        |   50 +-
 drivers/staging/comedi/drivers/s626.c        |   18 +-
 drivers/staging/comedi/drivers/serial2002.c  |    4 +-
 drivers/staging/comedi/drivers/unioxx5.c     |   53 +-
 drivers/staging/comedi/drivers/usbdux.c      |  107 +-
 drivers/staging/comedi/drivers/usbduxfast.c  |  257 +-
 drivers/staging/comedi/drivers/usbduxsigma.c |  102 +-
 localversion-next                            |    1 -
 20 files changed, 332 insertions(+), 9546 deletions(-)
---
 



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932553Ab2KXA1L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 19:27:11 -0500
Received: from smtp-02.mandic.com.br ([200.225.81.133]:51614 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932347Ab2KXA1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 19:27:06 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-kernel@vger.kernel.org
Cc: Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: [PATCH 00/24] MAINTAINERS: fix file patterns
Date: Fri, 23 Nov 2012 22:26:24 -0200
Message-Id: <1353716808-16375-1-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series attempts to fix F: patterns on the MAINTAINERS file
which point to non-existing files or directories.

Patch 7 also attempts to add matching uapi/ patterns to all include
directory patterns, if applicable.

Cesar Eduardo Barros (24):
  MAINTAINERS: remove drivers/platform/msm/
  MAINTAINERS: remove arch/arm/common/time-acorn.c
  MAINTAINERS: remove arch/arm/plat-s5p/
  MAINTAINERS: fix drivers/rtc/rtc-vt8500.c
  MAINTAINERS: fix arch/arm/mach-at91/include/mach/at_hdmac.h
  MAINTAINERS: fix drivers/media/platform/atmel-isi.c
  MAINTAINERS: adjust for UAPI
  MAINTAINERS: fix drivers/media/usb/dvb-usb/cxusb*
  MAINTAINERS: remove drivers/video/epson1355fb.c
  MAINTAINERS: remove include/linux/ext3*
  MAINTAINERS: fix .../plat-mxc/include/mach/imxfb.h
  MAINTAINERS: remove drivers/staging/hv/
  MAINTAINERS: fix drivers/i2c/busses/i2c-stub.c
  MAINTAINERS: fix drivers/ieee802154/
  MAINTAINERS: remove firmware/isci/
  MAINTAINERS: remove arch/x86/platform/mrst/pmu.*
  MAINTAINERS: fix Documentation/mei/
  MAINTAINERS: remove drivers/mmc/host/imxmmc.*
  MAINTAINERS: remove arch/*/lib/perf_event*.c
  MAINTAINERS: remove include/linux/of_pwm.h
  MAINTAINERS: fix drivers/rtc/rtc-sec.c
  MAINTAINERS: fix BAST
  MAINTAINERS: fix drivers/staging/sm7xx/
  MAINTAINERS: remove drivers/block/ub.c

 MAINTAINERS | 222 ++++++++++++++++++++++++++++++++++++------------------------
 1 file changed, 132 insertions(+), 90 deletions(-)

-- 
1.7.11.7


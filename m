Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812Ab2LKVuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 16:50:21 -0500
Received: from smtp-02.mandic.com.br ([200.225.81.133]:57794 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab2LKVuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 16:50:16 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: [PATCH 00/19] MAINTAINERS: fix file patterns
Date: Tue, 11 Dec 2012 19:49:42 -0200
Message-Id: <1355262601-4263-1-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.11.7
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I could not find the maintainer for the MAINTAINERS file, so sending
directly to Linus. Sorry if I am mistaken.

This patch series attempts to fix F: patterns on the MAINTAINERS file
which point to non-existing files or directories.

Patch 7 also attempts to add matching uapi/ patterns to all include
directory patterns, if applicable.

The only changes since my previous posting of this patch series to
linux-kernel are: removed one NAKed patch, removed patches which are
going in via their respective subsystem trees, and added all the ACKs I
received for these patches.

Cesar Eduardo Barros (19):
  MAINTAINERS: remove drivers/platform/msm/
  MAINTAINERS: remove arch/arm/common/time-acorn.c
  MAINTAINERS: remove arch/arm/plat-s5p/
  MAINTAINERS: fix drivers/rtc/rtc-vt8500.c
  MAINTAINERS: fix arch/arm/mach-at91/include/mach/at_hdmac.h
  MAINTAINERS: fix drivers/media/platform/atmel-isi.c
  MAINTAINERS: adjust for UAPI
  MAINTAINERS: fix drivers/media/usb/dvb-usb/cxusb*
  MAINTAINERS: remove drivers/video/epson1355fb.c
  MAINTAINERS: fix .../plat-mxc/include/mach/imxfb.h
  MAINTAINERS: fix drivers/ieee802154/
  MAINTAINERS: remove firmware/isci/
  MAINTAINERS: remove arch/x86/platform/mrst/pmu.*
  MAINTAINERS: fix Documentation/mei/
  MAINTAINERS: remove drivers/mmc/host/imxmmc.*
  MAINTAINERS: remove arch/*/lib/perf_event*.c
  MAINTAINERS: remove include/linux/of_pwm.h
  MAINTAINERS: fix BAST
  MAINTAINERS: fix drivers/staging/sm7xx/

 MAINTAINERS | 209 +++++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 130 insertions(+), 79 deletions(-)

-- 
1.7.11.7


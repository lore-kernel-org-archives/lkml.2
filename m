Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378Ab2GQXZE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 19:25:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47370 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757307Ab2GQXY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 19:24:58 -0400
Date: Tue, 17 Jul 2012 16:24:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/23] 3.0.38-stable review
Message-ID: <20120717232455.GA5994@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.38 release.
There are 23 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Jul 19 23:23:28 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.38-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
 Makefile                                |    4 +-
 arch/arm/plat-samsung/adc.c             |    8 +-
 drivers/hwmon/it87.c                    |    2 +-
 drivers/input/joystick/xpad.c           |    1 +
 drivers/media/dvb/dvb-core/dvbdev.c     |    1 +
 drivers/mtd/nand/nandsim.c              |   12 +--
 drivers/net/e1000e/82571.c              |    3 +
 drivers/net/wireless/rt2x00/rt2x00usb.c |    2 +-
 drivers/platform/x86/intel_ips.c        |   22 ++++++
 fs/buffer.c                             |   22 +++---
 fs/fifo.c                               |    9 +--
 include/linux/hrtimer.h                 |   10 ++-
 include/linux/timex.h                   |    2 +-
 kernel/hrtimer.c                        |   53 +++++++++----
 kernel/time/ntp.c                       |  124 ++++++++++---------------------
 kernel/time/timekeeping.c               |  115 +++++++++++++++++++++-------
 net/ipv4/tcp_input.c                    |    2 +
 net/wireless/util.c                     |    2 +-
 18 files changed, 234 insertions(+), 160 deletions(-)


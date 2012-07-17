Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294Ab2GQXYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 19:24:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46887 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab2GQXYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 19:24:52 -0400
Date: Tue, 17 Jul 2012 16:24:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/37] 3.4.6-stable review
Message-ID: <20120717232448.GA5964@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.6 release.
There are 37 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Jul 19 23:24:29 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.6-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
 Makefile                                          |    4 +-
 arch/arm/plat-samsung/adc.c                       |    8 +-
 drivers/acpi/acpica/nspredef.c                    |    2 +-
 drivers/acpi/processor_core.c                     |    6 +-
 drivers/clk/clk.c                                 |    9 +-
 drivers/hid/hid-apple.c                           |    6 +
 drivers/hid/hid-core.c                            |    7 +
 drivers/hid/hid-ids.h                             |    6 +
 drivers/hwmon/it87.c                              |    2 +-
 drivers/input/joystick/xpad.c                     |    6 +-
 drivers/input/mouse/bcm5974.c                     |   20 ++
 drivers/md/raid1.c                                |    3 +-
 drivers/media/dvb/dvb-core/dvbdev.c               |    1 +
 drivers/media/video/cx231xx/cx231xx-audio.c       |    4 +-
 drivers/media/video/cx231xx/cx231xx-vbi.c         |    2 +-
 drivers/mtd/nand/nandsim.c                        |   12 +-
 drivers/net/bonding/bond_debugfs.c                |    2 +-
 drivers/net/bonding/bond_main.c                   |    9 +-
 drivers/net/ethernet/intel/e1000e/82571.c         |    3 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    3 +
 drivers/net/wireless/iwlegacy/4965-mac.c          |    4 +-
 drivers/net/wireless/iwlegacy/common.c            |   14 +-
 drivers/net/wireless/rt2x00/rt2x00usb.c           |    2 +-
 drivers/platform/x86/intel_ips.c                  |   22 ++
 drivers/rpmsg/virtio_rpmsg_bus.c                  |    2 +-
 fs/buffer.c                                       |   22 +-
 fs/fifo.c                                         |    9 +-
 fs/locks.c                                        |    2 +-
 include/linux/Kbuild                              |    1 +
 include/linux/hrtimer.h                           |   10 +-
 include/linux/sched.h                             |    8 +
 kernel/hrtimer.c                                  |   53 ++--
 kernel/sched/core.c                               |  275 +++++++++++++++------
 kernel/sched/idle_task.c                          |    1 -
 kernel/sched/sched.h                              |    2 -
 kernel/time/tick-sched.c                          |    2 +
 kernel/time/timekeeping.c                         |   64 ++++-
 net/mac80211/mlme.c                               |    6 +-
 net/wireless/util.c                               |    2 +-
 39 files changed, 460 insertions(+), 156 deletions(-)


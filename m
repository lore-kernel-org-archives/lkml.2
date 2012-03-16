Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946278Ab2CPXvx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:51:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39045 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965541Ab2CPXjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:39:37 -0400
Date: Fri, 16 Mar 2012 16:38:29 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/41] 3.2.12-stable review
Message-ID: <20120316233829.GA14022@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.12 release.
There are 41 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Mar 18 23:00:00 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.2.12-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
 Documentation/hwmon/w83627ehf                   |    2 +-
 Documentation/hwmon/zl6100                      |   14 ++---
 Makefile                                        |    4 +-
 arch/sparc/Makefile                             |    2 +-
 arch/x86/kernel/cpu/perf_event_intel.c          |   17 +++---
 arch/x86/lib/delay.c                            |    4 +-
 block/genhd.c                                   |   42 ++++++++------
 drivers/block/sx8.c                             |    2 +-
 drivers/hwmon/pmbus/zl6100.c                    |   11 +---
 drivers/hwmon/w83627ehf.c                       |   17 +++---
 drivers/i2c/algos/i2c-algo-bit.c                |    8 ++-
 drivers/media/video/omap3isp/ispccdc.c          |    3 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c |    4 --
 drivers/net/ethernet/packetengines/Kconfig      |    1 +
 drivers/net/ethernet/realtek/r8169.c            |    8 +++
 drivers/net/ethernet/sfc/rx.c                   |    4 +-
 drivers/net/ppp/ppp_generic.c                   |   23 ++++++++
 drivers/net/usb/asix.c                          |    4 ++
 drivers/net/vmxnet3/vmxnet3_drv.c               |    7 +--
 drivers/net/vmxnet3/vmxnet3_int.h               |    4 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c         |    6 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c         |    9 +++
 drivers/net/wireless/rt2x00/rt2x00queue.c       |    3 +
 drivers/pci/pcie/aspm.c                         |    3 +
 drivers/platform/x86/acer-wmi.c                 |   30 +++++++++-
 drivers/rapidio/devices/tsi721.h                |   30 +++++-----
 drivers/regulator/tps6524x-regulator.c          |    2 +-
 drivers/target/iscsi/iscsi_target.c             |    2 +-
 drivers/target/target_core_pr.c                 |   34 +++++++----
 drivers/target/target_core_transport.c          |    1 +
 fs/aio.c                                        |   22 ++++----
 fs/block_dev.c                                  |   16 ++++--
 fs/cifs/file.c                                  |   69 ++++++++++++++++++-----
 fs/namei.c                                      |    4 +-
 fs/partitions/check.c                           |   48 +++++++++++++---
 include/linux/genhd.h                           |    1 +
 include/linux/skbuff.h                          |   10 ++++
 include/linux/workqueue.h                       |    4 ++
 kernel/workqueue.c                              |    7 ++-
 net/bridge/br_multicast.c                       |    7 ++-
 net/core/neighbour.c                            |    2 +
 net/ipv4/tcp_input.c                            |   23 +++++---
 net/ipv4/xfrm4_mode_beet.c                      |    5 +-
 net/ipv4/xfrm4_mode_tunnel.c                    |    6 +-
 net/ipv6/addrconf.c                             |    4 ++
 net/ipv6/xfrm6_mode_beet.c                      |    6 +-
 net/ipv6/xfrm6_mode_tunnel.c                    |    6 +-
 sound/pci/hda/patch_realtek.c                   |    8 +++
 sound/soc/samsung/neo1973_wm8753.c              |    4 +-
 49 files changed, 378 insertions(+), 175 deletions(-)


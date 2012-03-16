Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945985Ab2CPXea (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:34:30 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41442 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945904Ab2CPXe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:34:27 -0400
Date: Fri, 16 Mar 2012 16:34:22 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/38] 3.0.25-stable review
Message-ID: <20120316233422.GA5461@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.25 release.
There are 38 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Mar 18 23:00:00 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.25-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
 Makefile                                  |    4 +-
 arch/s390/kernel/setup.c                  |    1 +
 arch/sparc/Makefile                       |    2 +-
 arch/x86/lib/delay.c                      |    4 +-
 block/genhd.c                             |   42 +++++-----
 drivers/base/core.c                       |    6 +-
 drivers/block/sx8.c                       |    2 +-
 drivers/firewire/core-cdev.c              |   24 +++++-
 drivers/firewire/core-device.c            |   15 ++--
 drivers/hwmon/w83627ehf.c                 |    9 +--
 drivers/i2c/algos/i2c-algo-bit.c          |    8 +-
 drivers/net/atl1c/atl1c_main.c            |    4 -
 drivers/net/ppp_generic.c                 |   23 ++++++
 drivers/net/sfc/rx.c                      |    4 +-
 drivers/net/usb/asix.c                    |    4 +
 drivers/net/vmxnet3/vmxnet3_drv.c         |    7 +-
 drivers/net/vmxnet3/vmxnet3_int.h         |    4 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c   |    6 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c   |    9 +++
 drivers/net/wireless/rt2x00/rt2x00queue.c |    3 +
 drivers/pci/pcie/aspm.c                   |    3 +
 drivers/platform/x86/acer-wmi.c           |  121 ++++++++++++++++++++++++-----
 drivers/regulator/tps6524x-regulator.c    |    2 +-
 drivers/s390/char/fs3270.c                |    1 +
 fs/aio.c                                  |   22 +++---
 fs/block_dev.c                            |   16 +++-
 fs/namei.c                                |    4 +-
 fs/partitions/check.c                     |   48 ++++++++++--
 include/linux/genhd.h                     |    1 +
 include/linux/skbuff.h                    |   10 +++
 include/linux/workqueue.h                 |    4 +
 kernel/workqueue.c                        |    7 +-
 net/bridge/br_multicast.c                 |    7 +-
 net/core/neighbour.c                      |    2 +
 net/ipv4/tcp_input.c                      |   23 ++++--
 net/ipv4/xfrm4_mode_beet.c                |    5 +-
 net/ipv4/xfrm4_mode_tunnel.c              |    6 +-
 net/ipv6/addrconf.c                       |    4 +
 net/ipv6/xfrm6_mode_beet.c                |    6 +-
 net/ipv6/xfrm6_mode_tunnel.c              |    6 +-
 sound/soc/samsung/neo1973_wm8753.c        |    4 +-
 41 files changed, 351 insertions(+), 132 deletions(-)


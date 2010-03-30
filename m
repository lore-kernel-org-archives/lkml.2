Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab0C3XG7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:06:59 -0400
Received: from kroah.org ([198.145.64.141]:51714 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653Ab0C3XGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:06:09 -0400
Date: Tue, 30 Mar 2010 16:04:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/45] 2.6.27.46-stable review
Message-ID: <20100330230410.GA28712@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100330230338.GA28642@kroah.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.27.46 release.
There are 45 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by April 1, 2010, 22:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.46-rc1.gz
and the diffstat can be found below.


thanks,

greg k-h


 Documentation/filesystems/tmpfs.txt     |    6 +++-
 Makefile                                |    2 +-
 arch/x86/ia32/ia32_aout.c               |    1 -
 arch/x86/kvm/vmx.c                      |    3 ++
 arch/x86/kvm/x86.c                      |   21 ++++++++++-
 arch/x86/kvm/x86_emulate.c              |    5 ++-
 drivers/char/mem.c                      |    3 ++
 drivers/char/tty_io.c                   |    4 ++-
 drivers/gpu/drm/r128/r128_cce.c         |   18 +++++++--
 drivers/gpu/drm/r128/r128_drv.h         |    8 ++++
 drivers/gpu/drm/r128/r128_state.c       |   36 ++++++++++---------
 drivers/hwmon/coretemp.c                |    2 +-
 drivers/hwmon/lm78.c                    |   23 ++++++++----
 drivers/i2c/i2c-core.c                  |    5 ++-
 drivers/media/video/em28xx/em28xx-dvb.c |    1 +
 drivers/mtd/ubi/cdev.c                  |    1 -
 drivers/net/b44.c                       |    3 +-
 drivers/net/bonding/bond_main.c         |    8 ++++
 drivers/net/r8169.c                     |    4 +-
 drivers/net/sky2.c                      |    4 ++-
 drivers/parisc/eisa_eeprom.c            |    2 +-
 drivers/serial/8250.c                   |    7 ++--
 drivers/usb/core/devio.c                |   61 +++++++++++++++++++++----------
 drivers/usb/host/ehci-hub.c             |    7 ++--
 drivers/usb/host/ehci-q.c               |   11 +++---
 drivers/usb/host/ehci-sched.c           |    1 +
 fs/exec.c                               |    3 +-
 fs/ext4/super.c                         |    3 +-
 fs/fcntl.c                              |    6 +--
 fs/namei.c                              |   14 ++++++-
 include/asm-x86/checksum_32.h           |    3 +-
 include/asm-x86/kvm_host.h              |    1 +
 include/asm-x86/kvm_x86_emulate.h       |    2 +-
 include/linux/sched.h                   |   24 ++++++++++++-
 include/linux/topology.h                |    4 +-
 kernel/futex.c                          |   28 +++++++++++++-
 kernel/printk.c                         |    2 +-
 kernel/sched.c                          |   12 +++---
 kernel/sched_fair.c                     |   13 +++++--
 kernel/sched_features.h                 |    1 +
 kernel/sched_idletask.c                 |    6 ++--
 kernel/sched_rt.c                       |    2 +-
 mm/mempolicy.c                          |   34 +++++++++++------
 mm/migrate.c                            |    3 ++
 net/ax25/af_ax25.c                      |    2 +-
 net/ipv4/tcp_minisocks.c                |    2 +-
 net/ipv6/sit.c                          |    2 +-
 net/sched/sch_api.c                     |    2 +
 net/unix/af_unix.c                      |    5 ++-
 49 files changed, 301 insertions(+), 120 deletions(-)

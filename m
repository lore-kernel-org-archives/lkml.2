Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760395Ab2BJWgv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:36:51 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62978 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760368Ab2BJWgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:36:49 -0500
Date: Fri, 10 Feb 2012 14:35:00 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [patch 00/55] 3.0.21-stable review
Message-ID: <20120210223500.GA24178@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

#include <stable/formletter.h>
#define RELEASE         3.0.21-rc1
#define NUM_PATCHES     55
#define RESPONSE_DATE   "Mon Feb 13 22:00:00 UTC 2012"
#define LOCATION        kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.21-rc1.gz

diffstat below.

greg k-h


 Makefile                                       |    4 +-
 arch/arm/kernel/ptrace.c                       |    8 +-
 arch/arm/kernel/signal.c                       |    5 +-
 arch/arm/mach-omap2/gpmc.c                     |    6 +
 drivers/cpufreq/powernow-k8.c                  |   30 ++++--
 drivers/dma/at_hdmac.c                         |    4 +-
 drivers/dma/at_hdmac_regs.h                    |   17 ++--
 drivers/firewire/ohci.c                        |    6 +-
 drivers/gpu/drm/i915/i915_drv.h                |    2 +
 drivers/gpu/drm/i915/i915_irq.c                |   13 ++-
 drivers/gpu/drm/i915/i915_suspend.c            |    4 +
 drivers/gpu/drm/i915/intel_dp.c                |    1 +
 drivers/gpu/drm/i915/intel_hdmi.c              |    8 +-
 drivers/gpu/drm/i915/intel_tv.c                |   16 ++--
 drivers/gpu/drm/nouveau/nouveau_gem.c          |   23 ++++-
 drivers/gpu/drm/radeon/atombios_crtc.c         |    4 +-
 drivers/gpu/drm/radeon/radeon_device.c         |    4 +
 drivers/hwmon/w83627ehf.c                      |   26 ++++-
 drivers/infiniband/core/addr.c                 |   16 ++-
 drivers/infiniband/hw/cxgb3/iwch_cm.c          |   16 ++-
 drivers/infiniband/hw/cxgb4/cm.c               |   46 +++++----
 drivers/infiniband/hw/mlx4/mad.c               |    7 +-
 drivers/infiniband/hw/mlx4/qp.c                |    2 +-
 drivers/infiniband/hw/nes/nes_cm.c             |    8 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |   59 +++++++----
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |   24 +++--
 drivers/misc/cb710/core.c                      |    1 +
 drivers/net/cxgb3/cxgb3_offload.c              |    8 +-
 drivers/pcmcia/ds.c                            |    4 +-
 drivers/s390/net/qeth_l3_main.c                |   25 ++++--
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c             |    2 +-
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c             |    2 +-
 drivers/scsi/cxgbi/libcxgbi.c                  |    4 +-
 drivers/staging/asus_oled/asus_oled.c          |   13 ++-
 drivers/staging/rtl8712/usb_intf.c             |    1 +
 drivers/target/target_core_pr.c                |    5 +-
 drivers/target/target_core_transport.c         |    8 +-
 drivers/tty/vt/vt_ioctl.c                      |    1 -
 drivers/usb/gadget/f_loopback.c                |    2 +-
 drivers/usb/host/pci-quirks.c                  |    6 +
 drivers/usb/serial/ftdi_sio.c                  |    1 +
 drivers/usb/serial/ftdi_sio_ids.h              |    7 ++
 drivers/usb/serial/option.c                    |  129 +++++++++++++++++++++++-
 drivers/video/atmel_lcdfb.c                    |    2 +-
 fs/cifs/sess.c                                 |    7 +-
 fs/ecryptfs/read_write.c                       |    4 +-
 fs/proc/base.c                                 |  106 +++++++++-----------
 fs/udf/super.c                                 |    6 +
 include/net/arp.h                              |    1 +
 include/net/dst.h                              |   27 +++++-
 kernel/kprobes.c                               |    6 +-
 kernel/panic.c                                 |   12 ++-
 kernel/sched_rt.c                              |    5 +
 mm/compaction.c                                |   24 ++++-
 mm/filemap.c                                   |    8 +-
 mm/filemap_xip.c                               |    7 +-
 mm/huge_memory.c                               |    4 +-
 mm/swap.c                                      |    2 +-
 net/atm/clip.c                                 |   16 ++-
 net/bridge/br_netfilter.c                      |    6 +-
 net/core/dst.c                                 |   15 ++-
 net/core/neighbour.c                           |   19 ++--
 net/decnet/dn_neigh.c                          |    8 +-
 net/decnet/dn_route.c                          |   18 ++--
 net/ipv4/arp.c                                 |   28 +++--
 net/ipv4/ip_gre.c                              |    2 +-
 net/ipv4/ip_output.c                           |   22 ++++-
 net/ipv4/route.c                               |   31 ++++--
 net/ipv6/addrconf.c                            |    2 +-
 net/ipv6/ip6_fib.c                             |    2 +-
 net/ipv6/ip6_output.c                          |   40 ++++++--
 net/ipv6/ndisc.c                               |    4 +-
 net/ipv6/route.c                               |   59 +++++++----
 net/ipv6/sit.c                                 |    4 +-
 net/sched/sch_teql.c                           |   31 ++++--
 net/xfrm/xfrm_policy.c                         |    2 +-
 sound/pci/hda/hda_codec.c                      |    2 +-
 sound/soc/codecs/wm8962.c                      |    6 +-
 sound/soc/codecs/wm_hubs.c                     |   18 ++-
 sound/soc/soc-core.c                           |   18 +++-
 80 files changed, 798 insertions(+), 354 deletions(-)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab1CJX4y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 18:56:54 -0500
Received: from kroah.org ([198.145.64.141]:45154 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754181Ab1CJX4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 18:56:53 -0500
Date: Thu, 10 Mar 2011 15:55:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 00/29] 2.6.37.4-stable review
Message-ID: <20110310235548.GA10103@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.37.r release.
There are 29 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Saturday, March 12, 24:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.37.4-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Makefile                                    |    2 +-
 arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c   |    2 +-
 drivers/char/virtio_console.c               |    8 ++++
 drivers/hid/hid-mosart.c                    |    4 ++
 drivers/media/dvb/dvb-usb/dib0700_devices.c |   21 +++++++++-
 drivers/media/dvb/frontends/dib7000m.c      |   19 +++++++++
 drivers/media/dvb/frontends/dib7000m.h      |   15 +++++++
 drivers/media/video/cx23885/cx23885-i2c.c   |    8 ----
 drivers/media/video/cx25840/cx25840-core.c  |    3 +-
 drivers/media/video/ivtv/ivtv-irq.c         |   58 +++++++++++++++++++++++---
 drivers/misc/bmp085.c                       |    1 +
 drivers/net/forcedeth.c                     |    2 +
 drivers/net/ixgbe/ixgbe_main.c              |    4 ++
 drivers/net/r8169.c                         |   42 +++++++++++++++----
 drivers/net/wireless/ath/ath9k/ath9k.h      |    3 -
 drivers/net/wireless/ath/ath9k/init.c       |    4 --
 drivers/net/wireless/ath/ath9k/main.c       |    4 --
 drivers/s390/char/keyboard.c                |    3 +-
 fs/nfs/nfs4proc.c                           |   44 +++++++++++++++++++-
 fs/nfs/nfs4xdr.c                            |    3 -
 fs/nfsd/nfs4xdr.c                           |    4 +-
 include/keys/rxrpc-type.h                   |    1 -
 include/linux/netdevice.h                   |    3 +
 kernel/cpuset.c                             |    7 ++-
 kernel/sched_rt.c                           |   14 ++++--
 mm/mremap.c                                 |    4 +-
 net/core/dev.c                              |   12 +++++-
 net/ipv4/ip_gre.c                           |    1 +
 net/ipv4/ipip.c                             |    1 +
 net/ipv4/netfilter/arpt_mangle.c            |    6 +-
 net/ipv6/sit.c                              |    2 +-
 net/netfilter/ipvs/ip_vs_ctl.c              |    4 +-
 net/netfilter/nf_log.c                      |    4 ++
 sound/pci/hda/patch_cirrus.c                |    2 +
 sound/pci/hda/patch_realtek.c               |    7 +--
 sound/soc/codecs/wm9081.c                   |    5 ++
 36 files changed, 255 insertions(+), 72 deletions(-)

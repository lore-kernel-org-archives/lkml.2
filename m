Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309Ab1CNVl1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 17:41:27 -0400
Received: from kroah.org ([198.145.64.141]:46541 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756584Ab1CNVl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 17:41:26 -0400
Date: Mon, 14 Mar 2011 14:28:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.37.4
Message-ID: <20110314212852.GA9082@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.37.4 kernel.

All users of the 2.6.37 kernel series must upgrade.

The updated 2.6.37.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.37.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.37.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                    |    2 
 arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c   |    2 
 drivers/char/virtio_console.c               |    8 +++
 drivers/hid/hid-mosart.c                    |    4 +
 drivers/media/dvb/dvb-usb/dib0700_devices.c |   21 +++++++++-
 drivers/media/dvb/frontends/dib7000m.c      |   19 +++++++++
 drivers/media/dvb/frontends/dib7000m.h      |   15 +++++++
 drivers/media/video/cx23885/cx23885-i2c.c   |    8 ---
 drivers/media/video/cx25840/cx25840-core.c  |    3 -
 drivers/media/video/ivtv/ivtv-irq.c         |   58 ++++++++++++++++++++++++----
 drivers/misc/bmp085.c                       |    1 
 drivers/net/forcedeth.c                     |    2 
 drivers/net/ixgbe/ixgbe_main.c              |    4 +
 drivers/net/r8169.c                         |   42 +++++++++++++++-----
 drivers/net/wireless/ath/ath9k/ath9k.h      |    3 -
 drivers/net/wireless/ath/ath9k/init.c       |    4 -
 drivers/net/wireless/ath/ath9k/main.c       |    4 -
 drivers/s390/char/keyboard.c                |    3 -
 fs/nfs/nfs4proc.c                           |   44 ++++++++++++++++++++-
 fs/nfs/nfs4xdr.c                            |    3 -
 fs/nfsd/nfs4xdr.c                           |    4 -
 include/keys/rxrpc-type.h                   |    1 
 include/linux/netdevice.h                   |    3 +
 kernel/cpuset.c                             |    7 ++-
 kernel/sched_rt.c                           |   14 ++++--
 mm/mremap.c                                 |    4 -
 net/core/dev.c                              |   12 ++++-
 net/ipv4/ip_gre.c                           |    1 
 net/ipv4/ipip.c                             |    1 
 net/ipv4/netfilter/arpt_mangle.c            |    6 +-
 net/ipv6/ip6_tunnel.c                       |    1 
 net/ipv6/sit.c                              |    2 
 net/netfilter/ipvs/ip_vs_ctl.c              |    4 -
 net/netfilter/nf_log.c                      |    4 +
 sound/pci/hda/patch_cirrus.c                |    2 
 sound/pci/hda/patch_realtek.c               |    7 ---
 sound/soc/codecs/wm9081.c                   |    5 ++
 37 files changed, 256 insertions(+), 72 deletions(-)

Amit Shah (1):
      virtio: console: Don't access vqs if device was unplugged

Andy Walls (1):
      cx23885: Revert "Check for slave nack on all transactions"

Anton Blanchard (1):
      RxRPC: Fix v1 keys

Axel Lin (1):
      drivers/misc/bmp085.c: add MODULE_DEVICE_TABLE

Balbir Singh (1):
      sched: Fix sched rt group scheduling when hierachy is enabled

Benjamin Tissoires (1):
      HID: hid-mosart: ignore buttons report

Chuck Lever (1):
      NFS: NFSv4 readdir loses entries

Dan Carpenter (1):
      keyboard: integer underflow bug

David Henningsson (1):
      ALSA: HDA: Realtek: Fixup jack detection to input subsystem

Don Skidmore (1):
      ixgbe: fix for 82599 erratum on Header Splitting

Francois Romieu (2):
      r8169: RxFIFO overflow oddities with 8168 chipsets.
      r8169: prevent RxFIFO induced loops in the irq handler.

Greg Kroah-Hartman (1):
      Linux 2.6.37.4

Hugh Dickins (1):
      mm: fix possible cause of a page_mapped BUG

Ivan Vecera (2):
      r8169: use RxFIFO overflow workaround for 8168c chipset.
      drivers/net: Call netif_carrier_off at the end of the probe

Jan Engelhardt (1):
      netfilter: nf_log: avoid oops in (un)bind with invalid nfproto values

Julian Anastasov (1):
      ipvs: fix dst_lock locking on dest update

Li Zefan (1):
      cpuset: add a missing unlock in cpuset_write_resmask()

Mark Brown (1):
      ASoC: Fix WM9081 platform data initialisation

Michael (1):
      ivtv: Fix corrective action taken upon DMA ERR interrupt to avoid hang

Mohammed Shafi Shajakhan (1):
      ath9k: Fix ath9k prevents CPU to enter C3 states

Naga Chumbalkar (1):
      pcc-cpufreq: don't load driver if get_freq fails during init.

Neil Horman (1):
      nfs4: Ensure that ACL pages sent over NFS were not allocated from the slab (v3)

Olivier Grenie (1):
      DiB7000M: add pid filtering

Pablo Neira Ayuso (1):
      netfilter: arpt_mangle: fix return values of checkentry

Sven Barth (1):
      cx25840: fix probing of cx2583x chips

Takashi Iwai (1):
      ALSA: hda - Don't set to D3 in Cirrus errata init verbs

Vasiliy Kulikov (1):
      net: don't allow CAP_NET_ADMIN to load non-netdev kernel modules

roel (1):
      nfsd: wrong index used in inner loop

stephen hemminger (1):
      ip6ip6: autoload ip6 tunnel


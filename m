Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125Ab2FGES0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:18:26 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63657 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932364Ab2FGESV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:18:21 -0400
Date: Thu, 7 Jun 2012 13:15:04 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/47] 3.0.34-stable review
Message-ID: <20120607041504.GA13819@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.34 release.
There are 48 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat Jun  9 04:13:55 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.34-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
 Makefile                                  |  4 +-
 arch/parisc/kernel/entry.S                | 30 ++++++++------
 arch/parisc/kernel/vmlinux.lds.S          |  6 ++-
 arch/x86/include/asm/pgtable-3level.h     | 50 +++++++++++++++++++++++
 drivers/acpi/battery.c                    | 10 ++++-
 drivers/atm/solos-pci.c                   |  4 +-
 drivers/bluetooth/ath3k.c                 |  6 +++
 drivers/bluetooth/btusb.c                 | 16 +++++++-
 drivers/gpu/drm/i915/intel_sdvo.c         | 12 ++++--
 drivers/gpu/drm/i915/intel_sdvo_regs.h    |  5 +++
 drivers/gpu/drm/i915/intel_tv.c           |  5 +++
 drivers/gpu/drm/radeon/evergreen.c        |  9 +++-
 drivers/gpu/drm/radeon/evergreend.h       |  1 +
 drivers/gpu/drm/radeon/radeon_atombios.c  |  4 +-
 drivers/gpu/drm/radeon/rv770.c            |  2 +
 drivers/gpu/drm/radeon/rv770d.h           |  1 +
 drivers/gpu/drm/ttm/ttm_bo.c              |  1 +
 drivers/mtd/nand/nand_bbt.c               |  1 +
 drivers/net/macvlan.c                     |  2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |  1 +
 drivers/net/wireless/wl1251/sdio.c        |  2 +-
 drivers/net/wireless/wl1251/spi.c         |  3 +-
 drivers/scsi/scsi_lib.c                   | 11 +++--
 drivers/scsi/scsi_wait_scan.c             |  2 +-
 fs/cifs/cifsglob.h                        |  1 +
 fs/cifs/file.c                            | 57 +++++++++++++++-----------
 fs/ext4/ioctl.c                           | 12 ++++--
 fs/ext4/mballoc.c                         |  6 ++-
 fs/ext4/super.c                           |  4 +-
 fs/namespace.c                            |  3 +-
 fs/nfs/nfs4proc.c                         |  2 +
 include/asm-generic/pgtable.h             | 22 +++++++++-
 include/drm/drm_pciids.h                  |  2 +
 include/linux/netdevice.h                 |  9 ----
 include/linux/skbuff.h                    |  2 -
 include/net/dst.h                         |  1 +
 include/net/sctp/sctp.h                   | 13 ++++++
 mm/vmscan.c                               |  2 +-
 net/8021q/vlan_dev.c                      |  2 +-
 net/core/dev.c                            | 36 +++-------------
 net/core/pktgen.c                         | 10 ++++-
 net/ipv4/esp4.c                           | 24 ++++-------
 net/ipv4/fib_semantics.c                  | 20 +++++----
 net/ipv4/fib_trie.c                       |  2 +
 net/ipv6/esp6.c                           | 18 ++++----
 net/ipv6/ip6_output.c                     | 68 +++++++++++++++++++++++--------
 net/l2tp/l2tp_ip.c                        | 30 +++++++++++---
 net/mac80211/util.c                       | 12 +++---
 net/sctp/output.c                         |  4 +-
 net/sctp/transport.c                      | 17 --------
 net/xfrm/xfrm_policy.c                    |  3 ++
 sound/usb/pcm.c                           |  3 ++
 52 files changed, 375 insertions(+), 198 deletions(-)


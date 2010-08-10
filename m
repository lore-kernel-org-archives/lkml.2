Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932636Ab0HJSts (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 14:49:48 -0400
Received: from kroah.org ([198.145.64.141]:55459 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932585Ab0HJStR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 14:49:17 -0400
Date: Tue, 10 Aug 2010 11:47:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.34.3
Message-ID: <20100810184741.GE10346@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.34.3 kernel.

All users of the 2.6.34 kernel series should upgrade.

The updated 2.6.34.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.34.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.34.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/.gitignore                    |    7 ++
 Makefile                                    |    2 
 arch/arm/plat-mxc/gpio.c                    |    8 +++
 arch/arm/plat-mxc/include/mach/gpio.h       |    1 
 arch/parisc/kernel/firmware.c               |   12 ----
 arch/x86/.gitignore                         |    3 +
 arch/x86/kvm/mmu.c                          |    2 
 arch/x86/xen/enlighten.c                    |    2 
 arch/x86/xen/time.c                         |   39 ----------------
 drivers/edac/amd64_edac.c                   |    6 +-
 drivers/gpu/drm/i915/intel_overlay.c        |    7 ++
 drivers/gpu/drm/radeon/r600.c               |   24 +++++++++
 drivers/gpu/drm/radeon/r600d.h              |    1 
 drivers/gpu/drm/radeon/radeon_atombios.c    |   15 ++----
 drivers/gpu/drm/radeon/radeon_combios.c     |    4 +
 drivers/gpu/drm/radeon/rs600.c              |    1 
 drivers/gpu/drm/radeon/rs690.c              |    2 
 drivers/gpu/drm/radeon/rv770.c              |    5 +-
 drivers/gpu/drm/radeon/rv770d.h             |    1 
 drivers/misc/enclosure.c                    |    7 ++
 drivers/net/e1000e/hw.h                     |    2 
 drivers/net/e1000e/netdev.c                 |   13 +++--
 drivers/net/igb/igb_main.c                  |    8 +--
 drivers/net/wireless/ath/ath9k/eeprom_def.c |    2 
 drivers/net/wireless/ath/ath9k/hw.c         |   19 ++++++-
 drivers/net/wireless/ath/ath9k/xmit.c       |   68 ++++++++++++++--------------
 drivers/net/wireless/iwlwifi/iwl-scan.c     |   18 +++----
 drivers/parisc/led.c                        |    6 +-
 drivers/ssb/driver_chipcommon_pmu.c         |   17 ++++---
 drivers/ssb/pci.c                           |   20 +-------
 drivers/staging/comedi/Kconfig              |    5 ++
 drivers/staging/comedi/drivers/Makefile     |    4 +
 drivers/usb/core/hcd.c                      |    3 -
 fs/gfs2/dir.c                               |    2 
 fs/nfs/file.c                               |   13 ++++-
 fs/nfs/write.c                              |    7 --
 include/drm/drm_pciids.h                    |    7 ++
 include/linux/nfs_fs.h                      |    7 ++
 include/linux/ssb/ssb.h                     |    5 +-
 include/linux/ssb/ssb_driver_chipcommon.h   |   15 +++++-
 mm/memory.c                                 |   16 +++++-
 net/9p/trans_fd.c                           |    2 
 net/mac80211/mesh_plink.c                   |   42 ++++++++++++-----
 net/wireless/mlme.c                         |    8 +--
 net/wireless/scan.c                         |    5 ++
 45 files changed, 277 insertions(+), 186 deletions(-)

Alex Deucher (3):
      drm/radeon/kms/igp: sideport is AMD only
      drm/radeon: add new pci ids
      drm/radeon/kms/r7xx: add workaround for hw issue with HDP flush

Baruch Siach (1):
      arm/imx/gpio: add spinlock protection

Bob Peterson (1):
      GFS2: rename causes kernel Oops

Borislav Petkov (3):
      amd64_edac: Fix DCT base address selector
      amd64_edac: Correct scrub rate setting
      amd64_edac: Fix operator precendence error

Bruce Allan (1):
      e1000e: 82577/82578 PHY register access issues

Chris Wilson (1):
      drm/i915: Check overlay stride errata for i830 and i845

Christoph Fritz (1):
      ssb: fix NULL ptr deref when pcihost_wrapper is used

Dan Carpenter (1):
      9p: strlen() doesn't count the terminator

Dean Nelson (1):
      e1000e: don't inadvertently re-set INTX_DISABLE

Felix Fietkau (4):
      ath9k: fix a potential buffer leak in the STA teardown path
      ath9k_hw: fix an off-by-one error in the PDADC boundaries calculation
      ath9k: fix TSF after reset on AR913x
      ath9k: fix yet another buffer leak in the tx aggregation code

Greg Kroah-Hartman (2):
      Revert "ssb: Handle Netbook devices where the SPROM address is changed"
      Linux 2.6.34.3

Greg Rose (1):
      igb: Use only a single Tx queue in SR-IOV mode

Helge Deller (1):
      PARISC: led.c - fix potential stack overflow in led_proc_write()

Hugh Dickins (1):
      mm: fix ia64 crash when gcore reads gate area

Ian Abbott (1):
      comedi: Uncripple 8255-based DIO subdevices

James Bottomley (1):
      SCSI: enclosure: fix error path - actually return ERR_PTR() on error

Jan III Sobieski (1):
      add random binaries to .gitignore

Jeremy Fitzhardinge (1):
      xen: drop xen_sched_clock in favour of using plain wallclock time

Johannes Berg (2):
      cfg80211: ignore spurious deauth
      cfg80211: don't get expired BSSes

John W. Linville (3):
      ath9k: enable serialize_regmode for non-PCIE AR9160
      mac80211: avoid scheduling while atomic in mesh_rx_plink_frame
      ssb: do not read SPROM if it does not exist

Kyle McMartin (1):
      parisc: pass through '\t' to early (iodc) console

Larry Finger (1):
      ssb: Handle alternate SSPROM location

Ming Lei (1):
      USB: add missing "{}" in map_urb_for_dma

Rafał Miłecki (1):
      ssb: Look for SPROM at different offset on higher rev CC

Stanislaw Gruszka (1):
      iwlwifi: fix scan abort

Trond Myklebust (2):
      NFS: kswapd must not block in nfs_release_page
      NFS: Fix a typo in include/linux/nfs_fs.h

Xiao Guangrong (1):
      KVM: MMU: flush remote tlbs when overwriting spte with different pfn


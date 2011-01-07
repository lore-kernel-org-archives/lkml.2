Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab1AGCIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 21:08:37 -0500
Received: from mail-iy0-f194.google.com ([209.85.210.194]:44794 "EHLO
	mail-iy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756564Ab1AGCIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 21:08:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=gL3xFQc6gtkbxZRhGe0mcEDWhWLT8hxSRnE55CMnWT4mf8V9Ru9sL8PmEVdahc2xe6
         n0Y7BKyNa2p87Je+Q94WeR1k2hIKUsIyVA/hSSrIV47rWeVECdICubd+mnvy5BpWd7b0
         wsWgfrejLQfAD27S/rHXvsfzxy19zXTUNitis=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 6 Jan 2011 18:08:09 -0800
Message-ID: <AANLkTi=uN+36+Mox9y2bZvDD9Y=wb7wnQt0FPqdVkOB5@mail.gmail.com>
Subject: [ANN] compat-wireless for 2.6.37
To: linux-kernel@vger.kernel.org
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Its time for a 2.6.37 based release for upgrading your 802.11 /
Bluetooth / Ethernet drivers on older kernels now that 2.6.37 has been
released.

The good stuff:

http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.37/compat-wireless-2.6.37-2.tar.bz2
http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.37/compat-wireless-2.6.37-2-sn.tar.bz2

compat-wireless provides a backport of a few Linux kernel subsystems down to
older kernels:

  * 802.11
  * Bluetooth
  * Ethernet

For more details refer to the home page:

http://wireless.kernel.org/en/users/Download/stable/

The compat-wireless project consists of code from three projects:

  * The Linux kernel: linux-2.6-allstable.git
  * Compat-wirelesS: compat-wireless.git
  * Compat: compat.git

The compat-wireless stable releases incorporates code from from
each of these git trees for the respective upstream Linux kernel
stable release. A branch called linux-2.6.3x.y exists for each
stable release. Below we provide the ChangeLog of changes from
the previous branched release to the new branched release.

Release: linux-2.6.37

Updates from the compat.git project:
====================================

git shortlog linux-2.6.36.y..linux-2.6.37.y

Blaise Gassend (1):
      compat: Fixes missing sem member in struct device for RT PREEMPT
prior to 2.6.34

Felix Fietkau (4):
      compat: backport netlink changes used in the nl80211 cleanup
      compat: fix a crash in the netlink backport
      compat: backport pm_qos_*_request
      compat: backport pm_qos_request

Hauke Mehrtens (22):
      compat: backport init_dummy_netdev
      compat: backport net_ns_type_operations
      compat: fix warning in device_rename
      compat: backport linux/pci-aspm.h
      compat: backport skb_checksum_none_assert
      compat: backport printk_once
      compat: backport loff_t noop_llseek
      compat: backport list_for_each_entry_continue_rcu
      compat: backport PCMCIA API changes.
      compat: backport some usb urb functions
      compat: move pmcia backport code into compat-2.6.36.h
      compat: pcmcia/cs.h is removed form new kernels
      compat: fix build error in init_dummy_netdev
      compat: backport some more kfifo stuff
      compat: rename member in struct mmc_host.
      compat: backport sock_recv_ts_and_drops
      compat: fix device_lock functions on non rt kernel
      compat: lock correct mutex in device_lock
      compat: add empty implementation for usb_enable_autosuspend
      compat: fix build with kernel 2.6.37rc1
      compat: remove unnecessary ifdefs and empty file
      compat: add missing pm_runtime.h

Luis R. Rodriguez (5):
      compat: define PM_EVENT_SLEEP only if not defined
      compat: add support for ndo_init backport
      compat: backport upstream firmware_class bug through f45f3c1f
      compat: annotate release for v2.6.37-rc1
      compat: backport PCI_EXP_LNKCTL_ES added for on 2.6.29

Updates from the compat-wireless.git project:
=============================================

git shortlog linux-2.6.36.y..linux-2.6.37.y

Bala Shanmugam (2):
      compat-wireless: Added ath3k sflash workaround to crap directory
      Do not compile staging directory for bt target. Signed-off-by:
Bala Shanmugam <sbalashanmugam@atheros.com>

Hauke Mehrtens (39):
      compat-wireless: make patches apply again.
      compat-wireless: deactivate namespace
      compat-wireless: make compat-2.6.37.c build
      compat-wireless: fix hidp_output_raw_report
      compat-wireless: do not use needed_headroom
      compat-wireless: fix patch stile.
      compat-wireless: remove linux/gpio.h include
      compat-wireless: multiple changes to config file
      compat-wireless: rename CONFIG_IWLWIFI config symbol
      compat-wireless: add ifdefs into compat_autoconf.h
      compat-wireless: add support for kernel 2.6.24
      compat-wireless: convert ifndef for compat_autoconf.h
      compat-wireless: replace name CONFIG_IWLWIFI
      compat-wireless: fix generation of compat_autoconf.h
      compat-wireless: fix patch style
      compat-wireless: handle depending on something build as module
      compat-wireless: make atk6kl build with older kernels
      compat-wireless: fix for CONFIG_WIRELESS_EXT=n
      compat-wireless: build if kernel does not have mac80211
      compat-wireless: add conditions form config into compat_autoconf.h
      compat-wireless: Add warning if wext is deactivated
      compat-wireless: remove special handling for CONFIG_CFG80211_WEXT
      compat-wireless: add brcm80211 driver
      compat-wireless: make patch apply again.
      compat-wireless: make patch apply again.
      compat-wireless: make patches apply again
      compat-wirelsss: add carl9170
      compat-wireless: fix unresolved symbols with old kernels
      compat-wireless: "backport" pcmcia api changes.
      compat-wirelsss: refresh patches
      compat-wireless: fix wl12xx driver
      compat-wireless: remove already applied patches
      compat-wireless: make patch apply again
      compat-wireless: backport kfifo for rt2x00
      compat-wireless: backport sock_recv_ts_and_drops in compat
      compat-wireless: make patches apply again
      compat-wireless: fix regression:
      compat-wireless: revert workqueue patch
      compat-wireless: make patch apply again

Helmut Schaa (1):
      compat-wireless: Select minstrel_ht as default rc algo

Luis R. Rodriguez (87):
      compat-wireless: refresh patches
      compat-wireless: refresh crap patches
      compat-wireless: make gen-stable-release.sh use new release
number for dirs
      compat-wireless: remove the v from the release name
      compat-wireless: refresh patches
      compat-wireless: refresh crap patches
      compat-wireless: enable compilation of ath9k on >= 2.6.24
      compat-wireless: fix driver select for ath9k
      compat-wireless: fix unintended merge of changes
      compat-wireless: fix enabling of 2.6.24
      compat-wireless: fix multiqueue patches
      compat-wireless: fix patches/25-multicast-list_head.patch
      compat-wireless: refresh patches
      compat-wireless: fix compilation on iface.c
      compat-wireless: enable ath6kl from being included
      compat-wireless: enable ath6kl only for >= 2.6.32
      compat-wireless: refresh patches
      compat-wireless: refresh crap patches
      compat-wireless: update the atheros defconfigs/atheros-debug.mk
      compat-wireless: refresh patches
      compat-wireless: refresh crap patches
      compat-wireless: propagate config.mk changes to atheros defconfig
      compat-wireless: refresh patches
      compat-wireless: refresh crap patches
      compat-wireless: add CONFIG_ATH9K_RATE_CONTROL=y
      compat-wireless: update defconfigs/atheros-debug.mk
      compat-wireless: update broadcom staging Makefile
      compat-wireless: refresh patches
      compat-wireless: refresh crap patches
      compat-wireless: add support for generating pending-stable/ fixes
      compat-wireless: add support for -s for gen-stable-release.sh
      compat-wireless: fix -s usage on generation stable tarballs
      compat-wireless: add support for printing stats for pending-stable
      compat-wireless: update code-metrics to reflect extra patches applied
      compat-wireless: fix to include net/mac80211.h for pending-stable
      compat-wireless: fix uninstall for compat
      compat-wireless: patch refresh
      compat-wireless: Add the pending mac80211 reset work patch
      compat-wireless: replace ar9170 with carl9170
      compat-wireless: add key.o to driver-select for ath drivers
      compat-wireless: disable staging for most driver-select options
      compat-wireless: add driver-select for brcm80211
      compat-wireless: fix driver-select for brcm80211
      compat-wireless: add rx filter carl9170 patch to linux-next-pending/
      compat-wireless: fix patches for new wl1251 changes
      compat-wireless: refresh patches
      compat-wireless: refresh crap patches
      compat-wireless: add driver-select for wl1251 and wl1271
      compat-wireless: refresh patches
      compat-wireless: refresh crap patches
      compat-wireless: refresh patches
      compat-wireless: refresh crap patches
      compat-wireless: allow skipping updating the local tree
      compat-wireless: support ignoring some stable linux-next patches
      Revert "compat-wireless: fix update-initramfs script"
      compat-wireless: fix initramfs update
      compat-wireless: refresh patches for 2.6.37-rc1 release
      compat-wireless: refresh crap patches
      compat-wireless: move fwload btusb ath3k patch to linux-next-pending
      compat-wireless: refresh patches for 2.6.37-rc2
      compat-wireless: refresh patches for 2.6.37-rc3
      compat-wireless: refresh crap patches for 2.6.37-rc3
      compat-wireless: simple file change to annotate change
      compat-wireless: simple file change to annotate change for rc5
      compat-wireless: simple file change to annotate change for rc5 release v2
      compat-wireless: add a few linux-next cherry pick patches
      compat-wireless: cherry pick ath3k's new PID patch
      compat-wireless: remove
linux-next-pending/0001-btusb-Add-fw-load-support.patch
      compat-wireless: fix admin-update.sh for stable cherry picks
      compat-wireless: remove failed stable patches and backport one
      compat-wireless: backport stable:
ath9k-content-DMA-start-stop-through-the-PCU-lock.patch
      compat-wireless: backport stable patch:
ath9k-Fix-STA-disconnect-issue-due-to-received-MIC-f.patch
      compat-wireless: backport stable patch:
orinoco-initialise-priv-hw-before-assigning-the-inte.patch
      compat-wireless: suck in all pending-stable patches
      compat-wireless: refresh linux-next-cherry-pick/ patches
      compat-wireless: refresh crap patches after stable/cherry-pick
      compat-wireless: remove no-aggregation on VO patches
      compat-wireless: fix stable patch pull count
      compat-wireless: refresh patches for 2.6.37-rc6
      compat-wireless: refresh crap patches for 2.6.37-rc6
      compat-wireless: pending-stable updates for 2.6.37-rc6
      compat-wireless: refresh pending-stable patches
      compat-wireless: refresh crap patches after applying
pending-stable patches
      compat-wireless: Fix radio_enable patch for backports
      compat-wireless: remove the ath3k/btusb cherry picked patch now upstream
      compat-wireless: refresh patches for 2.6.37 first release
      compat-wireless: synch pending-stable patches

Senthil Balasubramanian (1):
      compat-wireless: fix scripts/driver-select for ath9k

Sven-Haegar Koch (1):
      compat-wireless: fix activesync devices

Tim Gardner (1):
      compat-wireless linux-2.6.37.y, fix compile error for pm_qos_add_request()

Walter Goldens (12):
      compat-wireless: introduce driver-select group for atlxx
      compat-wireless: update unload/wlunload scripts
      compat-wireless: unload modules list updated
      compat-wireless: update Makefile modules
      compat-wireless: enable uninstall for staging & atlxx
      compat-wireless: update bluetooth in Makefile
      compat-wireless: enable bluetooth via driver-select
      compat-wireless: update unloading scripts for bt
      compat-wireless: remove obsolete load scripts
      compat-wireless: update README file
      compat-wireless: disable update-initramfs except for b4xx/ssb
      compat-wireless: fix update-initramfs script

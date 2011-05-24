Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668Ab1EXACF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 20:02:05 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38844 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab1EXACC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 20:02:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=Zsh30gNKzdIIftEkRByV4e/odLJtuMxZnpOF09EcFY8asiX50nkd8vdpXbng542OQo
         dgCnM8to/B+scx1ea1XhVNx7r2XMEhXCRgcs67fg5nwGgNFt5z698EnwfrL6Vq5ZfbUP
         LdXbO4zUXqd1kJwY6TgwHDB0doPpzICrdDx0g=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 23 May 2011 17:01:41 -0700
Message-ID: <BANLkTikkGq8cnyKA453YZLc6mqYa=+bxvA@mail.gmail.com>
Subject: compat-wireless 2.6.39 final release
To: linux-wireless <linux-wireless@vger.kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before the world ended Linus decided to release v2.6.39 and now that
the show is not over we get to enjoy it. So we get the respective
backport of the 802.11 / BT / Ethernet drivers and subsystems
available to users on older kernels. The short and sweet details:

Vanilla release:

http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.39/compat-wireless-2.6.39-1.tar.bz2

The "-sn" release (pending-stable and linux-next-cherry-picks patches applied):

http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.39/compat-wireless-2.6.39-1-sn.tar.bz2

The all the details:

http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.39/ChangeLog-2.6.39-wireless

Below just the compat.git and compat-wireless.git updates, to see the
respective kernel updates check the ChangeLog above. I've tested this
release with iwlagn on 2.6.38. Please report any issues.

===============================================
ChangeLog for compat-wireless for linux-2.6.39
===============================================

This is the ChangeLog for the Linux kernel project compat-wireless.
It provides a backport of a few Linux kernel subsystems down to
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

Release: linux-2.6.39


Updates from the compat.git project:
====================================

git shortlog linux-2.6.38.y..linux-2.6.39.y

Hauke Mehrtens (10):
      compat: backport alloc_ordered_workqueue
      compat: add support for kernel 2.6.38
      compat: backport usb_pipe_endpoint()
      compat: backport tty_{lock,unlock,locked}
      compat: backport tty_set_termios
      compat: add tty_set_termios only for kernel >= 2.6.27
      compat: backport netdev_refcnt_read.
      compat: add support for kernel 2.6.39
      compat: fix build for kernel < 2.6.29
      compat: semaphore.h mpoved from asm/ to linux/

Luis R. Rodriguez (1):
      compat: backport IRQ namespace cleanup

Vasanthakumar Thiagarajan (1):
      compat: Define usleep_range(min, max) as msleep(max/1000) for <2.6.36

Updates from the compat-wireless.git project:
=============================================

git shortlog linux-2.6.38.y..linux-2.6.39.y

David Ward (1):
      compat-wireless: fix driver-select for iwl3945/iwlagn

Greg Whiteley (1):
      compat-wireless: rt2800pci (and rt2x00pci) don't unload on 'make unload'

Hauke Mehrtens (22):
      compat-wireless: adapt chamhes in brcm80211
      compat-wireless: remove max_brightness
      compat-wireless: remove compat for threaded_irq in rt2x00
      compat-wireless: backport of alloc_ordered_workqueue into compat.git
      compat-wireless: make patches apply again
      compat-wireless: brcm80211 adapt changes in mac80211
      compat-wireless: build zd1211rw only for kernel >= 2.6.29
      compat-wireless: activate BRCMFMAC
      compat-wireless: rename some config options
      compat-wireless: backport pm ops for atlx
      compat-wireless: some updates to bluetooth patch
      compat-wireless: brcm80211 fix is in upstream now
      compat-wireless: Add drivers/net/wireless/rtlwifi/rtl8192c
      compat-wireless: generate CONFIG_COMPAT_KERNEL_39
      compat-wireless: build ath9k common when no pci is available
      compat-wireless: updates needed for iwlwifi split
      compat-wireless: add rtl8192cu
      compat-wireless: some minor updates for config.mk
      compat-wireless: change number of patch:
      compat-wireless: do not set blink_set for kernel <= 2.6.24
      compat-wireless: backport threaded irq for wl12xx_spi
      compat-wireless: fix compile warning for wl12xx

Johannes Berg (1):
      fix Intel driver-select, make it iwlagn only for now

Luis R. Rodriguez (28):
      compat-wireless: refresh patches
      compat-wireless: fix stable pending tag mismatch output
      compat-wireless: skip directory if patches directory is empty
      compat-wireless: fix disable_bt
      compat-wireless: fix intel drivers on driver-select
      compat-wireless: fix gen-stable-release.sh for git tree updates
      compat-wireless: refresh patches
      compat-wireless: remove
crap/0001-ath9k-Add-debugfs-interface-to-dump-registers.patch
      compat-wireless: fix packet log patch to apply
      compat-wireless: refresh crap patches
      compat-wireless: remove ath3k bt workaround
      compat-wireless: refresh patches for 2.6.39-rc1
      compat-wireless: refresh patches for v2.6.39-rc1
      compat-wireless: suck out pending-stable patches from linux-next
      compat-wireless: fix compilation warning for wl12xx
      compat-wireless: fix usb makefile
      compat-wireless: refresh patches for 2.6.39-rc6
      compat-wireless: remove some already applied pending-stable patches
      compat-wireless: update pending stable fixes
      compat-wireless: add long range pending fix when using RTS / CTS
with ath9k
      compat-wireless: refresh patches for 2.6.39 final
      compat-wireless: backport pending-stable
ath9k-Fix-drain-txq-failure-in-flush.patch
      compat-wireless: backport
ath9k-avoid-enabling-interrupts-while-processing-rx.patch
      compat-wireless: backport
rtlwifi-rtl8192c-common-rtl8192ce-Fix-for-HT40-regre.patch
      compat-wireless: remove a linux-next-pending ath9k patc
      compat-wireless: add cherry picked:
ath9k-use-PS-wakeup-before-REG_READ.patch
      compat-wireless: clarify reason for cherry picked file
      compat-wireless: fix the cherry pick from applying

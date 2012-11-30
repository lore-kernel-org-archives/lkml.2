Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031576Ab2K3Ssv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 13:48:51 -0500
Received: from mail.kernel.org ([198.145.19.201]:57278 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031543Ab2K3Sst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:48:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/37] 3.0.54-stable review
Date: Fri, 30 Nov 2012 10:45:47 -0800
Message-Id: <20121130183857.166228045@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.54 release.
There are 37 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Dec  2 18:36:43 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.54-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.0.54-rc1

Jaehoon Chung <jh80.chung@samsung.com>
    mmc: sdhci-s3c: fix the wrong number of max bus clocks

Jussi Pakkanen <jussi.pakkanen@canonical.com>
    Input: bcm5974 - set BUTTONPAD property

Fenghua Yu <fenghua.yu@intel.com>
    x86, mce, therm_throt: Don't report power limit and package level thermal throttle events in mcelog

Merlin Schumacher <merlin.schumacher@gmail.com>
    acer-wmi: support for P key on TM8372

Chuansheng Liu <chuansheng.liu@intel.com>
    watchdog: using u64 in get_sample_period()

Johan Hovold <jhovold@gmail.com>
    USB: mct_u232: fix broken close

Mauro Carvalho Chehab <mchehab@redhat.com>
    get_dvb_firmware: fix download site for tda10046 firmware

Emil Tantilov <emil.s.tantilov@intel.com>
    ixgbe: add support for new 82599 device id

Emil Tantilov <emil.s.tantilov@intel.com>
    ixgbe: add support for new 82599 device

David Milburn <dmilburn@redhat.com>
    sata_svw: check DMA start bit before reset

joshua.a.hay@intel.com <joshua.a.hay@intel.com>
    ixgbe: add support for X540-AT1

Tilman Schmidt <tilman@imap.cc>
    bas_gigaset: fix pre_reset handling

David Henningsson <david.henningsson@canonical.com>
    ALSA: hda - Add support for Realtek ALC292

Duncan Roe <duncan_roe@acslink.net.au>
    ALSA: hda - Fix missing beep on ASUS X43U notebook

Kailang Yang <kailang@realtek.com>
    ALSA: hda - Add new codec ALC283 ALC290 support

Al Viro <viro@zeniv.linux.org.uk>
    sparc64: not any error from do_sigaltstack() should fail rt_sigreturn()

Jan Kara <jack@suse.cz>
    jbd: Fix lock ordering bug in journal_unmap_buffer()

Oliver Hartkopp <socketcan@hartkopp.net>
    can: bcm: initialize ifindex for timeouts without previous frame reception

Paul Bolle <pebolle@tiscali.nl>
    radeon: add AGPMode 1 quirk for RV250

Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
    mac80211: deinitialize ibss-internals after emptiness check

Darren Hart <dvhart@linux.intel.com>
    futex: avoid wake_futex() for a PI futex_q

Jens Axboe <axboe@kernel.dk>
    dm: fix deadlock with request based dm and queue request_fn recursion

Jiri Engelthaler <engycz@gmail.com>
    mtd: slram: invalid checking of absolute end address

Al Viro <viro@ZenIV.linux.org.uk>
    PARISC: fix user-triggerable panic on parisc

James Bottomley <James.Bottomley@HansenPartnership.com>
    PARISC: fix virtual aliasing issue in get_shared_area()

David Henningsson <david.henningsson@canonical.com>
    ALSA: hda - Cirrus: Correctly clear line_out_pins when moving to speaker

Clemens Ladisch <clemens@ladisch.de>
    ALSA: ua101, usx2y: fix broken MIDI output

Maciej Patelczyk <maciej.patelczyk@intel.com>
    SCSI: isci: copy fis 0x34 response into proper buffer

Bing Zhao <bzhao@marvell.com>
    mwifiex: report error to MMC core if we cannot suspend

Albert Pool <albertpool@solcon.nl>
    rtlwifi: rtl8192cu: Add new USB ID

Boris Ostrovsky <boris.ostrovsky@amd.com>
    x86, microcode, AMD: Add support for family 16h processors

Robert Richter <robert.richter@amd.com>
    x86-32: Fix invalid stack address while in softirq

David S. Miller <davem@davemloft.net>
    ifenslave: Fix unused variable warnings.

Danny Kukawka <danny.kukawka@bisect.de>
    riva/fbdev: fix several -Wuninitialized

Danny Kukawka <danny.kukawka@bisect.de>
    drivers/block/DAC960: fix -Wuninitialized warning

Danny Kukawka <danny.kukawka@bisect.de>
    drivers/block/DAC960: fix DAC960_V2_IOCTL_Opcode_T -Wenum-compare warning

Takashi Iwai <tiwai@suse.de>
    ALSA: pcmcia - Use pcmcia_request_irq()


-------------

Diffstat:

 Documentation/dvb/get_dvb_firmware          |  2 +-
 Documentation/networking/ifenslave.c        |  2 ++
 Makefile                                    |  4 ++--
 arch/parisc/kernel/signal32.c               |  6 ++++--
 arch/parisc/kernel/sys_parisc.c             |  2 ++
 arch/sparc/kernel/signal_64.c               |  4 +---
 arch/x86/include/asm/ptrace.h               | 15 ++++-----------
 arch/x86/kernel/cpu/mcheck/therm_throt.c    | 29 +++++++----------------------
 arch/x86/kernel/microcode_amd.c             |  4 ++++
 arch/x86/kernel/ptrace.c                    | 28 ++++++++++++++++++++++++++++
 drivers/ata/sata_svw.c                      | 35 +++++++++++++++++++++++++++++++++++
 drivers/block/DAC960.c                      | 18 ++++++++++--------
 drivers/gpu/drm/radeon/radeon_agp.c         |  5 ++++-
 drivers/input/mouse/bcm5974.c               |  3 +++
 drivers/isdn/gigaset/bas-gigaset.c          | 19 ++++++++++++++++---
 drivers/md/dm.c                             |  8 +++++++-
 drivers/mmc/host/sdhci-s3c.c                |  2 +-
 drivers/mtd/devices/slram.c                 |  2 +-
 drivers/net/ixgbe/ixgbe_82599.c             |  2 ++
 drivers/net/ixgbe/ixgbe_common.c            |  1 +
 drivers/net/ixgbe/ixgbe_main.c              |  6 ++++++
 drivers/net/ixgbe/ixgbe_type.h              |  3 +++
 drivers/net/wireless/mwifiex/sdio.c         | 11 ++++++-----
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c |  1 +
 drivers/platform/x86/acer-wmi.c             |  1 +
 drivers/scsi/isci/request.c                 |  2 +-
 drivers/usb/serial/mct_u232.c               | 14 ++++++++------
 drivers/video/riva/fbdev.c                  |  5 ++---
 fs/jbd/transaction.c                        |  2 ++
 kernel/futex.c                              | 18 +++++++++++++++++-
 kernel/watchdog.c                           |  4 ++--
 net/can/bcm.c                               |  3 +++
 net/mac80211/ibss.c                         |  8 ++++----
 sound/pci/hda/patch_cirrus.c                |  1 +
 sound/pci/hda/patch_realtek.c               |  4 ++++
 sound/pcmcia/pdaudiocf/pdaudiocf.c          |  2 +-
 sound/pcmcia/vx/vxpocket.c                  |  2 +-
 sound/usb/midi.c                            |  8 ++++++--
 38 files changed, 204 insertions(+), 82 deletions(-)



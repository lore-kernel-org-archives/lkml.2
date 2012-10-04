Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933633Ab2JDVUS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:20:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44933 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933538Ab2JDVUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:20:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: =?UTF-8?q?=5B=2000/58=5D=203=2E5=2E6-stable=20review?=
Date: Thu,  4 Oct 2012 14:19:07 -0700
Message-Id: <20121004210635.449598766@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.5.6 release.
There are 58 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat Oct  6 21:03:20 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.5.6-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Bart Van Assche <bvanassche@acm.org>
    SCSI: scsi_dh_alua: Enable STPG for unavailable ports

Dan Williams <djbw@fb.com>
    SCSI: scsi_remove_target: fix softlockup regression on hot remove

Avi Kivity <avi@redhat.com>
    x86/alternatives: Fix p6 nops on non-modular kernels

Dan Williams <dan.j.williams@intel.com>
    isci: fix isci_pci_probe() generates warning on efi failure path

Bart Van Assche <bvanassche@acm.org>
    IB/srp: Avoid having aborted requests hang

Bart Van Assche <bvanassche@acm.org>
    IB/srp: Fix use-after-free in srp_reset_req()

Patrick McHardy <kaber@trash.net>
    IPoIB: Fix use-after-free of multicast object

Dan Carpenter <dan.carpenter@oracle.com>
    remoteproc: fix a potential NULL-dereference on cleanup

Ohad Ben-Cohen <ohad@wizery.com>
    remoteproc: select VIRTIO to avoid build breakage

Wei Yongjun <yongjun_wei@trendmicro.com.cn>
    can: mscan-mpc5xxx: fix return value check in mpc512x_can_get_clock()

Stephen M. Cameron <scameron@beardog.cce.hp.com>
    SCSI: hpsa: Use LUN reset instead of target reset

Benjamin Herrenschmidt <benh@kernel.crashing.org>
    SCSI: ibmvscsi: Fix host config length field overflow

Kees Cook <keescook@chromium.org>
    Yama: handle 32-bit userspace prctl

Matthieu CASTET <matthieu.castet@parrot.com>
    UBI: erase free PEB with bitflip in EC header

Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
    UBI: fix autoresize handling in R/O mode

Russ Gorby <russ.gorby@intel.com>
    n_gsm: memory leak in uplink error path

Russ Gorby <russ.gorby@intel.com>
    n_gsm: added interlocking for gsm_data_lock for certain code paths

Russ Gorby <russ.gorby@intel.com>
    n_gsm: uplink SKBs accumulate on list

xiaojin <jin.xiao@intel.com>
    n_gsm.c: Implement 3GPP27.010 DLC start-up procedure in MUX

Denys Vlasenko <vda.linux@googlemail.com>
    coredump: prevent double-free on an error path in core dumper

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    xen/pciback: Restore the PCI config space after an FLR.

Sujith Manoharan <c_manoha@qualcomm.com>
    ath9k: Disable ASPM only for AR9285

Kevin Daughtridge <kevin@kdau.com>
    HID: keep dev_rdesc unmodified and use it for comparisons

Michael Spang <spang@chromium.org>
    Increase XHCI suspend timeout to 16ms

Elric Fu <elricfu1@gmail.com>
    xHCI: handle command after aborting the command ring

Elric Fu <elricfu1@gmail.com>
    xHCI: cancel command after command timeout

Elric Fu <elricfu1@gmail.com>
    xHCI: add aborting command ring function

Elric Fu <elricfu1@gmail.com>
    xHCI: add cmd_ring_state

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    xhci: Intel Panther Point BEI quirk.

Khalid Aziz <khalid.aziz@hp.com>
    firmware: Add missing attributes to EFI variable attribute print out from sysfs

Larry Finger <Larry.Finger@lwfinger.net>
    b43legacy: Fix crash on unload when firmware not available

Ben Hutchings <ben@decadent.org.uk>
    tools/hv: Check for read/write errors

Ben Hutchings <ben@decadent.org.uk>
    tools/hv: Fix exit() error code

Ben Hutchings <ben@decadent.org.uk>
    tools/hv: Fix file handle leak

Flavio Leitner <fbl@redhat.com>
    serial: set correct baud_base for EXSYS EX-41092 Dual 16950

Linus Walleij <linus.walleij@linaro.org>
    serial: pl011: handle corruption at high clock speeds

Vikram Pandita <vikram.pandita@ti.com>
    serial: omap: fix software flow control

Jiri Slaby <jslaby@suse.cz>
    TTY: ttyprintk, don't touch behind tty->write_buf

Stanislav Kozina <skozina@redhat.com>
    Remove BUG_ON from n_tty_read()

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: fix memory leak for saved channel list

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: don't dereference user memory for INSN_INTTRIG

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: jr3_pci: fix iomem dereference

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: s626: don't dereference insn->data

Larry Finger <Larry.Finger@lwfinger.net>
    staging: r8712u: Do not queue cloned skb

Christopher Brannon <chris@the-brannons.com>
    tty: keyboard.c: Remove locking from vt_get_leds.

Ben Hutchings <ben@decadent.org.uk>
    staging: speakup_soft: Fix reading of init string

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: serial: fix up bug with missing {}

Vivek Gautam <gautam.vivek@samsung.com>
    usb: host: xhci: Fix Null pointer dereferencing with 71c731a for non-x86 systems

Bjørn Mork <bjorn@mork.no>
    USB: qcaux: add Pantech vendor class match

Antonio Ospite <ospite@studenti.unina.it>
    USB: ftdi_sio: add TIAO USB Multi-Protocol Adapter (TUMPA) support

Bjørn Mork <bjorn@mork.no>
    USB: option: blacklist QMI interface on ZTE MF683

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    usb: gadget: initialize the strings in tcm_usb_gadget properly

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    usb: gadget: make g_printer enumerate again

Mikulas Patocka <mpatocka@redhat.com>
    dm verity: fix overflow check

Milan Broz <mbroz@redhat.com>
    dm table: clear add_random unless all devices have it set

Mike Snitzer <snitzer@redhat.com>
    dm: handle requests beyond end of device instead of using BUG_ON

Mike Snitzer <snitzer@redhat.com>
    dm mpath: only retry ioctl when no paths if queue_if_no_path set

Miklos Szeredi <miklos@szeredi.hu>
    vfs: dcache: fix deadlock in tree traversal


-------------

Diffstat:

 Makefile                                       |   4 +-
 arch/arm/plat-omap/include/plat/omap-serial.h  |   4 +-
 arch/x86/kernel/alternative.c                  |   2 +-
 drivers/char/ttyprintk.c                       |   2 +-
 drivers/firmware/efivars.c                     |  17 +-
 drivers/hid/hid-core.c                         |  16 +-
 drivers/hid/usbhid/hid-core.c                  |   6 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |   2 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |  19 +-
 drivers/infiniband/ulp/srp/ib_srp.c            |   3 +-
 drivers/md/dm-mpath.c                          |  11 +-
 drivers/md/dm-table.c                          |  26 ++-
 drivers/md/dm-verity.c                         |   8 +-
 drivers/md/dm.c                                |  56 +++--
 drivers/mtd/ubi/attach.c                       |   2 +-
 drivers/mtd/ubi/build.c                        |   5 +
 drivers/net/can/mscan/mpc5xxx_can.c            |   4 +-
 drivers/net/wireless/ath/ath9k/pci.c           |   5 +-
 drivers/net/wireless/b43legacy/main.c          |   2 +
 drivers/remoteproc/Kconfig                     |   1 +
 drivers/remoteproc/remoteproc_core.c           |  22 +-
 drivers/scsi/device_handler/scsi_dh_alua.c     |   3 +-
 drivers/scsi/hpsa.c                            |   2 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c               |   3 +
 drivers/scsi/isci/init.c                       |   1 -
 drivers/scsi/isci/probe_roms.c                 |   1 -
 drivers/scsi/scsi_sysfs.c                      |  30 ++-
 drivers/staging/comedi/comedi_fops.c           |   5 +-
 drivers/staging/comedi/drivers/jr3_pci.c       |   2 +-
 drivers/staging/comedi/drivers/s626.c          |   2 +-
 drivers/staging/rtl8712/rtl8712_recv.c         |   5 +-
 drivers/staging/speakup/speakup_soft.c         |  13 +-
 drivers/tty/n_gsm.c                            |  26 ++-
 drivers/tty/n_tty.c                            |   3 +-
 drivers/tty/serial/8250/8250_pci.c             |   9 +-
 drivers/tty/serial/amba-pl011.c                |  15 +-
 drivers/tty/serial/omap-serial.c               |  12 +-
 drivers/tty/vt/keyboard.c                      |   3 -
 drivers/usb/gadget/printer.c                   | 128 +++++------
 drivers/usb/gadget/tcm_usb_gadget.c            |  33 +--
 drivers/usb/gadget/tcm_usb_gadget.h            |  14 +-
 drivers/usb/host/xhci-mem.c                    |   7 +
 drivers/usb/host/xhci-pci.c                    |   1 +
 drivers/usb/host/xhci-ring.c                   | 286 ++++++++++++++++++++++++-
 drivers/usb/host/xhci.c                        |  38 +++-
 drivers/usb/host/xhci.h                        |  20 ++
 drivers/usb/serial/ftdi_sio.c                  |   2 +
 drivers/usb/serial/ftdi_sio_ids.h              |   5 +
 drivers/usb/serial/option.c                    |   3 +-
 drivers/usb/serial/qcaux.c                     |  10 +-
 drivers/usb/serial/usb-serial.c                |   3 +-
 drivers/xen/xen-pciback/pci_stub.c             |   1 +
 fs/binfmt_elf.c                                |  19 +-
 fs/dcache.c                                    |   6 +
 include/linux/pci_ids.h                        |   1 -
 security/yama/yama_lsm.c                       |   2 +-
 tools/hv/hv_kvp_daemon.c                       |  45 ++--
 57 files changed, 710 insertions(+), 266 deletions(-)



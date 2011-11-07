Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab1KGWby (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 17:31:54 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:48633 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750918Ab1KGWbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 17:31:52 -0500
X-Sasl-enc: TATmc+lhXmOPwfZ6FYZ5BwEqI1kkgnmJUbF4s4eTSD8x 1320705111
Date: Mon, 7 Nov 2011 14:31:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.33.20
Message-ID: <20111107223111.GA21771@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 2.6.33.20 kernel.

This is primarily for the use of those people who are stuck using the
=2E33-rt kernel.  Anyone else who really wants to use the .33 kernel tree
is welcome to use this one as well.

Note, this is the LAST 2.6.33 kernel that will be released.  It is now
end-of-life, please move to the 3.0 kernel for your real time needs.

The updated 2.6.33.y git tree can be found at(NOTE THE ADDRESS CHANGE):
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-2.6.33.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsh=
ortlog;h=3Drefs/heads/linux-2.6.33.y

thanks,

greg k-h

------------

 Documentation/stable_kernel_rules.txt       |   12 +--
 Makefile                                    |    2=20
 arch/arm/mach-davinci/board-da850-evm.c     |   28 +++++++++
 arch/arm/plat-mxc/include/mach/iomux-v3.h   |   10 +--
 arch/mips/alchemy/mtx-1/platform.c          |    9 --
 arch/powerpc/kernel/pci_of_scan.c           |    2=20
 arch/s390/kvm/kvm-s390.c                    |   14 +++-
 arch/sparc/include/asm/spinlock_32.h        |   11 ++-
 arch/sparc/include/asm/spinlock_64.h        |    6 -
 arch/sparc/kernel/pcic.c                    |    4 -
 arch/x86/include/asm/processor.h            |   23 +++++++
 arch/x86/kernel/amd_iommu.c                 |    2=20
 arch/x86/kernel/kprobes.c                   |    4 -
 arch/x86/kernel/smpboot.c                   |   85 -----------------------=
-----
 arch/x86/xen/smp.c                          |   10 +++
 arch/x86/xen/xen-asm_32.S                   |    8 +-
 drivers/ata/ahci.c                          |   12 +++
 drivers/block/xen-blkfront.c                |    2=20
 drivers/char/hvc_console.c                  |    8 +-
 drivers/char/tpm/tpm.c                      |    9 ++
 drivers/hid/hid-ids.h                       |    3=20
 drivers/hid/usbhid/hid-quirks.c             |    1=20
 drivers/hwmon/w83627ehf.c                   |   15 +++-
 drivers/md/linear.h                         |    2=20
 drivers/md/md.c                             |   12 +++
 drivers/media/video/cx23885/cx23885-dvb.c   |    2=20
 drivers/media/video/uvc/uvc_driver.c        |    2=20
 drivers/media/video/uvc/uvc_video.c         |   10 ++-
 drivers/media/video/uvc/uvcvideo.h          |    2=20
 drivers/net/cnic.c                          |    4 -
 drivers/net/e1000/e1000_hw.c                |    6 +
 drivers/net/irda/smsc-ircc2.c               |    2=20
 drivers/net/rionet.c                        |    4 -
 drivers/net/usb/asix.c                      |    4 +
 drivers/net/wireless/b43/main.c             |    3=20
 drivers/net/wireless/rt2x00/rt2800lib.c     |   17 ++---
 drivers/net/wireless/rt2x00/rt2x00usb.c     |   14 ----
 drivers/platform/x86/thinkpad_acpi.c        |    7 +-
 drivers/s390/cio/ccwgroup.c                 |   42 +++++++------
 drivers/scsi/3w-9xxx.c                      |    2=20
 drivers/scsi/aacraid/commsup.c              |    2=20
 drivers/scsi/fcoe/fcoe.c                    |   19 +++++-
 drivers/scsi/ipr.c                          |    2=20
 drivers/scsi/libiscsi_tcp.c                 |   14 ----
 drivers/scsi/libsas/sas_expander.c          |   14 ++--
 drivers/scsi/qla2xxx/qla_init.c             |    3=20
 drivers/scsi/qla2xxx/qla_isr.c              |    1=20
 drivers/staging/quatech_usb2/quatech_usb2.c |    9 ++
 drivers/usb/class/cdc-acm.c                 |    3=20
 drivers/usb/core/devio.c                    |   27 +++++++-
 drivers/usb/host/ehci-hub.c                 |    7 --
 drivers/usb/host/fhci-sched.c               |   19 ++++--
 drivers/usb/host/xhci-mem.c                 |   22 +++----
 drivers/usb/mon/mon_bin.c                   |    2=20
 drivers/usb/musb/musb_core.c                |    1=20
 drivers/usb/serial/ftdi_sio.c               |   24 +++++++
 drivers/usb/serial/ftdi_sio_ids.h           |    7 +-
 drivers/usb/serial/pl2303.c                 |   27 +++++++-
 drivers/usb/serial/pl2303.h                 |    5 +
 drivers/usb/serial/qcserial.c               |    1=20
 drivers/usb/storage/transport.c             |   34 ++++++-----
 drivers/video/carminefb.c                   |    6 -
 drivers/watchdog/mtx-1_wdt.c                |    5 -
 fs/9p/v9fs.c                                |   43 +++++++++++---
 fs/cifs/cifssmb.c                           |    3=20
 fs/eventpoll.c                              |   25 +++++---
 fs/ext4/ext4.h                              |    3=20
 fs/ext4/extents.c                           |    1=20
 fs/lockd/clntproc.c                         |    8 ++
 fs/nfsd/nfs4proc.c                          |    2=20
 fs/nfsd/nfs4state.c                         |    2=20
 fs/nfsd/nfs4xdr.c                           |   12 +++
 fs/nfsd/state.h                             |    6 -
 fs/proc/kcore.c                             |    2=20
 fs/splice.c                                 |    3=20
 include/linux/ext2_fs.h                     |    4 -
 include/linux/ext3_fs.h                     |    4 -
 include/linux/jiffies.h                     |    2=20
 include/linux/sunrpc/sched.h                |    4 -
 include/net/scm.h                           |    5 -
 kernel/kmod.c                               |    4 -
 kernel/time.c                               |    2=20
 kernel/trace/trace.c                        |    4 -
 lib/kobject_uevent.c                        |    2=20
 mm/mmap.c                                   |   20 ++++--
 net/9p/client.c                             |   13 ++--
 net/atm/br2684.c                            |    7 +-
 net/bluetooth/l2cap.c                       |    3=20
 net/bluetooth/rfcomm/sock.c                 |    1=20
 net/core/dev.c                              |    2=20
 net/core/scm.c                              |   10 +--
 net/core/skbuff.c                           |   14 +++-
 net/ipv6/ip6_output.c                       |    2=20
 net/sched/sch_api.c                         |   14 ++--
 net/sunrpc/clnt.c                           |    3=20
 net/sunrpc/sched.c                          |    1=20
 net/wireless/nl80211.c                      |    9 +-
 net/wireless/reg.c                          |    1=20
 net/x25/af_x25.c                            |    3=20
 sound/pci/hda/patch_cirrus.c                |    2=20
 sound/pci/hda/patch_realtek.c               |    6 +
 sound/soc/codecs/ak4535.c                   |   10 +--
 sound/soc/codecs/ak4642.c                   |   22 +++----
 sound/soc/soc-jack.c                        |    2=20
 104 files changed, 591 insertions(+), 364 deletions(-)

Alexandre Bounine (1):
      drivers/net/rionet.c: fix ethernet address macros for LE platforms

Andrew Vasquez (1):
      qla2xxx: Correct inadvertent loop state transitions during port-updat=
e handling.

Aneesh Kumar K.V (1):
      fs/9p: Fid is not valid after a failed clunk.

Anton Blanchard (1):
      ipr: Always initiate hard reset in kdump kernel

Axel Lin (1):
      ASoC: ak4535: fixup cache register table

Bernd Schubert (1):
      nfsd4: Remove check for a 32-bit cookie in nfsd4_readdir()

Carsten Otte (1):
      KVM: s390: check cpu_id prior to using it

Changli Gao (1):
      splice: direct_splice_actor() should not use pos in sd

Dan Carpenter (1):
      kcore: fix test for end of list

Dan Rosenberg (1):
      Bluetooth: Prevent buffer overflow in l2cap config request

Daniel Schwierzeck (1):
      atm: br2684: Fix oops due to skb->dev being NULL

David Henningsson (2):
      ALSA: HDA: Cirrus - fix "Surround Speaker" volume control name
      ALSA: HDA: Add new revision for ALC662

Denis Pershin (1):
      usb: cdc-acm: Owen SI-30 support

Eric Benoit (1):
      USB: pl2303: add id for SMART device

Eric Dumazet (3):
      gro: fix different skb headrooms
      scm: lower SCM_MAX_FD
      net_sched: Fix qdisc_notify()

Eric Van Hensbergen (1):
      net/9p: fix client code to fail more gracefully on protocol error

Filip Palian (1):
      Bluetooth: l2cap and rfcomm: fix 1 byte infoleak to userspace.

Florian Fainelli (2):
      Revert "MIPS: MTX-1: Make au1000_eth probe all PHY
      watchdog: mtx1-wdt: fix build failure

Greg Kroah-Hartman (3):
      Revert "x86, hotplug: Use mwait to offline a processor, fix the legac=
y case"
      Revert "usb: musb: restore INDEX register in resume path"
      Linux 2.6.33.20

Hakan Kvist (1):
      USB: ftdi_sio: add PID for Sony Ericsson Urban

Hendrik Brueckner (1):
      hvc_console: Improve tty/console put_chars handling

Herbert Xu (1):
      ipv6: Add GSO support on forwarding path

Hugh Dickins (1):
      vm: fix vm_pgoff wrap in upward expansion

Ian Campbell (1):
      sparc: fix array bounds error setting up PCIC NMI trap

Igor Mammedov (1):
      xen: x86_32: do not enable iterrupts when returning from exception in=
 interrupt context

J. Bruce Fields (2):
      nfsd4: fix seqid_mutating_error
      nfsd4: ignore WANT bits in open downgrade

Jack Wang (1):
      libsas: set sas_address and device type of rphy

James Bottomley (1):
      3w-9xxx: fix iommu_iova leak

Jarek Poplawski (2):
      net: Fix a memmove bug in dev_gro_receive()
      gro: Re-fix different skb headrooms

Jean Delvare (2):
      hwmon: (w83627ehf) Properly report thermal diode sensors
      carminefb: Fix module parameters permissions

Jean-Christophe PLAGNIOL-VILLARD (1):
      USB: ftdi_sio: add Calao reference board support

Jeff Kirsher (1):
      e1000: Fix driver to be used on PA RISC C8000 workstations

Jeff Layton (1):
      cifs: fix possible memory corruption in CIFSFindNext

Jeremiah Matthey (1):
      HID: usbhid: Add support for SiGma Micro chip

Jerry Huang (1):
      QE/FHCI: fixed the CONTROL bug

Jiri Kosina (1):
      kmod: prevent kmod_loop_msg overflow in __request_module()

Joerg Roedel (1):
      iommu/amd: Fix wrong shift direction

Johannes Stezenbach (1):
      usbmon vs. tcpdump: fix dropped packet count

Josh Boyer (1):
      Update email address for stable patch submission

Josh Stone (1):
      x86: Fix compilation bug in kprobes' twobyte_is_boostable

Jouni Malinen (1):
      cfg80211: Fix validation of AKM suites

Kautuk Consul (2):
      staging: quatech_usb2: Potential lost wakeup scenario in TIOCMIWAIT
      xhci-mem.c: Check for ring->first_seg !=3D NULL

Kiran Patil (1):
      fcoe: Unable to select the exchangeID from offload pool for storage t=
argets

Konrad Rzeszutek Wilk (1):
      xen/smp: Warn user why they keel over - nosmp or noapic and what to u=
se instead.

Kuninori Morimoto (1):
      ASoC: ak4642: fixup cache register table

Larry Finger (1):
      rtl2800usb: Fix incorrect storage of MAC address on big-endian platfo=
rms

Linus Torvalds (1):
      vm: fix vm_pgoff wrap in stack expansion

Luben Tuikov (1):
      USB: storage: Use normalized sense when emulating autosense

Luciano Coelho (1):
      nl80211: fix overflow in ssid_len

Manoj Iyer (1):
      thinkpad-acpi: module autoloading for newer Lenovo ThinkPads.

Manual Munz (1):
      b43: Fix beacon problem in ad-hoc mode

Marek Marczykowski (1):
      xen-blkfront: fix data size for xenbus_gather in blkfront_connect

Marek Vasut (1):
      ASIX: Add AX88772B USB ID

Mark Brown (1):
      ASoC: Fix reporting of partial jack updates

Mark Nelson (1):
      ahci: Enable SB600 64bit DMA on Asus M3A

Mark Salyzyn (2):
      libsas: fix failure to revalidate domain for anything but the first e=
xpander child.
      libsas: fix panic when single phy is disabled on a wide port

Matthew Daley (1):
      x25: Prevent skb overreads when checking call user data

Matthias Dellweg (1):
      usb/core/devio.c: Check for printer class specific request

Mauro Carvalho Chehab (1):
      tuner_xc2028: Allow selection of the frequency adjustment code for XC=
3028

Michael Chan (1):
      cnic: Improve NETDEV_UP event handling

Michal Schmidt (1):
      GRO: fix merging a paged skb after non-paged skbs

Michal Sroczynski (1):
      USB: PL2303: correctly handle baudrates above 115200

Mikael Pettersson (2):
      sparc64: remove unnecessary macros from spinlock_64.h
      sparc32: unbreak arch_write_unlock()

Mike Christie (1):
      libiscsi_tcp: fix LLD data allocation

Milan Broz (1):
      kobj_uevent: Ignore if some listeners cannot handle message

Ming Lei (1):
      uvcvideo: Set alternate setting 0 on resume if the bus has been reset

NeilBrown (2):
      md/linear: avoid corrupting structure while waiting for rcu_free to c=
omplete.
      md: Fix handling for devices from 2TB to 4TB in 0.90 metadata.

Nelson Elhage (1):
      epoll: fix spurious lockdep warnings

Paul Fertser (1):
      plat-mxc: iomux-v3.h: implicitly enable pull-up/down when that's desi=
red

Peter Huewe (2):
      TPM: Call tpm_transmit with correct size
      TPM: Zero buffer after copying to userspace

Peter Stuge (1):
      USB: ftdi_sio: Support TI/Luminary Micro Stellaris BD-ICDI Board

Prem Karat (1):
      fs/9p: Fix invalid mount options/args

Rajkumar Manoharan (1):
      wireless: Reset beacon_found while updating regulatory

Randy Dunlap (1):
      irda: fix smsc-ircc2 section mismatch warning

Rigbert Hamisch (1):
      USB: qcserial: add device ID for "HP un2430 Mobile Broadband Module"

Sebastian Ott (1):
      ccwgroup: move attributes to attribute group

Serge Hallyn (1):
      USB: pid_ns: ensure pid is not freed during kill_pid_info_as_uid

Sonny Rao (1):
      powerpc/pci: Check devices status property when scanning OF tree

Stanislaw Gruszka (1):
      rt2x00: do not drop usb dev reference counter on suspend

Steven Rostedt (1):
      tracing: Fix returning of duplicate data after EOF in trace_pipe_raw

Sudhakar Rajashekhara (1):
      ARM: davinci: da850 EVM: read mac address from SPI flash

Takashi Iwai (1):
      ALSA: hda/realtek - Avoid bogus HP-pin assignment

Theodore Ts'o (1):
      ext2,ext3,ext4: don't inherit APPEND_FL or IMMUTABLE_FL for new inodes

Trond Myklebust (1):
      NLM: Don't hang forever on NLM unlock requests

Vasily Averin (1):
      aacraid: reset should disable MSI interrupt

Venkateswararao Jujjuri (JV) (1):
      net/9p: Fix the msize calculation.

Wang Zhi (1):
      USB: EHCI: Do not rely on PORT_SUSPEND to stop USB resuming in ehci_b=
us_resume().

Zheng Liu (1):
      ext4: fix BUG_ON() in ext4_ext_insert_extent()

hank (1):
      time: Change jiffies_to_clock_t() argument type to unsigned long


--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIbBAEBAgAGBQJOuFwvAAoJEDjbvchgkmk+fmwP+IJQQOODe/iXw1k8c346eZrb
ptt1rwOW6KO0lxDg3RkEz/60RNsQa+jSjuzrDzDLRMsnd36k7rH+Z+kSjzeO07G8
IPjO/R9bKpLohl3dSk1BP86SJETa0nR4C6DH9r6fgK/WW5ZbRf2kY3dZBknpXxJ7
PL5oIS/DfUhLBOkbY5pBBGGuTdxAhR1hXTMy9vq0I5MqPt4GHvw9FUWrtW4Xgmqw
yTHndz/47qDpxQ3gZsJW8B4JR2NC1UhsymGyF1DN2UK4rDzp0IbPzUoFCphXvoYs
sJa+73E/t5zuwTaUW5h6eaAqrJkXZhjn58JEKiuI78+J/1+8B3yYcfGwuD9udPdl
Mva0P6Hev0IyPibkgRaGF1j4g8C/Np44IuPRZcapkaW3Oz0bvZ63BuTbxpJvW8ir
Sppec8evxl2nHuCzYBKGuVvQhWQB8eRCBDl1is0E2fSWC8og9DXBOoT0wyqq0LIe
rwlu0yLSOSmlu6QMj24khuTnDv5DmqeEp9qXNe2JoFW2dmmLi8eREa1uwiRkr0HU
rztEhLfVlgA5dTPq0WRj2rmodeLySydKIsFiDwllRnyi2mGJVE3HFNwVWWkVVblN
vzVXtYoP2PniRpclRnhNHj04fnFhCitngudZoXLq7VOYI+ypqYcs75AE6S2m+fln
LbYdvYQYYSUpDkis/Mo=
=Jg/M
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--

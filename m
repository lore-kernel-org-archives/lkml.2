Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758536Ab2EUUfu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 16:35:50 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44704 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756883Ab2EUUfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 16:35:48 -0400
Date: Mon, 21 May 2012 13:35:42 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.0.32
Message-ID: <20120521203542.GA20639@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.32 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.0.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------


 Documentation/networking/ip-sysctl.txt |    4 -
 Makefile                               |    2=20
 arch/arm/kernel/smp.c                  |    4 -
 arch/arm/kernel/sys_arm.c              |    2=20
 arch/arm/mach-orion5x/mpp.h            |    4 -
 arch/arm/mm/fault.c                    |    4 +
 arch/ia64/include/asm/unistd.h         |    3 -
 arch/ia64/kernel/entry.S               |    3 +
 arch/sparc/kernel/central.c            |    2=20
 arch/sparc/mm/ultra.S                  |    6 +-
 arch/tile/kernel/compat_signal.c       |   12 ++---
 arch/x86/kernel/setup_percpu.c         |   14 +++++
 arch/x86/xen/enlighten.c               |    7 ++
 arch/x86/xen/mmu.c                     |    7 ++
 drivers/acpi/sleep.c                   |    8 +++
 drivers/crypto/Kconfig                 |    1=20
 drivers/gpio/Kconfig                   |   11 ++--
 drivers/gpio/pch_gpio.c                |    1=20
 drivers/md/md.c                        |    2=20
 drivers/media/rc/ene_ir.c              |   32 ++++++-------
 drivers/media/rc/fintek-cir.c          |   20 ++++----
 drivers/media/rc/ite-cir.c             |   20 ++++----
 drivers/media/rc/nuvoton-cir.c         |   36 +++++++--------
 drivers/media/rc/winbond-cir.c         |   78 ++++++++++++++++------------=
-----
 drivers/net/Kconfig                    |   11 ++--
 drivers/net/pch_gbe/pch_gbe_main.c     |   50 ++++++++++++++++-----
 drivers/net/pch_gbe/pch_gbe_param.c    |   15 +++---
 drivers/net/sky2.c                     |   31 ++++++++-----
 drivers/net/sky2.h                     |    1=20
 drivers/net/sungem.c                   |    2=20
 drivers/net/tg3.c                      |   18 ++++++-
 drivers/net/usb/asix.c                 |    4 -
 drivers/net/usb/cdc_ether.c            |   30 +++++++++++-
 drivers/net/usb/smsc95xx.c             |    2=20
 drivers/net/usb/usbnet.c               |   54 ++++++++++++++++------
 drivers/platform/x86/sony-laptop.c     |    2=20
 drivers/regulator/max8997.c            |    2=20
 drivers/scsi/hpsa.c                    |    4 -
 fs/ext3/ialloc.c                       |    8 ++-
 fs/ext4/ialloc.c                       |    8 ++-
 fs/ext4/xattr.c                        |    7 +-
 fs/jffs2/gc.c                          |    2=20
 fs/nfs/nfs4proc.c                      |    1=20
 fs/super.c                             |    2=20
 include/asm-generic/statfs.h           |    2=20
 include/linux/seqlock.h                |    2=20
 include/linux/usb/usbnet.h             |    3 -
 init/do_mounts.c                       |    2=20
 kernel/compat.c                        |   63 +++++++++++++++++++-------
 kernel/fork.c                          |    3 +
 mm/hugetlb.c                           |    1=20
 mm/memcontrol.c                        |    6 ++
 mm/nobootmem.c                         |    3 -
 mm/percpu.c                            |   10 ++++
 net/core/dev.c                         |   20 ++++++++
 net/ipv4/tcp.c                         |   12 ++---
 net/ipv4/tcp_input.c                   |    2=20
 net/l2tp/l2tp_ip.c                     |    3 -
 net/sched/sch_netem.c                  |    6 --
 sound/pci/echoaudio/echoaudio_dsp.c    |    2=20
 sound/pci/hda/hda_intel.c              |    6 +-
 61 files changed, 450 insertions(+), 233 deletions(-)

Alexander Clouter (1):
      crypto: mv_cesa requires on CRYPTO_HASH to build

Axel Lin (1):
      regulator: Fix the logic to ensure new voltage setting in valid range

Ben Hutchings (1):
      ARM: orion5x: Fix GPIO enable bits for MPP9

Bj=F8rn Mork (1):
      cdc_ether: Ignore bogus union descriptor for RNDIS devices

Chris Metcalf (2):
      hugetlb: prevent BUG_ON in hugetlb_fault() -> hugetlb_cow()
      arch/tile: apply commit 74fca9da0 to the compat signal handling as we=
ll

Colin Cross (1):
      ARM: 7414/1: SMP: prevent use of the console when using idmap_pgd

Dan Carpenter (1):
      pch_gbe: memory corruption calling pch_gbe_validate_option()

Dan Williams (1):
      cdc_ether: add Novatel USB551L device IDs for FLAG_WWAN

Darren Hart (1):
      pch_gbe: Do not abort probe on bad MAC

David Henningsson (1):
      ALSA: HDA: Lessen CPU usage when waiting for chip to respond

David S. Miller (1):
      sparc64: Do not clobber %g2 in xcall_fetch_glob_regs().

David Vrabel (1):
      xen/pci: don't use PCI BIOS service for configuration space accesses

Eric Dumazet (2):
      netem: fix possible skb leak
      tcp: change tcp_adv_win_scale and tcp_rmem[2]

Eric Sandeen (1):
      ext4: avoid deadlock on sync-mounted FS w/o journal

Eric W. Biederman (1):
      net: In unregister_netdevice_notifier unregister the netdevices.

Gerard Lledo (1):
      sungem: Fix WakeOnLan

Greg Kroah-Hartman (1):
      Linux 3.0.32

H. Peter Anvin (1):
      asm-generic: Use __BITS_PER_LONG in statfs.h

Ingo van Lil (1):
      asix: Fix tx transfer padding for full-speed USB

Jan Kara (2):
      ext3: Fix error handling on inode bitmap corruption
      ext4: fix error handling on inode bitmap corruption

Jan Kiszka (1):
      compat: Fix RT signal mask corruption via sigprocmask

Jonathan Brassow (1):
      MD: Add del_timer_sync to mddev_suspend (fix nasty panic)

Jonathan Nieder (1):
      NFSv4: Revalidate uid/gid after open

Josh Boyer (1):
      sony-laptop: Enable keyboard backlight by default

Josh Cartwright (1):
      jffs2: Fix lock acquisition order bug in gc path

Kazuya Mio (1):
      wake up s_wait_unfrozen when ->freeze_fs fails

Konrad Rzeszutek Wilk (1):
      xen/pte: Fix crashes when trying to see non-existent PGD/PMD/PUD/PTEs

Lan Tianyu (1):
      ACPI / PM: Add Sony Vaio VPCCW29FX to nonvs blacklist.

Linus Torvalds (1):
      Fix __read_seqcount_begin() to use ACCESS_ONCE for sequence value read

Luis Henriques (1):
      media: rc: Postpone ISR registration

Mark Hills (1):
      ALSA: echoaudio: Remove incorrect part of assertion

Matt Carlson (1):
      tg3: Avoid panic from reserved statblk field access

Mike Galbraith (1):
      namespaces, pid_ns: fix leakage on fork() failure

Ming Lei (1):
      usbnet: fix skb traversing races during unlink(v2)

Paolo Pisati (1):
      smsc95xx: mark link down on startup and let PHY interrupt deal with c=
arrier changes

Russ Anderson (1):
      mm: nobootmem: fix sign extend problem in __free_pages_memory()

Russell King (1):
      ARM: prevent VM_GROWSDOWN mmaps extending below FIRST_USER_ADDRESS

Sasha Levin (2):
      net: l2tp: unlock socket lock before returning from l2tp_ip_sendmsg
      init: don't try mounting device as nfs root unless type fully matches

Sha Zhengju (1):
      memcg: free spare array to avoid memory leak

Stephen M. Cameron (1):
      SCSI: hpsa: Add IRQF_SHARED back in for the non-MSI(X) interrupt hand=
ler

Tejun Heo (2):
      percpu, x86: don't use PMD_SIZE as embedded atom_size on 32bit
      percpu: pcpu_embed_first_chunk() should free unused parts after all a=
llocs are complete

Tim Bird (1):
      ARM: 7410/1: Add extra clobber registers for assembly in kernel_execve

Tomoya MORINAGA (1):
      pch_gpio: Support new device LAPIS Semiconductor ML7831 IOH

Toshiharu Okada (3):
      pch_gbe: fixed the issue which receives an unnecessary packet.
      pch_gbe: support ML7831 IOH
      pch_gbe: Fixed the issue on which PC was frozen when link was downed.

Willy Tarreau (1):
      tcp: do_tcp_sendpages() must try to push data out on oom conditions

stephen hemminger (2):
      sky2: propogate rx hash when packet is copied
      sky2: fix receive length error in mixed non-VLAN/VLAN traffic

=C9meric Maschino (1):
      ia64: Add accept4() syscall


--BOKacYhQ+x31HxR3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPuqceAAoJEDjbvchgkmk+u+UP/2NPZODM6du/52eln80R9PXj
CnfrjPo5S0ZNzGPxpVdt3+GJohnFiNNMuYCWXJoJnoj6Lk0qjRxZSKdhzlUeSsN3
7EqHSIrdfiq+JmcPJ/ovZfKFbeZbBLGs+7Xos66BKbgupiREywlYbtr8AlsFrhSy
S29YNmu19QZurKT86721sDug2bjhDMii1dy1dO+lWRsSXqwBwXwVMLYpfwRt4Wx5
CHmU92j5xehl/RWdSZeJ68pC93IBw0vREf9RwP03y3FC/yJfQMSNpHfABjBRaDSn
SoDubgO5tUTUUOh4SCvFQnqWSovSDzOCbYqvLrXv999ziO7+OIBVrB75JlNIFKSN
6/Y69ryQ9SC1lflll3oaaWYch4Gbnoe6myAjirDcrZsuEB85ULEKaW1aKWtyn5WQ
A+16AZqQu+Syf8T4JRrw1sr8I3LTy68Y3GXCkyTy+G1Jmua856IumNkj24PtJCVY
FIgmGCPqMCS8BeIbpdvAVGv0NLyskWY9EmF3QBP8AY1//YxozKkKpLWDygScLGuY
3/V+akefO0wVLdNqMUD92DmL2lbGHFpbMAqz14KUNzJ6yb3z91jNxsT4Wvo2S4WI
Iv4QQx37Bp0tyyb8Pfq2xuyFQi1oqTwPocZDJeN11PSxygcCna32tEgozpMKxRV3
dhoU0FXJBp4bWFFKmrXw
=x/Uz
-----END PGP SIGNATURE-----

--BOKacYhQ+x31HxR3--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab2ELRU7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 13:20:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60598 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987Ab2ELRU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 13:20:56 -0400
Date: Sat, 12 May 2012 10:20:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.3.6
Message-ID: <20120512172052.GA527@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.3.6 kernel.

All users of the 3.3 kernel series must upgrade.

The updated 3.3.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.3.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------
 Documentation/networking/ip-sysctl.txt                       |    4=20
 Makefile                                                     |    2=20
 arch/arm/kernel/ptrace.c                                     |   24 -
 arch/arm/kernel/smp.c                                        |    4=20
 arch/arm/kernel/sys_arm.c                                    |    2=20
 arch/arm/mach-omap2/include/mach/ctrl_module_pad_core_44xx.h |    8=20
 arch/arm/mach-orion5x/mpp.h                                  |    4=20
 arch/arm/mm/cache-l2x0.c                                     |   25 +-
 arch/ia64/kvm/kvm-ia64.c                                     |    5=20
 arch/s390/kvm/intercept.c                                    |   20 -
 arch/s390/kvm/kvm-s390.c                                     |    2=20
 arch/x86/boot/compressed/relocs.c                            |    2=20
 arch/x86/kernel/setup_percpu.c                               |   14 +
 arch/x86/kvm/pmu.c                                           |    2=20
 arch/x86/kvm/vmx.c                                           |   10=20
 arch/x86/kvm/x86.c                                           |   19 +
 arch/x86/xen/enlighten.c                                     |    7=20
 arch/x86/xen/mmu.c                                           |    7=20
 drivers/block/mtip32xx/Kconfig                               |    2=20
 drivers/block/mtip32xx/mtip32xx.c                            |   34 +-
 drivers/gpu/drm/i915/intel_hdmi.c                            |    2=20
 drivers/gpu/drm/i915/intel_ringbuffer.c                      |    9=20
 drivers/gpu/drm/i915/intel_sdvo.c                            |    6=20
 drivers/net/ethernet/broadcom/tg3.c                          |   18 +
 drivers/net/ethernet/intel/e1000/e1000_main.c                |   35 +-
 drivers/net/ethernet/marvell/sky2.c                          |   31 +-
 drivers/net/ethernet/marvell/sky2.h                          |    1=20
 drivers/net/ethernet/sun/sungem.c                            |    2=20
 drivers/net/usb/asix.c                                       |    4=20
 drivers/net/usb/smsc95xx.c                                   |    2=20
 drivers/platform/x86/sony-laptop.c                           |    2=20
 drivers/regulator/max8997.c                                  |    2=20
 drivers/usb/gadget/udc-core.c                                |    4=20
 fs/cifs/cifssmb.c                                            |    6=20
 fs/hugetlbfs/inode.c                                         |   54 +---
 fs/nfsd/nfs4proc.c                                           |    8=20
 fs/nfsd/vfs.c                                                |    2=20
 include/asm-generic/statfs.h                                 |    2=20
 include/linux/hugetlb.h                                      |   14 -
 include/linux/kvm_host.h                                     |    7=20
 include/linux/netdevice.h                                    |   50 ++--
 include/linux/seqlock.h                                      |    2=20
 mm/hugetlb.c                                                 |  135 ++++++=
++---
 net/core/dev.c                                               |   20 +
 net/ipv4/tcp.c                                               |    9=20
 net/ipv4/tcp_input.c                                         |   11=20
 net/l2tp/l2tp_ip.c                                           |    3=20
 net/sched/sch_netem.c                                        |    6=20
 sound/soc/codecs/tlv320aic23.c                               |    4=20
 sound/soc/soc-core.c                                         |    6=20
 virt/kvm/iommu.c                                             |   23 +
 virt/kvm/kvm_main.c                                          |   23 +
 52 files changed, 461 insertions(+), 239 deletions(-)
Alan Stern (1):
      usb: gadget: udc-core: fix incompatibility with dummy-hcd

Alex Williamson (1):
      KVM: lock slots_lock around device assignment

Alexander Duyck (2):
      net: Add memory barriers to prevent possible race in byte queue limits
      net: Fix issue with netdev_tx_reset_queue not resetting queue from XO=
FF state

Archit Taneja (1):
      ARM: OMAP: Revert "ARM: OMAP: ctrl: Fix CONTROL_DSIPHY register field=
s"

Asai Thambi S P (1):
      mtip32xx: fix incorrect value set for drv_cleanup_done, and re-initia=
lize and start port in mtip_restart_port()

Avi Kivity (3):
      KVM: Ensure all vcpus are consistent with in-kernel irqchip settings
      KVM: VMX: Fix delayed load of shared MSRs
      KVM: VMX: Fix kvm_set_shared_msr() called in preemptible context

Axel Lin (1):
      regulator: Fix the logic to ensure new voltage setting in valid range

Ben Hutchings (1):
      ARM: orion5x: Fix GPIO enable bits for MPP9

Christian Borntraeger (1):
      KVM: s390: Sanitize fpc registers for KVM_SET_FPU

Colin Cross (1):
      ARM: 7414/1: SMP: prevent use of the console when using idmap_pgd

Daniel Vetter (2):
      drm/i915: disable sdvo hotplug on i945g/gm
      drm/i915: Do no set Stencil Cache eviction LRA w/a on gen7+

David Gibson (1):
      hugepages: fix use after free bug in "quota" handling

David Vrabel (1):
      xen/pci: don't use PCI BIOS service for configuration space accesses

Eric B=E9nard (1):
      ASoC: tlv312aic23: unbreak resume

Eric Dumazet (2):
      netem: fix possible skb leak
      tcp: change tcp_adv_win_scale and tcp_rmem[2]

Eric W. Biederman (1):
      net: In unregister_netdevice_notifier unregister the netdevices.

Felipe Balbi (1):
      usb: gadget: udc-core: fix wrong call order

Gerard Lledo (1):
      sungem: Fix WakeOnLan

Gleb Natapov (1):
      KVM: x86 emulator: correctly mask pmc index bits in RDPMC instruction=
 emulation

Greg Kroah-Hartman (2):
      block: mtip32xx: remove HOTPLUG_PCI_PCIE dependancy
      Linux 3.3.6

H. Peter Anvin (1):
      asm-generic: Use __BITS_PER_LONG in statfs.h

Ingo van Lil (1):
      asix: Fix tx transfer padding for full-speed USB

J. Bruce Fields (1):
      nfsd: don't fail unchecked creates of non-special files

Jens Freimann (1):
      KVM: s390: do store status after handling STOP_ON_STOP bit

Jiri Pirko (1):
      e1000: fix vlan processing regression

Josh Boyer (1):
      sony-laptop: Enable keyboard backlight by default

Konrad Rzeszutek Wilk (1):
      xen/pte: Fix crashes when trying to see non-existent PGD/PMD/PUD/PTEs

Kusanagi Kouichi (1):
      x86, relocs: Remove an unused variable

Linus Torvalds (1):
      Fix __read_seqcount_begin() to use ACCESS_ONCE for sequence value read

Marcelo Tosatti (1):
      KVM: VMX: vmx_set_cr0 expects kvm->srcu locked

Matt Carlson (1):
      tg3: Avoid panic from reserved statblk field access

Nadav Har'El (1):
      KVM: nVMX: Fix erroneous exception bitmap check

Paolo Pisati (1):
      smsc95xx: mark link down on startup and let PHY interrupt deal with c=
arrier changes

Paulo Zanoni (1):
      drm/i915: enable dip before writing data on gen4

Richard Zhao (1):
      ASoC: core: check of_property_count_strings failure

Ryosuke Saito (1):
      mtip32xx: fix error handling in mtip_init()

Sasha Levin (1):
      net: l2tp: unlock socket lock before returning from l2tp_ip_sendmsg

Stefan Metzmacher (1):
      fs/cifs: fix parsing of dfs referrals

Takuya Yoshikawa (2):
      KVM: Fix write protection race during dirty logging
      KVM: mmu_notifier: Flush TLBs before releasing mmu_lock

Tejun Heo (1):
      percpu, x86: don't use PMD_SIZE as embedded atom_size on 32bit

Tim Bird (1):
      ARM: 7410/1: Add extra clobber registers for assembly in kernel_execve

Will Deacon (4):
      ARM: 7411/1: audit: fix treatment of saved ip register during syscall=
 tracing
      ARM: 7412/1: audit: use only AUDIT_ARCH_ARM regardless of endianness
      ARM: 7397/1: l2x0: only apply workaround for erratum #753970 on PL310
      ARM: 7398/1: l2x0: only write to debug registers on PL310

Yuchung Cheng (1):
      tcp: fix infinite cwnd in tcp_complete_cwr()

stephen hemminger (2):
      sky2: propogate rx hash when packet is copied
      sky2: fix receive length error in mixed non-VLAN/VLAN traffic


--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPrpv0AAoJEDjbvchgkmk+74IP/2f3nOQn2p8FKNovfpTWW6Vu
5ZQf7Hgg4U1gZV+QMzmXzBGBBKyLDbavWSUyFTMiOds0GIyG/5lzFJVd9ZHdBwaZ
LtROMJxK3uZajNmsFJkDTJu6BKkbWkdW92Bipv5afsSKd/OBS4fmG7DtgIBKza3e
rWIzXl2ZxWkvJ9OaWWDn9uAP9SvOYwqgJjDvF1auQiuANKcXxVtRYQ7w+Em9Ou0k
7ptN8LpPqv07JdkKyS9Y4Ql4wB0E3ayDUVaL0xps6x9BNGUV1jovKcXmj9Uybv8/
ThtCgyu/6VzI5Tr0efwfS15DsRlLwg5yfuodGyXj9hKFHnhZH2QghYq+ofFotErF
X4X3SoR0syGzZAyWQ2s9t/a7G9oDw7UJI0iGcvFoIX7K6073eMXZssZ8hFJH7644
bYyDSBJXlWJSaZoaAuJiKyITJz05n1RpY4WZCiUBw2bGTrACXK67yze36rBMwcdr
Z3sR/QGkPBDWWY5Lh9ukc2Tre6hAP7DHOwYzvtX+ecJ4aJGqN77jLuZG+zEIUQ90
jm9Wv99vI6zuffwouiEBVXkuDlVHJqr71nOgTdJC6gwjkJdvDVIjsSeYov5zatOY
6z0vK/ORvOj8xZxqsVi27ATx7ugqhwIghFZNTwinsRPYmZ3AM0T0SU3z8nrMGFwj
EB/4oevagVTo0u+jhqBc
=lDTM
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--

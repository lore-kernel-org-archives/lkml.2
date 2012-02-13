Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757670Ab2BMT1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 14:27:42 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:38900 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754727Ab2BMT1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 14:27:39 -0500
X-Sasl-enc: /sve1GVVIQL+53y8q8SXi4YgZ7HWkEiC/fR5xc2gjE6Y 1329161257
Date: Mon, 13 Feb 2012 11:24:46 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.0.21
Message-ID: <20120213192446.GA28247@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.21 kernel.

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

 Makefile                                       |    2=20
 arch/arm/kernel/ptrace.c                       |    8 -
 arch/arm/kernel/signal.c                       |    5=20
 arch/arm/mach-omap2/gpmc.c                     |    6 +
 drivers/cpufreq/powernow-k8.c                  |   30 +++--
 drivers/dma/at_hdmac.c                         |    4=20
 drivers/dma/at_hdmac_regs.h                    |   17 +--
 drivers/firewire/ohci.c                        |    6 -
 drivers/gpu/drm/i915/i915_drv.h                |    2=20
 drivers/gpu/drm/i915/i915_irq.c                |   13 +-
 drivers/gpu/drm/i915/i915_suspend.c            |    4=20
 drivers/gpu/drm/i915/intel_dp.c                |    1=20
 drivers/gpu/drm/i915/intel_hdmi.c              |    8 +
 drivers/gpu/drm/i915/intel_tv.c                |   16 +--
 drivers/gpu/drm/nouveau/nouveau_gem.c          |   23 ++++
 drivers/gpu/drm/radeon/atombios_crtc.c         |    4=20
 drivers/gpu/drm/radeon/radeon_device.c         |    4=20
 drivers/hwmon/w83627ehf.c                      |   26 ++++-
 drivers/infiniband/core/addr.c                 |   16 +--
 drivers/infiniband/hw/cxgb3/iwch_cm.c          |   16 ++-
 drivers/infiniband/hw/cxgb4/cm.c               |   46 ++++----
 drivers/infiniband/hw/mlx4/mad.c               |    7 -
 drivers/infiniband/hw/mlx4/qp.c                |    2=20
 drivers/infiniband/hw/nes/nes_cm.c             |    8 -
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |   59 +++++++----
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |   24 +++-
 drivers/misc/cb710/core.c                      |    1=20
 drivers/net/cxgb3/cxgb3_offload.c              |    8 -
 drivers/pcmcia/ds.c                            |    4=20
 drivers/s390/net/qeth_l3_main.c                |   25 +++-
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c             |    2=20
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c             |    2=20
 drivers/scsi/cxgbi/libcxgbi.c                  |    4=20
 drivers/staging/asus_oled/asus_oled.c          |   13 +-
 drivers/staging/rtl8712/usb_intf.c             |    1=20
 drivers/target/target_core_pr.c                |    5=20
 drivers/target/target_core_transport.c         |    8 -
 drivers/tty/vt/vt_ioctl.c                      |    1=20
 drivers/usb/gadget/f_loopback.c                |    2=20
 drivers/usb/host/pci-quirks.c                  |    6 +
 drivers/usb/serial/ftdi_sio.c                  |    1=20
 drivers/usb/serial/ftdi_sio_ids.h              |    7 +
 drivers/usb/serial/option.c                    |  129 ++++++++++++++++++++=
++++-
 drivers/video/atmel_lcdfb.c                    |    2=20
 fs/cifs/sess.c                                 |    7 -
 fs/ecryptfs/read_write.c                       |    4=20
 fs/proc/base.c                                 |  106 ++++++++------------
 fs/udf/super.c                                 |    6 +
 include/net/arp.h                              |    1=20
 include/net/dst.h                              |   27 ++++-
 kernel/kprobes.c                               |    6 -
 kernel/panic.c                                 |   12 +-
 kernel/sched_rt.c                              |    5=20
 mm/compaction.c                                |   24 ++++
 mm/filemap.c                                   |    8 -
 mm/filemap_xip.c                               |    7 +
 mm/huge_memory.c                               |    4=20
 mm/swap.c                                      |    2=20
 net/atm/clip.c                                 |   16 +--
 net/bridge/br_netfilter.c                      |    6 -
 net/core/dst.c                                 |   15 +-
 net/core/neighbour.c                           |   19 ++-
 net/decnet/dn_neigh.c                          |    8 -
 net/decnet/dn_route.c                          |   18 +--
 net/ipv4/arp.c                                 |   28 +++--
 net/ipv4/ip_gre.c                              |    2=20
 net/ipv4/ip_output.c                           |   22 +++-
 net/ipv4/route.c                               |   31 +++---
 net/ipv6/addrconf.c                            |    2=20
 net/ipv6/ip6_fib.c                             |    2=20
 net/ipv6/ip6_output.c                          |   40 ++++++-
 net/ipv6/ndisc.c                               |    4=20
 net/ipv6/route.c                               |   59 +++++++----
 net/ipv6/sit.c                                 |    4=20
 net/sched/sch_teql.c                           |   31 +++---
 net/xfrm/xfrm_policy.c                         |    2=20
 sound/pci/hda/hda_codec.c                      |    2=20
 sound/soc/codecs/wm8962.c                      |    6 -
 sound/soc/codecs/wm_hubs.c                     |   18 ++-
 sound/soc/soc-core.c                           |   18 ++-
 80 files changed, 797 insertions(+), 353 deletions(-)

Andreas Herrmann (2):
      powernow-k8: Avoid Pstate MSR accesses on systems supporting CPB
      powernow-k8: Fix indexing issue

Axel Lin (1):
      mmc: cb710 core: Add missing spin_lock_init for irq_lock of struct cb=
710_chip

Ben Skeggs (1):
      drm/nouveau/gem: fix fence_sync race / oops

Carsten Otte (1):
      mm/filemap_xip.c: fix race condition in xip_file_fault()

Chanho Min (1):
      sched/rt: Fix task stack corruption under __ARCH_WANT_INTERRUPTS_ON_C=
TXSW

Clemens Ladisch (1):
      firewire: ohci: add reset packet quirk for SB Audigy

Daniel Vetter (1):
      drm/i915: check ACTHD of all rings

Dave Martin (1):
      ARM: 7307/1: vfp: fix ptrace regset modification race

David Henningsson (1):
      ALSA: HDA: Fix duplicated output to more than one codec

Eric Dumazet (1):
      net: fix NULL dereferences in check_peer_redir()

Eugeni Dodonov (1):
      drm/i915: handle 3rd pipe

Greg Kroah-Hartman (1):
      Linux 3.0.21

Guenter Roeck (1):
      hwmon: (w83627ehf) Fix number of fans for NCT6776F

Hubert Feurstein (1):
      atmel_lcdfb: fix usage of CONTRAST_CTR in suspend/resume

Hugh Dickins (1):
      mm: fix UP THP spin_is_locked BUGs

Jack Morgenstein (1):
      IB/mlx4: pass SMP vendor-specific attribute MADs to firmware

Jan Kara (1):
      udf: Mark LVID buffer as uptodate before marking it dirty

Jayachandran C (1):
      usb: Skip PCI USB quirk handling for Netlogic XLP

Jiang Liu (1):
      kprobes: fix a memory leak in function pre_handler_kretprobe()

Larry Finger (1):
      staging: r8712u: Add new Sitecom UsB ID

Li Wang (1):
      eCryptfs: Infinite loop due to overflow in ecryptfs_write()

Marco Sanvido (2):
      target: Use correct preempted registration sense code
      target: Allow PERSISTENT RESERVE IN for non-reservation holder

Mark Brown (4):
      ASoC: wm_hubs: Enable line out VMID buffer for single ended line outp=
uts
      ASoC: Ensure we generate a driver name
      ASoC: wm_hubs: Fix routing of input PGAs to line output mixer
      ASoC: wm_hubs: Correct line input to line output 2 paths

Mel Gorman (2):
      mm: compaction: check pfn_valid when entering a new MAX_ORDER_NR_PAGE=
S block during isolation for migration
      mm: compaction: check for overlapping nodes during isolation for migr=
ation

Michel D=E4nzer (1):
      drm/radeon: Set DESKTOP_HEIGHT register to the framebuffer (not mode)=
 height.

Milan Kocian (1):
      USB: usbserial: add new PID number (0xa951) to the ftdi driver

Nikolaus Voss (1):
      at_hdmac: bugfix for enabling channel irq

Oleg Nesterov (3):
      proc: mem_release() should check mm !=3D NULL
      proc: unify mem_read() and mem_write()
      proc: make sure mem_open() doesn't pin the target's memory

Pekka Paalanen (2):
      Staging: asus_oled: fix image processing
      Staging: asus_oled: fix NULL-ptr crash on unloading

Peter Zijlstra (1):
      lockdep, bug: Exclude TAINT_FIRMWARE_WORKAROUND from disabling lockdep

Rodrigo Vivi (1):
      drm/i915: Fix TV Out refresh rate.

Roland Dreier (1):
      target: Correct sense key for INVALID FIELD IN {PARAMETER LIST,CDB}

Rui li (1):
      USB: add new zte 3g-dongle's pid to option.c

Russell King (1):
      pcmcia: fix socket refcount decrementing on each resume

Samuel Thibault (1):
      drivers/tty/vt/vt_ioctl.c: fix KDFONTOP 32bit compatibility layer

Seth Forshee (1):
      drm/radeon/kms: disable output polling when suspended

Shaohua Li (1):
      readahead: fix pipeline break caused by block plug

Shirish Pargaonkar (1):
      cifs: Fix oops in session setup code for null user mounts

Stefan Richter (1):
      firewire: ohci: disable MSI on Ricoh controllers

Susan Gao (1):
      ASoC: wm8962: Fix word length configuration

Timo Juhani Lindfors (1):
      usb: gadget: zero: fix bug in loopback autoresume handling

UK KIM (1):
      ASoC: wm_hubs: fix wrong bits for LINEOUT2 N/P mixer

Will Deacon (2):
      ARM: 7306/1: vfp: flush thread hwstate before restoring context from =
sigframe
      ARM: 7308/1: vfp: flush thread hwstate before copying ptrace registers

Wu Fengguang (2):
      drm/i915: HDMI hot remove notification to audio driver
      drm/i915: DisplayPort hot remove notification to audio driver

Yegor Yefremov (1):
      ARM: OMAP2+: GPMC: fix device size setup


--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPOWN+AAoJEDjbvchgkmk+qlYQAIE72XWqw5gYm5i/UEot5OJ/
W0OjyF7snUF3Ekl6Cx7pQW8Y2NRTmckWlwM7WpVihkKVhFXxS57lASTOqsMRBiCg
RlSixAL09fNfW7J1/CxsdEyyruJn+MqXPyyCZtSxqqlBQuhov42Y3RcQ5NShLSAo
co6f2DzvibYiEpSZznDIqBssuQVjNUPQRMWhNm+wEbS6lNC2RDdaCeSBpcuLWuU2
Q5+bLgUTMRR9gsEMHzPA4mg1dnGeriw3q8f0a+ectG78hrEpHwg3JzP3Ed3d4tog
/8/X9xdulmOY7tlZK3W6t8eP7+yje0dUCwn3yeiuRleU2QQN2HdBicAhjRzMyQdK
R8AYAiZEwGPt1GwvZrMhh9DzETTqvZIUZ+CktQGhjgAXSSm8rADzM14FEg1IUuvg
3J7xUJEK6lhzCOKSaESKQmZ7T7LrA2w3qllGmOjDgPovAkdHNEnyXu+hw5x/jFU+
PzStD0tk8uXdSomSTb04fs7tbgyE/HeiSdvvUxkhgnOASUuu7XDoWna5gBGQw6eI
/U2jqewmTqhS0mRj8wk0pUgSHa8ahXZfOJtfdzhPon8FzP7OdNmYy1SzfgNyzprs
P+A+sEnbgIDcVfquQJE0BwDeCVF1ELfMuzLkTeSbyQiEQxiYGIifnCLrF8dl9pxy
hG+nNu6nhYytNn8qUqVI
=Z8Gy
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--

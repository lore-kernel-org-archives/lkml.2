Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934673Ab2JaO3C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 10:29:02 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39014 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934348Ab2JaO25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 10:28:57 -0400
Message-ID: <1351693722.13356.35.camel@deadeye.wl.decadent.org.uk>
Subject: Linux 3.2.33
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Wed, 31 Oct 2012 14:28:42 +0000
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-YgaCDyTB4Ilcw0buios/"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-YgaCDyTB4Ilcw0buios/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.33 kernel.

All users of the 3.2 kernel series should upgrade or risk being turned
into pumpkins.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git

Ben.

------------

 Makefile                                           |    2 +-
 arch/arm/include/asm/vfpmacros.h                   |    4 +-
 arch/arm/kernel/smp.c                              |   14 +-
 arch/mips/kernel/kgdb.c                            |    9 ++
 arch/s390/boot/compressed/vmlinux.lds.S            |    2 +-
 arch/s390/kernel/vmlinux.lds.S                     |    2 +-
 arch/sparc/kernel/perf_event.c                     |   15 +-
 arch/sparc/kernel/sys_sparc_64.c                   |   10 +-
 arch/sparc/kernel/syscalls.S                       |   32 ++--
 arch/sparc/mm/init_64.c                            |   28 +++-
 arch/tile/Makefile                                 |    4 +
 arch/x86/kernel/entry_32.S                         |    8 +-
 arch/x86/kernel/entry_64.S                         |    2 +-
 arch/x86/oprofile/nmi_int.c                        |    2 +-
 arch/x86/xen/enlighten.c                           |   18 ++-
 drivers/acpi/ec.c                                  |   30 +++-
 drivers/bcma/main.c                                |    5 +-
 drivers/char/tpm/tpm.c                             |   21 ++-
 drivers/cpufreq/powernow-k8.c                      |    9 +-
 drivers/edac/amd64_edac.c                          |   11 +-
 drivers/gpu/drm/i915/i915_gem.c                    |    1 +
 drivers/gpu/drm/i915/intel_lvds.c                  |    8 +
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c    |    6 +-
 drivers/hv/channel.c                               |   24 +--
 drivers/md/raid10.c                                |    2 +-
 drivers/media/video/au0828/au0828-video.c          |   12 +-
 drivers/mtd/nand/nand_base.c                       |    9 +-
 drivers/net/ethernet/intel/e1000/e1000_main.c      |   32 ++--
 drivers/net/ethernet/marvell/skge.c                |    7 +
 .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   |  164 ++++++++++------=
----
 drivers/net/wireless/ipw2x00/ipw2200.c             |    2 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c            |   39 +++--
 drivers/pcmcia/pxa2xx_sharpsl.c                    |    2 +-
 drivers/platform/x86/samsung-laptop.c              |   25 ++-
 drivers/rtc/rtc-imxdi.c                            |    2 +
 drivers/scsi/scsi_debug.c                          |    3 +-
 drivers/staging/comedi/drivers/amplc_pc236.c       |    2 +-
 drivers/staging/hv/storvsc_drv.c                   |    5 +
 drivers/usb/class/cdc-acm.c                        |   25 ++-
 drivers/usb/core/hub.c                             |    7 +-
 drivers/usb/host/pci-quirks.c                      |    9 +-
 drivers/usb/host/xhci-ring.c                       |   11 ++
 drivers/usb/host/xhci.c                            |    3 +-
 drivers/usb/serial/mct_u232.c                      |   14 +-
 drivers/usb/serial/mos7840.c                       |   30 +---
 drivers/usb/serial/opticon.c                       |   11 +-
 drivers/usb/serial/option.c                        |   84 +++++++---
 drivers/usb/serial/sierra.c                        |   26 +++-
 drivers/usb/serial/whiteheat.c                     |    1 +
 drivers/usb/storage/unusual_devs.h                 |    6 +
 drivers/vhost/net.c                                |    3 +-
 drivers/video/udlfb.c                              |    2 +-
 drivers/video/via/via_clock.c                      |   19 +++
 fs/ceph/export.c                                   |   18 ++-
 fs/compat_ioctl.c                                  |    2 +
 fs/exec.c                                          |    2 +-
 fs/ext4/extents.c                                  |   57 +++++--
 fs/gfs2/export.c                                   |    4 +
 fs/isofs/export.c                                  |    2 +-
 fs/jbd/commit.c                                    |   45 ++++--
 fs/jbd/transaction.c                               |   64 +++++---
 fs/lockd/clntxdr.c                                 |    2 +-
 fs/lockd/mon.c                                     |    4 +-
 fs/lockd/svcproc.c                                 |    3 +-
 fs/nfsd/nfs4state.c                                |    1 +
 fs/proc/stat.c                                     |   14 +-
 fs/reiserfs/inode.c                                |    6 +-
 fs/sysfs/dir.c                                     |   16 +-
 fs/xfs/xfs_export.c                                |    3 +
 include/linux/if_vlan.h                            |    8 +-
 include/linux/mtd/nand.h                           |    3 -
 include/linux/netfilter/xt_set.h                   |    4 +-
 include/net/netfilter/nf_conntrack_ecache.h        |    1 +
 kernel/cgroup.c                                    |    3 +-
 kernel/module.c                                    |    4 +
 kernel/sys.c                                       |   12 +-
 kernel/time/timekeeping.c                          |    2 +-
 kernel/timer.c                                     |   10 +-
 lib/genalloc.c                                     |    2 +-
 mm/rmap.c                                          |   21 ++-
 mm/shmem.c                                         |    6 +-
 net/8021q/vlan_core.c                              |   10 +-
 net/bluetooth/smp.c                                |    6 +-
 net/core/dev.c                                     |    7 +-
 net/core/neighbour.c                               |    6 +-
 net/core/pktgen.c                                  |    2 +-
 net/ipv4/tcp_ipv4.c                                |    7 +-
 net/ipv6/tcp_ipv6.c                                |    3 +-
 net/mac80211/wpa.c                                 |    3 +-
 net/netfilter/nf_conntrack_core.c                  |   16 +-
 net/rds/send.c                                     |    2 +-
 net/sunrpc/cache.c                                 |    4 +-
 net/sunrpc/xprtsock.c                              |   42 ++---
 sound/pci/ac97/ac97_codec.c                        |    2 +
 sound/pci/emu10k1/emu10k1_main.c                   |    9 ++
 sound/pci/hda/patch_cirrus.c                       |    4 +-
 sound/pci/hda/patch_conexant.c                     |    4 +-
 sound/pci/hda/patch_realtek.c                      |    7 +-
 usr/gen_init_cpio.c                                |   43 ++---
 99 files changed, 845 insertions(+), 475 deletions(-)

Al Viro (1):
      sparc64: fix ptrace interaction with force_successful_syscall_return(=
)

Alexander Holler (1):
      video/udlfb: fix line counting in fb_write

Alexey Kuznetsov (1):
      tcp: resets are misrouted

Alexis R. Cortes (1):
      usb: host: xhci: New system added for Compliance Mode Patch on SN65LV=
PE502CP

Amerigo Wang (1):
      pktgen: fix crash when generating IPv6 packets

Andreas Herrmann (1):
      cpufreq / powernow-k8: Remove usage of smp_processor_id() in preempti=
ble code

Andrew Morton (1):
      amd64_edac:__amd64_set_scrub_rate(): avoid overindexing scrubrates[]

Anisse Astier (2):
      ehci: fix Lucid nohandoff pci quirk to be more generic with BIOS vers=
ions
      ehci: Add yet-another Lucid nohandoff pci quirk

Arnd Bergmann (1):
      pcmcia: sharpsl: don't discard sharpsl_pcmcia_ops

Ben Hutchings (3):
      samsung-laptop: make the dmi check less strict (part 2)
      Revert "lockd: use rpc client's cl_nodename for id encoding"
      Linux 3.2.33

Bj=C3=B8rn Mork (2):
      USB: option: blacklist net interface on ZTE devices
      USB: option: add more ZTE devices

Brian Norris (1):
      mtd: nand: allow NAND_NO_SUBPAGE_WRITE to be set from driver

Bryan Schumaker (1):
      SUNRPC: Set alloc_slot for backchannel tcp ops

Chris Metcalf (1):
      arch/tile: avoid generating .eh_frame information in modules

Corentin Chary (1):
      samsung-laptop: don't handle backlight if handled by acpi/video

Daisuke Nishimura (1):
      cgroup: notify_on_release may not be triggered in some cases

Dan Carpenter (3):
      timekeeping: Cast raw_interval to u64 to avoid shift overflow
      md/raid10: use correct limit variable
      oprofile, x86: Fix wrapping bug in op_x86_get_ctrl()

Daniel Drake (1):
      viafb: don't touch clock state on OLPC XO-1.5

Daniel Vetter (1):
      drm/i915: don't pwrite tiled objects through the gtt

David Henningsson (3):
      ALSA: hda - Fix oops caused by recent commit "Fix internal mic for Le=
novo Ideapad U300s"
      ALSA: hda - do not detect jack on internal speakers for Realtek
      ALSA: hda - Always check array bounds in alc_get_line_out_pfx

David S. Miller (3):
      sparc64: Like x86 we should check current->mm during perf backtrace g=
eneration.
      sparc64: Fix bit twiddling in sparc_pmu_enable_event().
      sparc64: Be less verbose during vmemmap population.

David Vrabel (1):
      xen/x86: don't corrupt %eip when returning from a signal handler

Devin Heitmueller (1):
      au0828: fix case where STREAMOFF being called on stopped stream cause=
s BUG()

Dmitry Monakhov (1):
      ext4: race-condition protection for ext4_convert_unwritten_extents_en=
dio

Egbert Eich (1):
      drm/radeon: Don't destroy I2C Bus Rec in radeon_ext_tmds_enc_destroy(=
).

Felix Fietkau (1):
      Revert "ath9k_hw: Updated AR9003 tx gain table for 5GHz"

Feng Tang (2):
      ACPI: EC: Make the GPE storm threshold a module parameter
      ACPI: EC: Add a quirk for CLEVO M720T/M730T laptop

Florian Zumbiehl (1):
      vlan: don't deliver frames for unknown vlans to protocols

Geert Uytterhoeven (1):
      sysfs: sysfs_pathname/sysfs_add_one: Use strlcat() instead of strcat(=
)

Graham Gower (1):
      skge: Add DMA mask quirk for Marvell 88E8001 on ASUS P5NSLI motherboa=
rd

Heiko Carstens (1):
      s390: fix linker script for 31 bit builds

Hildner, Christian (1):
      timers: Fix endless looping between cascade() and internal_add_timer(=
)

Hugh Dickins (1):
      tmpfs,ceph,gfs2,isofs,reiserfs,xfs: fix fh_len checking

Ian Abbott (1):
      staging: comedi: amplc_pc236: fix invalid register access during deta=
ch

J. Bruce Fields (1):
      nfsd4: fix nfs4 stateid leak

Jan Engelhardt (1):
      netfilter: ipset: avoid use of kernel-only types

Jan Kara (2):
      jbd: Fix assertion failure in commit code due to lacking transaction =
credits
      mm: fix XFS oops due to dirty pages without buffers on s390

Jan Luebbe (1):
      drivers/rtc/rtc-imxdi.c: add missing spin lock initialization

Jason Wessel (1):
      mips,kgdb: fix recursive page fault with CONFIG_KPROBES

Jean-Christian de Rivaz (1):
      Add CDC-ACM support for the CX93010-2x UCMxx USB Modem

Jiri Kosina (1):
      sparc64: do not clobber personality flags in sys_sparc64_personality(=
)

Jiri Pirko (1):
      e1000: fix vlan processing regression

Johan Hedberg (1):
      Bluetooth: SMP: Fix setting unknown auth_req bits

Johan Hovold (10):
      USB: whiteheat: fix memory leak in error path
      USB: opticon: fix DMA from stack
      USB: opticon: fix memory leak in error path
      USB: mct_u232: fix broken close
      USB: sierra: fix memory leak in attach error path
      USB: sierra: fix memory leak in probe error path
      USB: mos7840: fix urb leak at release
      USB: mos7840: fix port-device leak in error path
      USB: mos7840: remove NULL-urb submission
      USB: mos7840: remove invalid disconnect handling

Johannes Berg (1):
      iwlwifi: fix 6000 series channel switch command

K. Y. Srinivasan (2):
      storvsc: Account for in-transit packets in the RESET path
      Drivers: hv: Cleanup error handling in vmbus_open()

Kees Cook (3):
      kernel/sys.c: fix stack memory content leak via UNAME26
      gen_init_cpio: avoid stack overflow when expanding
      fs/compat_ioctl.c: VIDEO_SET_SPU_PALETTE missing error check

Konrad Rzeszutek Wilk (2):
      xen/bootup: allow read_tscp call for Xen PV guests.
      xen/bootup: allow {read|write}_cr8 pvops call.

Lennart Sorensen (1):
      USB: serial: Fix memory leak in sierra_release()

Lukas Czerner (1):
      scsi_debug: Fix off-by-one bug when unmapping region

Matthew Garrett (1):
      module: taint kernel when lve module is loaded

Maxim Kachur (1):
      ALSA: emu10k1: add chip details for E-mu 1010 PCIe card

Michael S. Tsirkin (1):
      vhost: fix mergeable bufs on BE hosts

Michael Shigorin (1):
      usb-storage: add unusual_devs entry for Casio EX-N1 digital camera

Michal Hocko (1):
      nohz: Fix idle ticks in cpu summary line of /proc/stat

Ming Lei (1):
      USB: cdc-acm: fix pipe type of write endpoint

Nicolas Boullis (1):
      usb: acm: fix the computation of the number of data bits

Octavian Purdila (1):
      usb hub: send clear_tt_buffer_complete events when canceling TT clear=
 work

Oleg Nesterov (1):
      freezer: exec should clear PF_NOFREEZE along with PF_KTHREAD

Pablo Neira Ayuso (1):
      netfilter: nf_conntrack: fix racy timer handling with reliable events

Peter Huewe (1):
      tpm: Propagate error from tpm_transmit to fix a timeout hang

Piotr Haber (1):
      bcma: fix unregistration of cores

Russell King (1):
      ARM: vfp: fix saving d16-d31 vfp registers on v6+ kernels

Sarah Sharp (1):
      xhci: Fix potential NULL ptr deref in command cancellation.

Sasha Levin (1):
      SUNRPC: Prevent kernel stack corruption on long values of flush

Sjoerd Simons (1):
      drm/i915: no lvds quirk for Zotac ZDBOX SD ID12/ID13

Stanislav Yakovlev (1):
      net/wireless: ipw2200: Fix panic occurring in ipw_handle_promiscuous_=
tx()

Stanislaw Gruszka (1):
      mac80211: check if key has TKIP type before updating IV

Stef=C3=A1n Freyr (1):
      ALSA: hda - add dock support for Thinkpad T430

Takashi Iwai (2):
      ALSA: hda - Fix memory leaks at error path in patch_cirrus.c
      ALSA: ac97 - Fix missing NULL check in snd_ac97_cvol_new()

Thadeu Lima de Souza Cascardo (1):
      genalloc: stop crashing the system when destroying a pool

Trond Myklebust (5):
      NLM: nlm_lookup_file() may return NLMv4-specific error codes
      SUNRPC: Clear the connect flag when socket state is TCP_CLOSE_WAIT
      Revert "SUNRPC: Ensure we close the socket on EPIPE errors too..."
      SUNRPC: Prevent races in xs_abort_connection()
      SUNRPC: Get rid of the xs_error_report socket callback

Will Deacon (1):
      ARM: 7559/1: smp: switch away from the idmap before updating init_mm.=
mm_count

jeff.liu (1):
      RDS: fix rds-ping spinlock recursion

ramesh.nagappa@gmail.com (1):
      net: Fix skb_under_panic oops in neigh_resolve_output


--=20
Ben Hutchings
I'm always amazed by the number of people who take up solipsism because
they heard someone else explain it. - E*Borg on alt.fan.pratchett

--=-YgaCDyTB4Ilcw0buios/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUJE1mue/yOyVhhEJAQrP+w//Uw/ZYM8mld2E61EBXtMZDKFcho2ir+ac
mcE6IfDUSkJCJ0miK5F+VKk1Xb7VFqhb8SPgtnMSYg3F0XiAMgeNeiKwLPZOkO8i
ffwZ/imqSvBsuOsBukmeE2B68rEcJqBb+Ho7974skAtAxf8I/6U/+54YnP96m9ht
0sARecmNHb/Na0KFTFVHZ5Ea3LiZkVSRrGBVqxWvFNlKmvhBVPrUrMh47EW8RBqa
bHEnaAtYuUAQszpJVhetoBh46irexLoRTRuaqGWh/ctKmewwxa2VmUd7U5Q9idrl
jBj/uJ0dCpVUI9mO8hddPPDsYS4yW8TYt4+wBJX4RcK+GI63sSibK/HV6rtdIvvY
ZWWF7Jhr+dZhnHbau0vCE/finqlBEKP3hW2N6quxGfsTRH/nMbxD0x4NyM/WqFaS
1Hz/4O9/9D/lTCQP28pA6PHkqzQeReWdFIE8+pvZtbjZE/AXMC2Q5u3BQdsa+8Qp
MpKVpxIj2va0H+NqZg82ZkZWy/J/o41eNM74xxRsDeiyohX+oxFbDYniWUhddwQG
Ha8Co7DqAdaaAQqZH939YZIYVGCWqIM6h0kkxpQ/kMreUBgi9v1LoYI1oYfLkY/C
uczZX+5Z4I4X+esWkMB5J7TzY41z5Kajr1Ery835FN/P3Nt627QLMwxwWNqRbhQ/
VxvZM2Xv9cg=
=yMYD
-----END PGP SIGNATURE-----

--=-YgaCDyTB4Ilcw0buios/--

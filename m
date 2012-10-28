Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab2J1X0o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:26:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41721 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752851Ab2J1X0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:26:38 -0400
Message-Id: <20121028231536.970033833@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:15:36 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 000/105] 3.2.33-stable review
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.33 release.
There are 105 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Oct 31 00:00:00 UTC 2012.
Anything received after that time might be eaten by ghouls.

A combined patch relative to 3.2.32 will be posted as an additional
response to this.  A shortlog and diffstat can be found below.

Ben.

-------------

Al Viro (1):
      sparc64: fix ptrace interaction with  force_successful_syscall_return()
         [55c2770e413e96871147b9406a9c41fe9bc5209c]

Alexander Holler (1):
      video/udlfb: fix line counting in fb_write
         [b8c4321f3d194469007f5f5f2b34ec278c264a04]

Alexey Kuznetsov (1):
      tcp: resets are misrouted
         [4c67525849e0b7f4bd4fab2487ec9e43ea52ef29]

Alexis R. Cortes (1):
      usb: host: xhci: New system added for Compliance Mode Patch on SN65LVPE502CP
         [470809741a28c3092279f4e1f3f432e534d46068]

Amerigo Wang (1):
      pktgen: fix crash when generating IPv6 packets
         [5aa8b572007c4bca1e6d3dd4c4820f1ae49d6bb2]

Andreas Herrmann (1):
      cpufreq / powernow-k8: Remove usage of smp_processor_id() in preemptible code
         [e4df1cbcc1f329e53a1fff7450b2229e0addff20]

Andrew Morton (1):
      amd64_edac:__amd64_set_scrub_rate(): avoid overindexing scrubrates[]
         [168bfeef7bba3f9784f7540b053e4ac72b769ce9]

Anisse Astier (2):
      ehci: Add yet-another Lucid nohandoff pci quirk
         [8daf8b6086f9d575200cd0aa3797e26137255609]
      ehci: fix Lucid nohandoff pci quirk to be more generic with BIOS versions
         [c323dc023b9501e5d09582ec7efd1d40a9001d99]

Arnd Bergmann (1):
      pcmcia: sharpsl: don't discard sharpsl_pcmcia_ops
         [fdc858a466b738d35d3492bc7cf77b1dac98bf7c]

Ben Hutchings (2):
      Revert "lockd: use rpc client's cl_nodename for id encoding"
         [not upstream; the fix is just not required for 3.2]
      samsung-laptop: make the dmi check less strict (part 2)
         [3be324a94df0c3f032178d04549dbfbf6cccb09a]

Bjørn Mork (2):
      USB: option: add more ZTE devices
         [4b35f1c52943851b310afb09047bfe991ac8f5ae]
      USB: option: blacklist net interface on ZTE devices
         [1452df6f1b7e396d89c2a1fdbdc0e0e839f97671]

Brian Norris (1):
      mtd: nand: allow NAND_NO_SUBPAGE_WRITE to be set from driver
         [bf7a01bf7987b63b121d572b240c132ec44129c4]

Bryan Schumaker (1):
      SUNRPC: Set alloc_slot for backchannel tcp ops
         [84e28a307e376f271505af65a7b7e212dd6f61f4]

Chris Metcalf (1):
      arch/tile: avoid generating .eh_frame information in modules
         [627072b06c362bbe7dc256f618aaa63351f0cfe6]

Christian Hildner (1):
      timers: Fix endless looping between cascade() and internal_add_timer()
         [26cff4e2aa4d666dc6a120ea34336b5057e3e187]

Corentin Chary (1):
      samsung-laptop: don't handle backlight if handled by acpi/video
         [f34cd9ca9320876e9c12764f052004628a03ba2d]

Daisuke Nishimura (1):
      cgroup: notify_on_release may not be triggered in some cases
         [1f5320d5972aa50d3e8d2b227b636b370e608359]

Dan Carpenter (3):
      md/raid10: use correct limit variable
         [91502f099dfc5a1e8812898e26ee280713e1d002]
      oprofile, x86: Fix wrapping bug in op_x86_get_ctrl()
         [44009105081b51417f311f4c3be0061870b6b8ed]
      timekeeping: Cast raw_interval to u64 to avoid shift overflow
         [5b3900cd409466c0070b234d941650685ad0c791]

Daniel Drake (1):
      viafb: don't touch clock state on OLPC XO-1.5
         [012a1211845eab69a5488d59eb87d24cc518c627]

Daniel Vetter (1):
      drm/i915: don't pwrite tiled objects through the gtt
         [c07496fa61f4c5cb2addd1c57f6b22fcaeea2eeb]

David Henningsson (3):
      ALSA: hda - Always check array bounds in alc_get_line_out_pfx
         [71aa5ebe36a4e936eff281b375a4707b6a8320f2]
      ALSA: hda - Fix oops caused by recent commit "Fix internal mic for Lenovo Ideapad U300s"
         [83b0c6ba999643ee8ad6329f26e1cdc870e1a920]
      ALSA: hda - do not detect jack on internal speakers for Realtek
         [f7f4b2322bf7b8c5929b7eb5a667091f32592580]

David S. Miller (3):
      sparc64: Be less verbose during vmemmap population.
         [2856cc2e4d0852c3ddaae9dcb19cb9396512eb08]
      sparc64: Fix bit twiddling in sparc_pmu_enable_event().
         [e793d8c6740f8fe704fa216e95685f4d92c4c4b9]
      sparc64: Like x86 we should check current->mm during  perf backtrace generation.
         [08280e6c4c2e8049ac61d9e8e3536ec1df629c0d]

David Vrabel (1):
      xen/x86: don't corrupt %eip when returning from a signal handler
         [a349e23d1cf746f8bdc603dcc61fae9ee4a695f6]

Devin Heitmueller (1):
      [media] au0828: fix case where STREAMOFF being called on stopped stream causes BUG()
         [a595c1ce4c9d572cf53513570b9f1a263d7867f2]

Dmitry Monakhov (1):
      ext4: race-condition protection for ext4_convert_unwritten_extents_endio
         [dee1f973ca341c266229faa5a1a5bb268bed3531]

Egbert Eich (1):
      drm/radeon: Don't destroy I2C Bus Rec in radeon_ext_tmds_enc_destroy().
         [082918471139b07964967cfe5f70230909c82ae1]

Fabio Porcedda (1):
      usb: gadget: at91_udc: fix dt support
         [9c6d196d5aa35e07482f23c3e37755e7a82140e0]

Felix Fietkau (1):
      Revert "ath9k_hw: Updated AR9003 tx gain table for 5GHz"
         [73b26df5fa1a6245d6fc982362518b620bc7c2fe]

Feng Tang (2):
      ACPI: EC: Add a quirk for CLEVO M720T/M730T laptop
         [67bfa9b60bd689601554526d144b21d529f78a09]
      ACPI: EC: Make the GPE storm threshold a module parameter
         [a520d52e99b14ba7db135e916348f12f2a6e09be]

Florian Zumbiehl (1):
      vlan: don't deliver frames for unknown vlans to  protocols
         [48cc32d38a52d0b68f91a171a8d00531edc6a46e]

Geert Uytterhoeven (1):
      sysfs: sysfs_pathname/sysfs_add_one: Use strlcat() instead of strcat()
         [66081a72517a131430dcf986775f3268aafcb546]

Graham Gower (1):
      skge: Add DMA mask quirk for Marvell 88E8001 on ASUS  P5NSLI motherboard
         [a2af139ff1cd85df586690ff626619ab1ee88b0a]

Heiko Carstens (1):
      s390: fix linker script for 31 bit builds
         [c985cb37f1b39c2c8035af741a2a0b79f1fbaca7]

Hugh Dickins (1):
      tmpfs,ceph,gfs2,isofs,reiserfs,xfs: fix fh_len checking
         [35c2a7f4908d404c9124c2efc6ada4640ca4d5d5]

Ian Abbott (1):
      staging: comedi: amplc_pc236: fix invalid register access during detach
         [aaeb61a97b7159ebe30b18a422d04eeabfa8790b]

J. Bruce Fields (1):
      nfsd4: fix nfs4 stateid leak
         [cf9182e90b2af04245ac4fae497fe73fc71285b4]

Jan Engelhardt (1):
      netfilter: ipset: avoid use of kernel-only types
         [5276e16bb6f35412583518d6f04651dd9dc114be]

Jan Kara (2):
      jbd: Fix assertion failure in commit code due to lacking transaction credits
         [09e05d4805e6c524c1af74e524e5d0528bb3fef3]
      mm: fix XFS oops due to dirty pages without buffers on s390
         [ef5d437f71afdf4afdbab99213add99f4b1318fd]

Jan Luebbe (1):
      drivers/rtc/rtc-imxdi.c: add missing spin lock initialization
         [fee0de7791f967c2c5f0d43eb7b7261761b45e64]

Jason Wessel (1):
      mips,kgdb: fix recursive page fault with CONFIG_KPROBES
         [f0a996eeeda214f4293e234df33b29bec003b536]

Jean-Christian de Rivaz (1):
      Add CDC-ACM support for the CX93010-2x UCMxx USB Modem
         [e7d491a19d3e3aac544070293891a2542ae0c565]

Jeff.Liu (1):
      RDS: fix rds-ping spinlock recursion
         [5175a5e76bbdf20a614fb47ce7a38f0f39e70226]

Jiri Kosina (1):
      sparc64: do not clobber personality flags in  sys_sparc64_personality()
         [a27032eee8cb6e16516f13c8a9752e9d5d4cc430]

Jiri Pirko (1):
      e1000: fix vlan processing regression
         [52f5509fe8ccb607ff9b84ad618f244262336475]

Johan Hedberg (1):
      Bluetooth: SMP: Fix setting unknown auth_req bits
         [065a13e2cc665f6547dc7e8a9d6b6565badf940a]

Johan Hovold (10):
      USB: mct_u232: fix broken close
         [5260e458f5eff269a43e4f1e9c47186c57b88ddb]
      USB: mos7840: fix port-device leak in error path
         [3eb55cc4ed88eee3b5230f66abcdbd2a91639eda]
      USB: mos7840: fix urb leak at release
         [65a4cdbb170e4ec1a7fa0e94936d47e24a17b0e8]
      USB: mos7840: remove NULL-urb submission
         [28c3ae9a8cf45f439c9a0779ebd0256e2ae72813]
      USB: mos7840: remove invalid disconnect handling
         [e681b66f2e19fadbe8a7e2a17900978cb6bc921f]
      USB: opticon: fix DMA from stack
         [ea0dbebffe118724cd4df7d9b071ea8ee48d48f0]
      USB: opticon: fix memory leak in error path
         [acbf0e5263de563e25f7c104868e4490b9e72b13]
      USB: sierra: fix memory leak in attach error path
         [7e41f9bcdd2e813ea2a3c40db291d87ea06b559f]
      USB: sierra: fix memory leak in probe error path
         [084817d79399ab5ccab2f90a148b0369912a8369]
      USB: whiteheat: fix memory leak in error path
         [c129197c99550d356cf5f69b046994dd53cd1b9d]

Johannes Berg (1):
      iwlwifi: fix 6000 series channel switch command
         [8f7b8db6e0557c8437adf9371e020cd89a7e85dc]

K. Y. Srinivasan (2):
      Drivers: hv: Cleanup error handling in vmbus_open()
         [1392550240aaa72ce3a094a38bd23525cd67ce60]
      [SCSI] storvsc: Account for in-transit packets in the RESET path
         [5c1b10ab7f93d24f29b5630286e323d1c5802d5c]

Kees Cook (3):
      fs/compat_ioctl.c: VIDEO_SET_SPU_PALETTE missing error check
         [12176503366885edd542389eed3aaf94be163fdb]
      gen_init_cpio: avoid stack overflow when expanding
         [20f1de659b77364d55d4e7fad2ef657e7730323f]
      kernel/sys.c: fix stack memory content leak via UNAME26
         [2702b1526c7278c4d65d78de209a465d4de2885e]

Konrad Rzeszutek Wilk (2):
      xen/bootup: allow read_tscp call for Xen PV guests.
         [cd0608e71e9757f4dae35bcfb4e88f4d1a03a8ab]
      xen/bootup: allow {read|write}_cr8 pvops call.
         [1a7bbda5b1ab0e02622761305a32dc38735b90b2]

Lennart Sorensen (1):
      USB: serial: Fix memory leak in sierra_release()
         [f7bc5051667b74c3861f79eed98c60d5c3b883f7]

Lukas Czerner (1):
      [SCSI] scsi_debug: Fix off-by-one bug when unmapping region
         [bc977749e967daa56de1922cf4cb38525631c51c]

Matthew Garrett (1):
      module: taint kernel when lve module is loaded
         [c99af3752bb52ba3aece5315279a57a477edfaf1]

Maxim Kachur (1):
      ALSA: emu10k1: add chip details for E-mu 1010 PCIe card
         [10f571d09106c3eb85951896522c9650596eff2e]

Michael S. Tsirkin (1):
      vhost: fix mergeable bufs on BE hosts
         [910a578f7e9400a78a3b13aba0b4d2df16a2cb05]

Michael Shigorin (1):
      usb-storage: add unusual_devs entry for Casio EX-N1 digital camera
         [d7870af7e2e3a91b462075ec1ca669b482215187]

Michal Hocko (1):
      nohz: Fix idle ticks in cpu summary line of /proc/stat
         [7386cdbf2f57ea8cff3c9fde93f206e58b9fe13f]

Ming Lei (1):
      USB: cdc-acm: fix pipe type of write endpoint
         [c5211187f7ff8e8dbff4ebf7c011ac4c0ffe319c]

Nicolas Boullis (1):
      usb: acm: fix the computation of the number of data bits
         [301a29da6e891e7eb95c843af0ecdbe86d01f723]

Octavian Purdila (1):
      usb hub: send clear_tt_buffer_complete events when canceling TT clear work
         [3b6054da68f9b0d5ed6a7ed0f42a79e61904352c]

Oleg Nesterov (1):
      freezer: exec should clear PF_NOFREEZE along with PF_KTHREAD
         [b40a79591ca918e7b91b0d9b6abd5d00f2e88c19]

Pablo Neira Ayuso (1):
      netfilter: nf_conntrack: fix racy timer handling with  reliable events
         [5b423f6a40a0327f9d40bc8b97ce9be266f74368]

Peter Huewe (1):
      tpm: Propagate error from tpm_transmit to fix a timeout hang
         [abce9ac292e13da367bbd22c1f7669f988d931ac]

Piotr Haber (1):
      bcma: fix unregistration of cores
         [1fffa905adffbf0d3767fc978ef09afb830275eb]

Ramesh.Nagappa@Gmail.Com (1):
      net: Fix skb_under_panic oops in neigh_resolve_output
         [e1f165032c8bade3a6bdf546f8faf61fda4dd01c]

Russell King (1):
      ARM: vfp: fix saving d16-d31 vfp registers on v6+ kernels
         [846a136881b8f73c1f74250bf6acfaa309cab1f2]

Sarah Sharp (1):
      xhci: Fix potential NULL ptr deref in command cancellation.
         [43a09f7fb01fa1e091416a2aa49b6c666458c1ee]

Sasha Levin (1):
      SUNRPC: Prevent kernel stack corruption on long values of flush
         [212ba90696ab4884e2025b0b13726d67aadc2cd4]

Sjoerd Simons (1):
      drm/i915: no lvds quirk for Zotac ZDBOX SD ID12/ID13
         [9756fe38d10b2bf90c81dc4d2f17d5632e135364]

Stanislav Yakovlev (1):
      net/wireless: ipw2200: Fix panic occurring in ipw_handle_promiscuous_tx()
         [bf11315eeda510ea4fc1a2bf972d8155d31d89b4]

Stanislaw Gruszka (1):
      mac80211: check if key has TKIP type before updating IV
         [4045f72bcf3c293c7c5932ef001742d8bb5ded76]

Stefán Freyr (1):
      ALSA: hda - add dock support for Thinkpad T430
         [84f98fdf7865fbd35b312eb39ea91e5618c514c7]

Takashi Iwai (2):
      ALSA: ac97 - Fix missing NULL check in snd_ac97_cvol_new()
         [733a48e5ae5bf28b046fad984d458c747cbb8c21]
      ALSA: hda - Fix memory leaks at error path in patch_cirrus.c
         [c5e0b6dbad9b4d18c561af90b384d02373f1c994]

Thadeu Lima de Souza Cascardo (1):
      genalloc: stop crashing the system when destroying a pool
         [eedce141cd2dad8d0cefc5468ef41898949a7031]

Trond Myklebust (5):
      NLM: nlm_lookup_file() may return NLMv4-specific error codes
         [cd0b16c1c3cda12dbed1f8de8f1a9b0591990724]
      Revert "SUNRPC: Ensure we close the socket on EPIPE errors too..."
         [b9d2bb2ee537424a7f855e1f93eed44eb9ee0854]
      SUNRPC: Clear the connect flag when socket state is TCP_CLOSE_WAIT
         [d0bea455dd48da1ecbd04fedf00eb89437455fdc]
      SUNRPC: Get rid of the xs_error_report socket callback
         [f878b657ce8e7d3673afe48110ec208a29e38c4a]
      SUNRPC: Prevent races in xs_abort_connection()
         [4bc1e68ed6a8b59be8a79eb719be515a55c7bc68]

Will Deacon (1):
      ARM: 7559/1: smp: switch away from the idmap before updating init_mm.mm_count
         [5f40b909728ad784eb43aa309d3c4e9bdf050781]

 Makefile                                           |    4 +-
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
 .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   |  164 ++++++++++----------
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
 drivers/usb/gadget/at91_udc.c                      |    2 +-
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
 100 files changed, 847 insertions(+), 477 deletions(-)

-- 
Ben Hutchings
Reality is just a crutch for people who can't handle science fiction.


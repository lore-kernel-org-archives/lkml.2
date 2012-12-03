Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab2LCPAI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 10:00:08 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43532 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755202Ab2LCOfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:35:44 -0500
Message-Id: <20121203143146.549859007@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:31:46 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/89] 3.2.35-stable review
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.35 release.
There are 89 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Dec  5 22:00:00 UTC 2012.
Anything received after that time might be too late.

A combined patch relative to 3.2.34 will be posted as an additional
response to this.  A shortlog and diffstat can be found below.

Ben.

-------------

Al Viro (2):
      [PARISC] fix user-triggerable panic on parisc
         [441a179dafc0f99fc8b3a8268eef66958621082e]
      sparc64: not any error from do_sigaltstack() should fail rt_sigreturn()
         [fae2ae2a900a5c7bb385fe4075f343e7e2d5daa2]

Albert Pool (1):
      rtlwifi: rtl8192cu: Add new USB ID
         [a485e827f07bfdd0762059386e6e787bed6e81ee]

Alex Deucher (2):
      drm/radeon: fix logic error in atombios_encoders.c
         [b9196395c905edec512dfd6690428084228c16ec]
      drm/radeon: properly track the crtc not_enabled case evergreen_mc_stop()
         [804cc4a0ad3a896ca295f771a28c6eb36ced7903]

Andre Przywara (1):
      x86, amd: Disable way access filter on Piledriver CPUs
         [2bbf0a1427c377350f001fbc6260995334739ad7]

Andreas Schwab (1):
      m68k: fix sigset_t accessor functions
         [34fa78b59c52d1db3513db4c1a999db26b2e9ac2]

Arend van Spriel (1):
      brcm80211: smac: only print block-ack timeout message at trace level
         [2b0a53d51b5f263bb581bbdb40ebb9f7e09609b1]

Arik Nemtsov (1):
      mac80211: sync acccess to tx_filtered/ps_tx_buf queues
         [987c285c2ae2e4e32aca3a9b3252d28171c75711]

Artem Bityutskiy (2):
      UBIFS: fix mounting problems after power cuts
         [a28ad42a4a0c6f302f488f26488b8b37c9b30024]
      UBIFS: introduce categorized lprops counter
         [98a1eebda3cb2a84ecf1f219bb3a95769033d1bf]

Ben Hutchings (1):
      intel_idle: enable IVB Xeon support
         [23795e580cad5d6b73d47d51b9074ce3e58bf334]

Benjamin Marzinski (1):
      GFS2: Test bufdata with buffer locked and gfs2_log_lock held
         [96e5d1d3adf56f1c7eeb07258f6a1a0a7ae9c489]

Bing Zhao (2):
      mwifiex: fix system hang issue in cmd timeout error case
         [b1a47aa5e1e159e2cb06d7dfcc17ef5149b09299]
      mwifiex: report error to MMC core if we cannot suspend
         [dd321acddc3be1371263b8c9e6c6f2af89f63d57]

Boris Ostrovsky (1):
      x86, microcode, AMD: Add support for family 16h processors
         [36c46ca4f322a7bf89aad5462a3a1f61713edce7]

Chuansheng Liu (1):
      watchdog: using u64 in get_sample_period()
         [8ffeb9b0e6369135bf03a073514f571ef10606b9]

Clemens Ladisch (1):
      ALSA: ua101, usx2y: fix broken MIDI output
         [e99ddfde6ae0dd2662bb40435696002b590e4057]

Dan Williams (2):
      USB: option: add Alcatel X220/X500D USB IDs
         [c0bc3098871dd9b964f6b45ec1e4d70d87811744]
      USB: option: add Novatel E362 and Dell Wireless 5800 USB IDs
         [fcb21645f1bd86d2be29baf48aa1b298de52ccc7]

Darren Hart (1):
      futex: avoid wake_futex() for a PI futex_q
         [aa10990e028cac3d5e255711fb9fb47e00700e35]

Dave Chinner (1):
      xfs: drop buffer io reference when a bad bio is built
         [d69043c42d8c6414fa28ad18d99973aa6c1c2e24]

Dave Jones (1):
      selinux: fix sel_netnode_insert() suspicious rcu dereference
         [88a693b5c1287be4da937699cb82068ce9db0135]

David Henningsson (1):
      ALSA: hda - Add support for Realtek ALC292
         [af02dde8a609d8d071c4b31a82df811a55690a4a]

Dmitry Torokhov (1):
      Input: i8042 - also perform controller reset when suspending
         [1729ad1f4f9e167ade84ca8b5269695c42351160]

Emil Tantilov (1):
      ixgbe: add support for new 82599 device id
         [9e791e4a04c08868f02cd579a428a7268492e1b4]

Eric Millbrandt (1):
      ASoC: wm8978: pll incorrectly configured when codec is master
         [55c6f4cb6ef49afbb86222c6a3ff85329199c729]

Fenghua Yu (1):
      x86, mce, therm_throt: Don't report power limit and package level thermal throttle events in mcelog
         [29e9bf1841e4f9df13b4992a716fece7087dd237]

H. Peter Anvin (1):
      x86-32: Export kernel_stack_pointer() for modules
         [cb57a2b4cff7edf2a4e32c0163200e9434807e0a]

Hannes Frederic Sowa (1):
      ipv6: setsockopt(IPIPPROTO_IPV6, IPV6_MINHOPCOUNT)  forgot to set return value
         [d4596bad2a713fcd0def492b1960e6d899d5baa8]

Heiko Carstens (1):
      s390/gup: add missing TASK_SIZE check to get_user_pages_fast()
         [d55c4c613fc4d4ad2ba0fc6fa2b57176d420f7e4]

Hugh Dickins (1):
      tmpfs: change final i_blocks BUG to WARNING
         [0f3c42f522dc1ad7e27affc0a4aa8c790bce0a66]

Jacob Keller (1):
      ptp: update adjfreq callback description
         [87f4d7c1d36f44b0822053b7e5dedc31fdd0ab99]

Jacob Shin (2):
      x86, mm: Find_early_table_space based on ranges that are actually being mapped
         [844ab6f993b1d32eb40512503d35ff6ad0c57030]
      x86: Exclude E820_RESERVED regions and memory holes above 4 GB from direct mapping.
         [1bbbbe779aabe1f0768c2bf8f8c0a5583679b54a]

James Bottomley (1):
      [PARISC] fix virtual aliasing issue in get_shared_area()
         [949a05d03490e39e773e8652ccab9157e6f595b4]

Jan Kara (5):
      jbd: Fix lock ordering bug in journal_unmap_buffer()
         [25389bb207987b5774182f763b9fb65ff08761c8]
      reiserfs: Fix lock ordering during remount
         [3bb3e1fc47aca554e7e2cc4deeddc24750987ac2]
      reiserfs: Move quota calls out of write lock
         [7af11686933726e99af22901d622f9e161404e6b]
      reiserfs: Protect reiserfs_quota_on() with write lock
         [b9e06ef2e8706fe669b51f4364e3aeed58639eb2]
      reiserfs: Protect reiserfs_quota_write() with write lock
         [361d94a338a3fd0cee6a4ea32bbc427ba228e628]

Jan Safrata (1):
      usb: use usb_serial_put in usb_serial_probe errors
         [0658a3366db7e27fa32c12e886230bb58c414c92]

Jani Nikula (1):
      drm/i915/sdvo: clean up connectors on intel_sdvo_init() failures
         [d0ddfbd3d1346c1f481ec2289eef350cdba64b42]

Jason Gunthorpe (1):
      ARM: Kirkwood: Update PCI-E fixup
         [1dc831bf53fddcc6443f74a39e72db5bcea4f15d]

Jens Axboe (1):
      dm: fix deadlock with request based dm and queue request_fn recursion
         [a8c32a5c98943d370ea606a2e7dc04717eb92206]

Jianguo Wu (1):
      mm/vmemmap: fix wrong use of virt_to_page
         [ae64ffcac35de0db628ba9631edf8ff34c5cd7ac]

Jiri Engelthaler (1):
      mtd: slram: invalid checking of absolute end address
         [c36a7ff4578ab6294885aef5ef241aeec4cdb1f0]

Jiri Pirko (1):
      net: correct check in dev_addr_del()
         [a652208e0b52c190e57f2a075ffb5e897fe31c3b]

Johannes Berg (1):
      wireless: allow 40 MHz on world roaming channels 12/13
         [43c771a1963ab461a2f194e3c97fded1d5fe262f]

Johannes Weiner (1):
      mm: vmscan: fix endless loop in kswapd balancing
         [60cefed485a02bd99b6299dad70666fe49245da7]

Joshua.A.Hay@Intel.Com (1):
      ixgbe: add support for X540-AT1
         [df376f0de167754da9b3ece4afdb5bb8bf3fbf3e]

Jozsef Kadlecsik (2):
      netfilter: Mark SYN/ACK packets as invalid  from original direction
         [64f509ce71b08d037998e93dd51180c19b2f464c]
      netfilter: Validate the sequence number of dataless ACK packets as well
         [4a70bbfaef0361d27272629d1a250a937edcafe4]

Jussi Pakkanen (1):
      Input: bcm5974 - set BUTTONPAD property
         [52965cc012f7a3cf35f06485ec275ebf3b3fddae]

Kailang Yang (1):
      ALSA: hda - Add new codec ALC283 ALC290 support
         [7ff34ad80b7080fafaac8efa9ef0061708eddd51]

Len Brown (1):
      intel_idle: initial IVB support
         [6edab08c24f9141d69cfa4683a0a027d86ab303e]

Maciej Patelczyk (1):
      [SCSI] isci: copy fis 0x34 response into proper buffer
         [49bd665c5407a453736d3232ee58f2906b42e83c]

Majianpeng (2):
      md: Avoid write invalid address if read_seqretry returned true.
         [35f9ac2dcec8f79d7059ce174fd7b7ee3290d620]
      md: Reassigned the parameters if read_seqretry returned true in func md_is_badblock.
         [ab05613a0646dcc11049692d54bae76ca9ffa910]

Marek Vasut (1):
      HID: add quirk for Freescale i.MX28 ROM recovery
         [2843b673d03421e0e73cf061820d1db328f7c8eb]

Martin Schwidefsky (1):
      s390/signal: set correct address space control
         [fa968ee215c0ca91e4a9c3a69ac2405aae6e5d2f]

Mauro Carvalho Chehab (1):
      get_dvb_firmware: fix download site for tda10046 firmware
         [25ec43d3e6306978cf66060ed18c4160ce8fc302]

Merlin Schumacher (1):
      acer-wmi: support for P key on TM8372
         [67e1d34cd54cbf33f093f1dd53e7bda1124eb972]

Michal Hocko (1):
      memcg: oom: fix totalpages calculation for memory.swappiness==0
         [9a5a8f19b43430752067ecaee62fc59e11e88fa6]

Mike Galbraith (1):
      workqueue: exit rescuer_thread() as TASK_RUNNING
         [412d32e6c98527078779e5b515823b2810e40324]

Misael Lopez Cruz (1):
      ASoC: dapm: Use card_list during DAPM shutdown
         [445632ad6dda42f4d3f9df2569a852ca0d4ea608]

Naoya Horiguchi (1):
      mm: soft offline: split thp at the beginning of soft_offline_page()
         [783657a7dc20e5c0efbc9a09a9dd38e238a723da]

Oliver Hartkopp (1):
      can: bcm: initialize ifindex for timeouts without previous frame reception
         [81b401100c01d2357031e874689f89bd788d13cd]

Paul Bolle (1):
      radeon: add AGPMode 1 quirk for RV250
         [45171002b01b2e2ec4f991eca81ffd8430fd0aec]

Robert Richter (1):
      x86-32: Fix invalid stack address while in softirq
         [1022623842cb72ee4d0dbf02f6937f38c92c3f41]

Roland Dreier (1):
      block: Don't access request after it might be freed
         [893d290f1d7496db97c9471bc352ad4a11dc8a25]

Russell King - ARM Linux (2):
      Dove: Attempt to fix PMU/RTC interrupts
         [5d3df935426271016b895aecaa247101b4bfa35e]
      Dove: Fix irq_to_pmu()
         [d356cf5a74afa32b40decca3c9dd88bc3cd63eb5]

Sachin Kamat (1):
      mtd: ofpart: Fix incorrect NULL check in parse_ofoldpart_partitions()
         [5a6ea4af0907f995dc06df21a9c9ef764c7cd3bc]

Sarah Sharp (2):
      xhci: Remove scary warnings about transfer issues.
         [2a9227a5eeaeb3f91e3a72ceea4fa59016ca5d20]
      xhci: Remove warnings about MSI and MSI-X capabilities.
         [3b9783b277e66731891ab42eeaacebbdcdd6e629]

Seth Heasley (1):
      watchdog: iTCO_wdt: add Intel Lynx Point DeviceIDs
         [84e83c2846ffb42772056a0f825d8578dc92d586]

Simon Wunderlich (1):
      mac80211: deinitialize ibss-internals after emptiness check
         [b78a4932f5fb11fadf41e69c606a33fa6787574c]

Takashi Iwai (1):
      drm/i915: Check VBIOS value for determining LVDS dual channel mode, too
         [b03543857fd75876b96e10d4320b775e95041bb7]

Tejun Heo (1):
      device_cgroup: fix RCU usage
         [201e72acb2d3821e2de9ce6091e98859c316b29a]

Thomas Betker (1):
      jffs2: Fix lock acquisition order bug in jffs2_write_begin
         [5ffd3412ae5536a4c57469cb8ea31887121dcb2e]

Thomas Gleixner (1):
      futex: Handle futex_pi OWNER_DIED take over correctly
         [59fa6245192159ab5e1e17b8e31f15afa9cff4bf]

Tilman Schmidt (1):
      bas_gigaset: fix pre_reset handling
         [c6fdd8e5d0c65bb8821dc6da26ee1a2ddd58b3cc]

Tom Herbert (1):
      net-rps: Fix brokeness causing OOO packets
         [baefa31db2f2b13a05d1b81bdf2d20d487f58b0a]

Ulrich Weber (1):
      netfilter: nf_nat: don't check for port change on ICMP tuples
         [38fe36a248ec3228f8e6507955d7ceb0432d2000]

Xi Wang (1):
      ipv4: avoid undefined behavior in do_ip_setsockopt()
         [0c9f79be295c99ac7e4b569ca493d75fdcc19e4e]

Yinghai Lu (2):
      PCI : Calculate right add_size
         [a4ac9fea016fc5c09227eb479bd35e34978323a4]
      x86, mm: Undo incorrect revert in arch/x86/mm/init.c
         [f82f64dd9f485e13f29f369772d4a0e868e5633a]

Zhao Yakui (1):
      ttm: Clear the ttm page allocated from high memory zone correctly
         [ac207ed2471150e06af0afc76e4becc701fa2733]

 Documentation/cgroups/memory.txt                |    4 ++
 Documentation/dvb/get_dvb_firmware              |    2 +-
 Makefile                                        |    4 +-
 arch/arm/Kconfig                                |    1 +
 arch/arm/mach-dove/include/mach/pm.h            |    2 +-
 arch/arm/mach-dove/irq.c                        |   14 ++++-
 arch/arm/mach-kirkwood/pcie.c                   |   11 +++-
 arch/m68k/include/asm/signal.h                  |    6 +-
 arch/parisc/kernel/signal32.c                   |    6 +-
 arch/parisc/kernel/sys_parisc.c                 |    2 +
 arch/s390/include/asm/compat.h                  |    2 +-
 arch/s390/include/asm/ptrace.h                  |    4 +-
 arch/s390/kernel/compat_signal.c                |   14 ++++-
 arch/s390/kernel/signal.c                       |   14 ++++-
 arch/s390/mm/gup.c                              |    2 +-
 arch/sparc/kernel/signal_64.c                   |    4 +-
 arch/x86/include/asm/ptrace.h                   |   15 ++---
 arch/x86/kernel/cpu/amd.c                       |   14 +++++
 arch/x86/kernel/cpu/mcheck/therm_throt.c        |   29 +++-------
 arch/x86/kernel/microcode_amd.c                 |    4 ++
 arch/x86/kernel/ptrace.c                        |   30 ++++++++++
 arch/x86/kernel/setup.c                         |   17 +++++-
 arch/x86/mm/init.c                              |   67 +++++++++++++----------
 block/blk-exec.c                                |    9 ++-
 drivers/gpu/drm/i915/i915_drv.h                 |    2 +
 drivers/gpu/drm/i915/intel_bios.c               |   36 ++++++++++++
 drivers/gpu/drm/i915/intel_display.c            |   30 ++++++++--
 drivers/gpu/drm/i915/intel_sdvo.c               |   22 +++++++-
 drivers/gpu/drm/radeon/atombios_encoders.c      |    2 +-
 drivers/gpu/drm/radeon/evergreen.c              |    2 +
 drivers/gpu/drm/radeon/radeon_agp.c             |    5 +-
 drivers/gpu/drm/ttm/ttm_page_alloc.c            |    5 +-
 drivers/hid/hid-ids.h                           |    3 +
 drivers/hid/usbhid/hid-quirks.c                 |    1 +
 drivers/idle/intel_idle.c                       |   37 +++++++++++++
 drivers/input/mouse/bcm5974.c                   |    3 +
 drivers/input/serio/i8042.c                     |   23 +++++---
 drivers/isdn/gigaset/bas-gigaset.c              |   19 ++++++-
 drivers/md/dm.c                                 |    8 ++-
 drivers/md/md.c                                 |   11 ++--
 drivers/mtd/devices/slram.c                     |    2 +-
 drivers/mtd/ofpart.c                            |    2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c  |    1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.c |    1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c   |    3 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h   |    2 +
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.c |    6 +-
 drivers/net/wireless/mwifiex/cmdevt.c           |   11 +++-
 drivers/net/wireless/mwifiex/sdio.c             |   11 ++--
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c     |    1 +
 drivers/pci/setup-bus.c                         |    4 +-
 drivers/pci/setup-res.c                         |    5 +-
 drivers/platform/x86/acer-wmi.c                 |    1 +
 drivers/scsi/isci/request.c                     |    2 +-
 drivers/usb/host/xhci-ring.c                    |    7 +--
 drivers/usb/host/xhci.c                         |    8 +--
 drivers/usb/serial/option.c                     |    9 +++
 drivers/usb/serial/usb-serial.c                 |    6 +-
 drivers/watchdog/iTCO_wdt.c                     |   35 ++++++++++++
 fs/gfs2/lops.c                                  |   18 ++----
 fs/gfs2/trans.c                                 |    8 +++
 fs/jbd/transaction.c                            |    2 +
 fs/jffs2/file.c                                 |   39 +++++++------
 fs/reiserfs/inode.c                             |   10 +++-
 fs/reiserfs/stree.c                             |    4 ++
 fs/reiserfs/super.c                             |   60 +++++++++++++++-----
 fs/ubifs/find.c                                 |   12 +++-
 fs/ubifs/lprops.c                               |    6 ++
 fs/ubifs/ubifs.h                                |    3 +
 fs/xfs/xfs_buf.c                                |   14 ++++-
 include/linux/ptp_clock_kernel.h                |    3 +-
 kernel/futex.c                                  |   59 +++++++++++++-------
 kernel/watchdog.c                               |    4 +-
 kernel/workqueue.c                              |    4 +-
 mm/memcontrol.c                                 |   21 +++++--
 mm/memory-failure.c                             |    8 +++
 mm/shmem.c                                      |    2 +-
 mm/sparse.c                                     |   10 ++--
 mm/vmscan.c                                     |   27 ++++++---
 net/can/bcm.c                                   |    3 +
 net/core/dev.c                                  |    4 +-
 net/core/dev_addr_lists.c                       |    3 +-
 net/ipv4/ip_sockglue.c                          |   33 +++++++----
 net/ipv4/netfilter/nf_nat_standalone.c          |    6 +-
 net/ipv6/ipv6_sockglue.c                        |    1 +
 net/mac80211/ibss.c                             |    8 +--
 net/mac80211/sta_info.c                         |    5 ++
 net/netfilter/nf_conntrack_proto_tcp.c          |   29 ++++------
 net/wireless/reg.c                              |    5 +-
 security/device_cgroup.c                        |    6 +-
 security/selinux/netnode.c                      |    3 +-
 sound/pci/hda/patch_realtek.c                   |    3 +
 sound/soc/codecs/wm8978.c                       |    2 +-
 sound/soc/soc-dapm.c                            |    2 +-
 sound/usb/midi.c                                |    8 ++-
 95 files changed, 742 insertions(+), 296 deletions(-)

-- 
Ben Hutchings
Always try to do things in chronological order;
it's less confusing that way.


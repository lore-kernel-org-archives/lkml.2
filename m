Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab2KNFt6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 00:49:58 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54908 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751686Ab2KNFty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:49:54 -0500
Message-Id: <20121114053933.726869752@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:39:33 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/82] 3.2.34-stable review
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.34 release.
There are 82 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Nov 16 12:00:00 UTC 2012.
Anything received after that time might be too late.

A combined patch relative to 3.2.33 will be posted as an additional
response to this.  A shortlog and diffstat can be found below.

Ben.

-------------

Alex Deucher (1):
      drm/radeon: fix typo in evergreen_mc_resume()
         [695ddeb457584a602f2ba117d08ce37cf6ec1589]

Alexander Stein (1):
      ALSA: hda: Cirrus: Fix coefficient index for beep configuration
         [5a83b4b5a391f07141b157ac9daa51c409e71ab5]

Antonio Quartulli (1):
      mac80211: fix SSID copy on IBSS JOIN
         [badecb001a310408d3473b1fc2ed5aefd0bc92a9]

Ben Hutchings (1):
      nfs: Show original device name verbatim in /proc/*/mount{s,info}
         [97a54868262da1629a3e65121e65b8e8c4419d9f]

Ben Skeggs (3):
      drm/nouveau: fix suspend/resume when in headless mode
         [9430738d80223a1cd791a2baa74fa170d3df1262]
      drm/nouveau: headless mode by default if pci class != vga display
         [e412e95a268fa8544858ebfe066826b290430d51]
      drm/nouveau: silence modesetting spam on pre-gf8 chipsets
         [cee59f15a60cc6269a25e3f6fbf1a577d6ab8115]

Bo Shen (1):
      ARM: at91/i2c: change id to let i2c-gpio work
         [7840487cd6298f9f931103b558290d8d98d41c49]

Bryan Schumaker (1):
      NFS: Wait for session recovery to finish before returning
         [399f11c3d872bd748e1575574de265a6304c7c43]

Cyril Brulebois (1):
      r8169: Fix WoL on RTL8168d/8111d.
         [b00e69dee4ccbb3a19989e3d4f1385bc2e3406cd]

Dan Carpenter (1):
      gpio-timberdale: fix a potential wrapping issue
         [d79550a7bc35c16476ebdc27c78378d8093390ec]

Daniel J Blueman (1):
      ALSA: HDA: Fix digital microphone on CS420x
         [16337e028a6dae9fbdd718c0d42161540a668ff3]

Daniel Vetter (3):
      drm/i915: clear the entire sdvo infoframe buffer
         [b6e0e543f75729f207b9c72b0162ae61170635b2]
      drm/i915: fix overlay on i830M
         [a9193983f4f292a82a00c72971c17ec0ee8c6c15]
      drm/i915: fixup infoframe support for sdvo
         [81014b9d0b55fb0b48f26cd2a943359750d532db]

Dave Chinner (1):
      xfs: fix reading of wrapped log data
         [6ce377afd1755eae5c93410ca9a1121dfead7b87]

David Vrabel (1):
      xen/gntdev: don't leak memory from IOCTL_GNTDEV_MAP_GRANT_REF
         [a67baeb77375199bbd842fa308cb565164dd1f19]

Egbert Eich (1):
      DRM/Radeon: Fix Load Detection on legacy primary DAC.
         [83325d072185899b706de2956170b246585aaec9]

Eric Dumazet (3):
      netlink: use kfree_rcu() in netlink_release()
         [6d772ac5578f711d1ce7b03535d1c95bffb21dff]
      rtnetlink: fix rtnl_calcit() and rtnl_dump_ifinfo()
         [a4b64fbe482c7766f7925f03067fc637716bfa3f]
      tcp: fix FIONREAD/SIOCINQ
         [a3374c42aa5f7237e87ff3b0622018636b0c847e]

Eric Leblond (1):
      af-packet: fix oops when socket is not present
         [a3d744e995d2b936c500585ae39d99ee251c89b4]

Eric Paris (1):
      fanotify: fix missing break
         [848561d368751a1c0f679b9f045a02944506a801]

Felix Fietkau (2):
      ath9k: fix stale pointers potentially causing access to free'd skbs
         [8c6e30936a7893a85f6222084f0f26aceb81137a]
      cfg80211: fix antenna gain handling
         [c4a9fafc77a5318f5ed26c509bbcddf03e18c201]

Greg Rose (1):
      rtnetlink: Fix problem with buffer allocation
         [115c9b81928360d769a76c632bae62d15206a94a]

Hannes Frederic Sowa (1):
      ipv6: send unsolicited neighbour advertisements to  all-nodes
         [60713a0ca7fd6651b951cc1b4dbd528d1fc0281b]

Hemant Kumar (1):
      net: usb: Fix memory leak on Tx data path
         [39707c2a3ba5011038b363f84d37c8a98d2d9db1]

Herton Ronaldo Krzesinski (2):
      floppy: do put_disk on current dr if blk_init_queue fails
         [238ab78469c6ab7845b43d5061cd3c92331b2452]
      floppy: properly handle failure on add_disk loop
         [d60e7ec18c3fb2cbf90969ccd42889eb2d03aef9]

Ilija Hadzic (1):
      drm: restore open_count if drm_setup fails
         [0f1cb1bd94a9c967cd4ad3de51cfdabe61eb5dcc]

Ivan Shugov (1):
      ARM: at91: at91sam9g10: fix SOC type detection
         [3d9a0183dd3423353e9e363bcc261c1220d05f9f]

J. Bruce Fields (1):
      nfsd: add get_uint for u32's
         [a007c4c3e943ecc054a806c259d95420a188754b]

Javier Cardona (2):
      mac80211: Only process mesh config header on frames that RA_MATCH
         [555cb715be8ef98b8ec362b23dfc254d432a35b1]
      mac80211: don't inspect Sequence Control field on control frames
         [f7fbf70ee9db6da6033ae50d100e017ac1f26555]

Jean Delvare (1):
      hwmon: (w83627ehf) Force initial bank selection
         [3300fb4f88688029fff8dfb9ec0734f6e4cba3e7]

Jeff Layton (1):
      cifs: fix potential buffer overrun in cifs.idmap handling code
         [36960e440ccf94349c09fb944930d3bfe4bc473f]

Jesper Dangaard Brouer (1):
      net: fix divide by zero in tcp algorithm illinois
         [8f363b77ee4fbf7c3bbcf5ec2c5ca482d396d664]

Jiri Slaby (1):
      HID: microsoft: fix invalid rdesc for 3k kbd
         [3ccc60f9d8c39180c205dba1a020735bda1b2491]

Johan Hovold (1):
      USB: mos7840: remove unused variable
         [a tiny part of 80c00750f0c9867a65b30a17880939b6bc660a77]

Johannes Berg (4):
      mac80211: check management frame header length
         [4a4f1a5808c8bb0b72a4f6e5904c53fb8c9cd966]
      mac80211: make sure data is accessible in EAPOL check
         [6dbda2d00d466225f9db1dc695ff852443f28832]
      mac80211: verify that skb data is present
         [9b395bc3be1cebf0144a127c7e67d56dbdac0930]
      wireless: drop invalid mesh address extension frames
         [7dd111e8ee10cc6816669eabcad3334447673236]

Jussi Kivilinna (1):
      crypto: cryptd - disable softirqs in cryptd_queue_worker to prevent data corruption
         [9efade1b3e981f5064f9db9ca971b4dc7557ae42]

Kailang Yang (1):
      ALSA: hda - Add new codec ALC668 and ALC900 (default name ALC1150)
         [19a62823eae453619604636082085812c14ee391]

Konrad Rzeszutek Wilk (1):
      xen/mmu: Use Xen specific TLB flush instead of the generic one.
         [95a7d76897c1e7243d4137037c66d15cbf2cce76]

Len Brown (1):
      x86: Remove the ancient and deprecated disable_hlt() and enable_hlt() facility
         [f6365201d8a21fb347260f89d6e9b3e718d63c70]

Li RongQing (1):
      ipv6: Set default hoplimit as zero.
         [14edd87dc67311556f1254a8f29cf4dd6cb5b7d1]

Mathias Nyman (1):
      gpiolib: Don't return -EPROBE_DEFER to sysfs, or for invalid gpios
         [ad2fab36d7922401c4576fb7ea9b21a47a29a17f]

Michal Schmidt (1):
      r8169: use unlimited DMA burst for TX
         [aee77e4accbeb2c86b1d294cd84fec4a12dde3bd]

Mirko Lindner (1):
      sky2: Fix for interrupt handler
         [d663d181b9e92d80c2455e460e932d34e7a2a7ae]

Nathan Walp (1):
      r8169: allow multicast packets on sub-8168f chipset.
         [0481776b7a70f09acf7d9d97c288c3a8403fbfe4]

NeilBrown (1):
      NFS: fix bug in legacy DNS resolver.
         [8d96b10639fb402357b75b055b1e82a65ff95050]

Roland Dreier (3):
      iscsi-target: Fix missed wakeup race in TX thread
         [d5627acba9ae584cf4928af19f7ddf5f6837de32]
      target: Avoid integer overflow in se_dev_align_max_sectors()
         [3e03989b5868acf69a391a424dc71fcd6cc48167]
      target: Don't return success from module_init() if setup fails
         [0d0f9dfb31e0a6c92063e235417b42df185b3275]

Rolf Eike Beer (1):
      Input: tsc40 - remove wrong announcement of pressure support
         [32ed1911fc79908d704023317d4ddeb3883fd07e]

Rusty Russell (1):
      module: fix out-by-one error in kallsyms
         [59ef28b1f14899b10d6b2682c7057ca00a9a3f47]

Scott Mayhew (1):
      nfsv3: Make v3 mounts fail with ETIMEDOUTs instead EIO on mountd timeouts
         [acce94e68a0f346115fd41cdc298197d2d5a59ad]

Stanislaw Gruszka (1):
      rt2800: validate step value for temperature compensation
         [bf7e1abe434ba9e22e8dc04a4cba4ab504b788b8]

Sven Eckelmann (1):
      ath9k: Test for TID only in BlockAcks while checking tx status
         [6fe7cc71bbf3a0bc28c9cec3c00bc11e81344412]

Takamori Yamaguchi (1):
      mm: bugfix: set current->reclaim_state to NULL while returning from kswapd()
         [b0a8cc58e6b9aaae3045752059e5e6260c0b94bc]

Takashi Iwai (10):
      ALSA: Add a reference counter to card instance
         [a0830dbd4e42b38aefdf3fb61ba5019a1a99ea85]
      ALSA: Avoid endless sleep after disconnect
         [0914f7961babbf28aaa2f19b453951fb4841c03f]
      ALSA: Fix card refcount unbalance
         [8bb4d9ce08b0a92ca174e41d92c180328f86173f]
      ALSA: PCM: Fix some races at disconnection
         [9b0573c07f278e9888c352aa9724035c75784ea0]
      ALSA: hda - Fix empty DAC filling in patch_via.c
         [5b3761954dac2d1393beef8210eb8cee81d16b8d]
      ALSA: hda - Fix invalid connections in VT1802 codec
         [ef4da45828603df57e5e21b8aa21a66ce309f79b]
      ALSA: hda - Force to reset IEC958 status bits for AD codecs
         [ae24c3191ba2ab03ec6b4be323e730e00404b4b6]
      ALSA: usb-audio: Fix races at disconnection
         [978520b75f0a1ce82b17e1e8186417250de6d545]
      ALSA: usb-audio: Fix races at disconnection in mixer_quirks.c
         [888ea7d5ac6815ba16b3b3a20f665a92c7af6724]
      ALSA: usb-audio: Use rwsem for disconnect protection
         [34f3c89fda4fba9fe689db22253ca8db2f5e6386]

Thomas Hellstrom (2):
      drm/vmwgfx: Fix a case where the code would BUG when trying to pin GMR memory
         [afcc87aa6a233e52df73552dc1dc9ae3881b7cc8]
      drm/vmwgfx: Fix hibernation device reset
         [95e8f6a21996c4cc2c4574b231c6e858b749dce3]

Tim Sally (1):
      eCryptfs: check for eCryptfs cipher support at mount
         [5f5b331d5c21228a6519dcb793fc1629646c51a6]

Tom Parkin (1):
      l2tp: fix oops in l2tp_eth_create() error path
         [789336360e0a2aeb9750c16ab704a02cbe035e9e]

Trond Myklebust (2):
      NFSv4.1: We must release the sequence id when we fail to get a session slot
         [2240a9e2d013d8269ea425b73e1d7a54c7bc141f]
      NFSv4: nfs4_locku_done must release the sequence id
         [2b1bc308f492589f7d49012ed24561534ea2be8c]

Tyler Hicks (1):
      eCryptfs: Copy up POSIX ACL and read-only flags from lower mount
         [069ddcda37b2cf5bb4b6031a944c0e9359213262]

Ulisses Furquim (1):
      Bluetooth: Always compile SCO and L2CAP in Bluetooth Core
         [f1e91e1640d808d332498a6b09b2bcd01462eff9]

Zijie Pan (1):
      sctp: fix call to SCTP_CMD_PROCESS_SACK in  sctp_cmd_interpreter()
         [f6e80abeab928b7c47cc1fbf53df13b4398a2bec]

 Documentation/feature-removal-schedule.txt      |    8 ---
 Makefile                                        |    4 +-
 arch/arm/mach-at91/at91rm9200_devices.c         |    2 +-
 arch/arm/mach-at91/at91sam9260_devices.c        |    2 +-
 arch/arm/mach-at91/at91sam9261_devices.c        |    2 +-
 arch/arm/mach-at91/at91sam9263_devices.c        |    2 +-
 arch/arm/mach-at91/at91sam9rl_devices.c         |    2 +-
 arch/arm/mach-at91/setup.c                      |    2 +-
 arch/x86/include/asm/system.h                   |    7 --
 arch/x86/kernel/process.c                       |   24 -------
 arch/x86/xen/mmu.c                              |   21 +++++-
 crypto/cryptd.c                                 |   11 +++-
 drivers/block/floppy.c                          |   48 ++++----------
 drivers/gpio/gpio-timberdale.c                  |    4 +-
 drivers/gpio/gpiolib.c                          |   10 ++-
 drivers/gpu/drm/drm_fops.c                      |    5 +-
 drivers/gpu/drm/i915/intel_drv.h                |    4 +-
 drivers/gpu/drm/i915/intel_overlay.c            |   14 +++-
 drivers/gpu/drm/i915/intel_sdvo.c               |   59 ++++++++++++-----
 drivers/gpu/drm/i915/intel_sdvo_regs.h          |    2 +
 drivers/gpu/drm/nouveau/nouveau_drv.c           |   34 ++++++----
 drivers/gpu/drm/nouveau/nouveau_state.c         |    4 +-
 drivers/gpu/drm/nouveau/nv04_dac.c              |    8 +--
 drivers/gpu/drm/nouveau/nv04_dfp.c              |    6 +-
 drivers/gpu/drm/nouveau/nv04_tv.c               |    4 +-
 drivers/gpu/drm/radeon/evergreen.c              |    2 +-
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |    1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_dmabuf.c          |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c             |    5 ++
 drivers/hid/hid-microsoft.c                     |   18 ++++--
 drivers/hwmon/w83627ehf.c                       |    1 +
 drivers/input/touchscreen/tsc40.c               |    1 -
 drivers/net/ethernet/marvell/sky2.c             |    4 +-
 drivers/net/ethernet/realtek/r8169.c            |    7 +-
 drivers/net/usb/usbnet.c                        |    3 +
 drivers/net/wireless/ath/ath9k/xmit.c           |   10 ++-
 drivers/net/wireless/rt2x00/rt2800lib.c         |    2 +-
 drivers/target/iscsi/iscsi_target.c             |    4 +-
 drivers/target/iscsi/iscsi_target_core.h        |    1 +
 drivers/target/iscsi/iscsi_target_login.c       |    1 +
 drivers/target/iscsi/iscsi_target_util.c        |   22 ++++++-
 drivers/target/iscsi/iscsi_target_util.h        |    1 +
 drivers/target/target_core_configfs.c           |    3 +-
 drivers/target/target_core_device.c             |   18 +++---
 drivers/usb/serial/mos7840.c                    |    1 -
 drivers/xen/gntdev.c                            |   36 ++++++-----
 fs/cifs/cifsacl.c                               |   49 ++++++--------
 fs/ecryptfs/main.c                              |   23 ++++++-
 fs/nfs/dns_resolve.c                            |    5 +-
 fs/nfs/internal.h                               |    5 +-
 fs/nfs/mount_clnt.c                             |    2 +-
 fs/nfs/namespace.c                              |   19 ++++--
 fs/nfs/nfs4namespace.c                          |    3 +-
 fs/nfs/nfs4proc.c                               |   40 +++++++-----
 fs/nfs/super.c                                  |    2 +-
 fs/nfsd/export.c                                |    6 +-
 fs/notify/fanotify/fanotify.c                   |    1 +
 fs/xfs/xfs_log_recover.c                        |    2 +-
 include/linux/if_link.h                         |    1 +
 include/linux/rtnetlink.h                       |    3 +
 include/linux/sunrpc/cache.h                    |   16 +++++
 include/net/bluetooth/bluetooth.h               |   22 -------
 include/net/cfg80211.h                          |    9 +++
 include/net/rtnetlink.h                         |    2 +-
 include/sound/core.h                            |    3 +
 include/trace/events/xen.h                      |    8 +++
 kernel/module.c                                 |   24 +++----
 mm/vmscan.c                                     |    2 +
 net/bluetooth/Kconfig                           |   37 +++--------
 net/bluetooth/Makefile                          |    5 +-
 net/bluetooth/bnep/Kconfig                      |    2 +-
 net/bluetooth/cmtp/Kconfig                      |    2 +-
 net/bluetooth/hidp/Kconfig                      |    2 +-
 net/bluetooth/rfcomm/Kconfig                    |    2 +-
 net/core/dev.c                                  |    2 +-
 net/core/rtnetlink.c                            |   78 +++++++++++++++++------
 net/ipv4/tcp.c                                  |    8 +--
 net/ipv4/tcp_illinois.c                         |    8 ++-
 net/ipv6/ndisc.c                                |    3 +-
 net/ipv6/route.c                                |    4 +-
 net/l2tp/l2tp_eth.c                             |    1 +
 net/mac80211/ibss.c                             |    2 +-
 net/mac80211/rx.c                               |   71 ++++++++++++++++-----
 net/netlink/af_netlink.c                        |   19 ++++--
 net/sctp/sm_sideeffect.c                        |    3 +-
 net/wireless/core.c                             |    3 +-
 net/wireless/util.c                             |   14 ++--
 sound/core/control.c                            |    5 ++
 sound/core/hwdep.c                              |   12 +++-
 sound/core/init.c                               |   50 +++++++++------
 sound/core/oss/mixer_oss.c                      |   11 +++-
 sound/core/oss/pcm_oss.c                        |    7 ++
 sound/core/pcm.c                                |   13 +++-
 sound/core/pcm_native.c                         |   35 ++++++++--
 sound/core/rawmidi.c                            |   26 +++++++-
 sound/core/sound.c                              |   11 +++-
 sound/core/sound_oss.c                          |   10 ++-
 sound/pci/hda/patch_analog.c                    |    1 +
 sound/pci/hda/patch_cirrus.c                    |   16 +++--
 sound/pci/hda/patch_realtek.c                   |    2 +
 sound/pci/hda/patch_via.c                       |   25 ++++++--
 sound/usb/card.c                                |   12 ++--
 sound/usb/card.h                                |    1 +
 sound/usb/endpoint.c                            |    9 ++-
 sound/usb/mixer.c                               |   65 ++++++++++++-------
 sound/usb/mixer_quirks.c                        |   37 +++++++++--
 sound/usb/pcm.c                                 |   35 +++++++---
 sound/usb/proc.c                                |    4 +-
 sound/usb/usbaudio.h                            |    2 +-
 109 files changed, 867 insertions(+), 467 deletions(-)

-- 
Ben Hutchings
friends: People who know you well, but like you anyway.


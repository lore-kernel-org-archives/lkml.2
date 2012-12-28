Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970Ab2L1UBj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 15:01:39 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54829 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754064Ab2L1TQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:16:44 -0500
Message-Id: <20121228190330.025298996@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:03:30 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 000/173] 3.2.36-stable review
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.36 release.
There are 173 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Jan  2 20:00:00 GMT 2013.
Anything received after that time might be too late.

A combined patch relative to 3.2.35 will be posted as an additional
response to this.  A shortlog and diffstat can be found below.

Ben.

-------------

Aaron Lu (1):
      libata: set dma_mode to 0xff in reset
         [5416912af75de9cba5d1c75b99a7888b0bbbd2fb]

Al Viro (1):
      ARM: missing ->mmap_sem around find_vma() in swp_emulate.c
         [7bf9b7bef881aac820bf1f2e9951a17b09bd7e04]

Alan Cox (3):
      ACPI: missing break
         [879dca019dc43a1622edca3e7dde644b14b5acc5]
      ne2000: add the right platform device
         [da9da01d9199b5bb15289d0859053c9aa3a34ac0]
      pnpacpi: fix incorrect TEST_ALPHA() test
         [cdc87c5a30f407ed1ce43d8a22261116873d5ef1]

Alan Stern (3):
      USB: EHCI: bugfix: urb->hcpriv should not be NULL
         [2656a9abcf1ec8dd5fee6a75d6997a0f2fa0094e]
      USB: OHCI: workaround for hardware bug: retired TDs not added to the Done Queue
         [50ce5c0683aa83eb161624ea89daa5a9eee0c2ce]
      USB: fix endpoint-disabling for failed config changes
         [36caff5d795429c572443894e8789c2150dd796b]

Alasdair G Kergon (1):
      dm ioctl: prevent unsafe change to dm_ioctl data_size
         [e910d7ebecd1aac43125944a8641b6cb1a0dfabe]

Alex Deucher (4):
      drm/radeon/dce32+: use fractional fb dividers for high clocks
         [a02dc74b317d78298cb0587b9b1f6f741fd5c139]
      drm/radeon/kms: use frac fb div on APUs
         [37d4174d2d252c37dcb3d88cafae488542087848]
      drm/radeon: fix eDP clk and lane setup for scaled modes
         [93927f9c1db5f55085457e820f0631064c7bfa34]
      drm: fix documentation for drm_crtc_set_mode()
         [4c9287c6009b37754c42e0ba73a4cc79de92d8f8]

Alexander Graf (1):
      KVM: PPC: 44x: fix DCR read/write
         [e43a028752fed049e4bd94ef895542f96d79fa74]

Alexander Shiyan (1):
      irda: sir_dev: Fix copy/paste typo
         [2355a62bcbdcc4b567425bab036bfab6ade87eed]

Alexander Stein (1):
      can: Do not call dev_put if restart timer is running upon close
         [ab48b03ec9ae1840a1e427e2375bd0d9d554b4ed]

Alexey Kaminsky (1):
      HID: apple: Add Apple wireless keyboard 2011 ANSI PID
         [0a97e1e9f9a6765e6243030ac42b04694f3f3647]

Alexis R. Cortes (1):
      usb: host: xhci: Stricter conditional for Z1 system models for Compliance Mode Patch
         [b0e4e606ff6ff26da0f60826e75577b56ba4e463]

Andreas Hartmann (1):
      rt2x00: Don't let mac80211 send a BAR when an AMPDU subframe fails
         [be03d4a45c09ee5100d3aaaedd087f19bc20d01f]

Anton Blanchard (1):
      powerpc: Fix CONFIG_RELOCATABLE=y CONFIG_CRASH_DUMP=n build
         [11ee7e99f35ecb15f59b21da6a82d96d2cd3fcc8]

Artem Bityutskiy (1):
      proc: pid/status: show all supplementary groups
         [8d238027b87e654be552eabdf492042a34c5c300]

Ben Hutchings (4):
      HID: Add Apple wireless keyboard 2011 ANSI to special driver list
         [f9af7b9edccb87d4d80b58687ab63e58f3b64c4c]
      Revert "device_cgroup: fix RCU usage"
         [not upstream; change was correct for mainline but not 3.2]
      Revert "mm: vmscan: fix endless loop in kswapd balancing"
         [not upstream; change was correct for mainline but not 3.2]
      mm: add kmap_to_page()
         [part of 5a178119b0fbe37f7dfb602b37df9cc4b1dc9d71]

Bjørn Mork (1):
      USB: option: blacklist network interface on Huawei E173
         [f36446cf9bbebaa03a80d95cfeeafbaf68218249]

Boris Ostrovsky (1):
      x86,AMD: Power driver support for AMD's family 16h processors
         [22e32f4f57778ebc6e17812fa3008361c05d64f9]

Bryan Schumaker (1):
      NFS: Add sequence_priviliged_ops for nfs4_proc_sequence()
         [6bdb5f213c4344324f600dde885f25768fbd14db]

Calvin Walton (1):
      i915: Quirk no_lvds on Gigabyte GA-D525TUD ITX motherboard
         [a51d4ed01e5bb39d2cf36a12f9976ab08872c192]

Charles Keepax (1):
      mfd: Only unregister platform devices allocated by the mfd core
         [b9fbb62eb61452d728c39b2e5020739c575aac53]

Chase Douglas (1):
      HID: hid-magicmouse: Add pointer and buttonpad properties for Magic Trackpad
         [503f7d53b368c8e4e13a7756220c0536fcf1a034]

Chris Ball (1):
      Revert misapplied "mmc: sh-mmcif: avoid oops on spurious interrupts"
         [6984f3c31bb57cb7491dbec1be44b74bd00f4648]

Chris Wilson (2):
      drm/i915: Add no-lvds quirk for Supermicro X7SPA-H
         [c31407a3672aaebb4acddf90944a114fa5c8af7b]
      drm/i915: Close race between processing unpin task and queueing the flip
         [e7d841ca03b7ab668620045cd7b428eda9f41601]

Christian Borntraeger (1):
      s390/kvm: dont announce RRBM support
         [87cac8f879a5ecd7109dbe688087e8810b3364eb]

Corentin Chary (1):
      acpi/video_detect: blacklist samsung x360
         [084940d5b101e9ca91a689eb5048151b14076839]

Corey Minyard (1):
      CRIS: fix I/O macros
         [c24bf9b4cc6a0f330ea355d73bfdf1dae7e63a05]

Dan Carpenter (3):
      drivers/leds/leds-lp5521.c: fix lp5521_read() error handling
         [5bc9ad774c063f6b41965e7314f2c26aa5e465a0]
      ftrace: Clear bits properly in reset_iter_read()
         [70f77b3f7ec010ff9624c1f2e39a81babc9e2429]
      telephony: ijx: buffer overflow in ixj_write_cid()
         [not upstream; driver has been removed]

Dan Williams (1):
      i2400m: add Intel 6150 device IDs
         [999a7c5776a0ed2133645fa7e008bec05bda9254]

Daniel Vetter (2):
      drm/i915: disable cpt phase pointer fdi rx workaround
         [539526b4137bc0e7a8806c38c8522f226814a0e6]
      drm/i915: drop unnecessary check from fdi_link_train code
         [8f5718a6d9a29bf1f51910c6b32bd0244f905303]

David Jeffery (1):
      [SCSI] qla2xxx: Test and clear FCPORT_UPDATE_NEEDED atomically.
         [a394aac88506159e047630fc90dc2242568382d8]

David Milburn (1):
      sata_svw: check DMA start bit before reset
         [b03e66a6be91f8389fcd902ab6c1563db1c9c06b]

David Rientjes (1):
      thp, memcg: split hugepage for memcg oom on cow
         [1f1d06c34f7675026326cd9f39ff91e4555cf355]

David Woodhouse (2):
      intel-iommu: Free old page tables before creating superpage
         [6491d4d02893d9787ba67279595990217177b351]
      solos-pci: fix double-free of TX skb in DMA mode
         [cae49ede00ec3d0cda290b03fee55b72b49efc11]

Dmitry Rogozhkin (1):
      drm/i915: EBUSY status handling added to i915_gem_fault().
         [e79e0fe380847493266fba557217e2773c61bd1b]

Duncan Roe (1):
      ALSA: hda - Fix missing beep on ASUS X43U notebook
         [7110005e8d5c3cd418fc4b64f9f124f004422a9a]

Emmanuel Grumbach (1):
      iwlwifi: don't handle masked interrupt
         [25a172655f837bdb032e451f95441bb4acec51bb]

Eric Dumazet (1):
      rcu: Fix batch-limit size problem
         [878d7439d0f45a95869e417576774673d1fa243f]

Eric Sandeen (1):
      ext4: init pagevec in ext4_da_block_invalidatepages
         [66bea92c69477a75a5d37b9bfed5773c92a3c4b4]

Eugene Shatokhin (1):
      ext4: fix memory leak in ext4_xattr_set_acl()'s error path
         [24ec19b0ae83a385ad9c55520716da671274b96c]

Eugeni Dodonov (2):
      drm/i915: add Ivy Bridge GT2 Server entries
         [cc22a938fc1db0c8ef5e693a69b159c4b851dab3]
      drm: give up on edid retries when i2c bus is not responding
         [9292f37e1f5c79400254dca46f83313488093825]

Felix Fietkau (2):
      Revert "ath9k_hw: Update AR9003 high_power tx gain table"
         [9c170e068636deb3e3f96114034bb711675f0faa]
      ath9k_hw: Fix signal strength / channel noise reporting
         [b7c0c238898d200e80487516e2b67aba2a522cc0]

Gabor Juhos (1):
      ath9k: ar9003: fix OTP register offsets for AR9340
         [b3cd8021379306c0be6932e4d3b4b01efc681769]

Greg KH (1):
      USB: mark uas driver as BROKEN
         [fb37ef98015f864d22be223a0e0d93547cd1d4ef]

Guenter Roeck (3):
      hwmon: (coretemp) Add support for Atom CE4110/4150/4170
         [1102dcab849313bd5a340b299b5cf61b518fbc0f]
      hwmon: (coretemp) Add support for Atom D2000 and N2000 series CPU models
         [5592906f8b01282ea3c2acaf641fd067ad4bb3dc]
      hwmon: (coretemp) Improve support for TjMax detection on Atom CPUs
         [41e58a1f2b90c88d94b4bd84beb9927a4c2704e9]

Gustavo Padovan (1):
      Bluetooth: Add missing lock nesting notation
         [dc2a0e20fbc85a71c63aa4330b496fda33f6bf80]

Herton Ronaldo Krzesinski (1):
      USB: cdc-wdm: fix regression on buffer deallocation
         [not upstream; code has been removed]

Huacai Chen (1):
      MIPS: Fix poweroff failure when HOTPLUG_CPU configured.
         [8add1ecb81f541ef2fcb0b85a5470ad9ecfb4a84]

J. Bruce Fields (2):
      nfsd4: fix oops on unusual readlike compound
         [d5f50b0c290431c65377c4afa1c764e2c3fe5305]
      nfsd: fix v4 reply caching
         [57d276d71aef7d8305ff002a070cb98deb2edced]

Jan Beulich (1):
      x86: hpet: Fix masking of MSI interrupts
         [6acf5a8c931da9d26c8dd77d784daaf07fa2bff0]

Jani Nikula (2):
      drm/i915: do not default to 18 bpp for eDP if missing from VBT
         [9a30a61f3516871c5c638fd7c025fbaa11ddf7fe]
      drm/i915: do not ignore eDP bpc settings from vbt
         [2f4f649a69a9eb51f6e98130e19dd90a260a4145]

Jaroslav Resler (1):
      Bluetooth: Add support for BCM20702A0 [04ca, 2003]
         [0c1abbd1aa0416258881c303a88e618cbca0759c]

Jay Purohit (1):
      usb/ipheth: Add iPhone 5 support
         [af1b85e49089f945deb46258b0fc4bc9910afb22]

Jean Delvare (2):
      hwmon: (coretemp) Improve support of recent Atom CPU models
         [fcc14ac1a86931f38da047cf8fb634c6db7b58bc]
      i7300_edac: Fix error flag testing
         [7e06b7a3333f5c7a0cec12aff20d39c5c87c0795]

Jeff Cook (1):
      Bluetooth: Add support for BCM20702A0 [0b05, 17b5]
         [1ee3ff6110c16acfc915a79b1e3feb5013c41e75]

Jerome Glisse (1):
      drm/radeon: fix amd afusion gpu setup aka sumo v2
         [bd25f0783dc3fb72e1e2779c2b99b2d34b67fa8a]

Jiri Slaby (1):
      MISC: hpilo, remove pci_disable_device
         [bcdee04ea7ae0406ae69094f6df1aacb66a69a0b]

Johannes Berg (2):
      ipv4: ip_check_defrag must not modify skb before unsharing
         [1bf3751ec90cc3174e01f0d701e8449ce163d113]
      iwlwifi: handle DMA mapping failures
         [7c34158231b2eda8dcbd297be2bb1559e69cb433]

Julius Werner (1):
      xhci: fix null-pointer dereference when destroying half-built segment rings
         [68e5254adb88bede68285f11fb442a4d34fb550c]

Kamil Iskra (1):
      ACPI / battery: Correct battery capacity values on Thinkpads
         [4000e626156935dfb626321ce09cae2c833eabbb]

Kees Cook (2):
      exec: do not leave bprm->interp on stack
         [b66c5984017533316fd1951770302649baf1aa33]
      use clamp_t in UNAME26 fix
         [31fd84b95eb211d5db460a1dda85e004800a7b52]

Kevin McKinney (2):
      Staging: bcm: Add two products and remove an existing product.
         [4f29ef050848245f7c180b95ccf67dfcd76b1fd8]
      Staging: bcm: Create and initialize new device id in InterfaceInit
         [e66fc1fba248738d32f3b64508f9ef1176d9e767]

Krzysztof Wilczynski (1):
      scsi: aha152x: Fix sparse warning and make printing pointer address more portable.
         [b631cf1f899f9d2e449884dbccc34940637c639f]

Lan Tianyu (2):
      ACPI / PM: Add Sony Vaio VPCEB1S1E to nonvs blacklist.
         [876ab79055019e248508cfd0dee7caa3c0c831ed]
      ACPI / video: Add "Asus UL30VT" to ACPI video detect blacklist
         [d0c2ce16bec0afa6013b4c5220ca4c9c67210215]

Li.Rui27@Zte.Com.Cn (1):
      USB: add new zte 3g-dongle's pid to option.c
         [31b6a1048b7292efff8b5b53ae3d9d29adde385e]

Malcolm Priestley (6):
      staging: vt6656: 64 bit fixes : correct all type sizes
         [7730492855a2f9c828599bcd8d62760f96d319e4]
      staging: vt6656: 64 bit fixes: fix long warning messages.
         [b4dc03af5513774277c9c36b12a25cd3f25f4404]
      staging: vt6656: 64 bit fixes: use u32 for QWORD definition.
         [a552397d5e4ef0cc0bd3e9595d6acc9a3b381171]
      staging: vt6656: 64bit fixes: key.c/h change unsigned long to u32
         [c0d05b305b00c698b0a8c1b3d46c9380bce9db45]
      staging: vt6656: 64bit fixes: vCommandTimerWait change calculation of timer.
         [70e227790d4ee4590023d8041a3485f8053593fc]
      staging: vt6656: [BUG] out of bound array reference in RFbSetPower.
         [ab1dd9963137a1e122004d5378a581bf16ae9bc8]

Marco Stornelli (1):
      ramoops: fix use of rounddown_pow_of_two()
         [fdb5950754eb3dedb9fea7c8828d3e51d9dbc3f7]

Marcos Chaparro (1):
      Bluetooth: ath3k: Add support for VAIO VPCEH [0489:e027]
         [acd9454433e28c1a365d8b069813c35c1c3a8ac3]

Marek Szyprowski (1):
      mm: dmapool: use provided gfp flags for all dma_alloc_coherent() calls
         [387870f2d6d679746020fa8e25ef786ff338dc98]

Mark Brown (2):
      regmap: debugfs: Avoid overflows for very small reads
         [db04328c167ff8e7c57f4a3532214aeada3a82fd]
      regulator: wm831x: Set the new rather than old value for DVS VSEL
         [13ae633cf729b0ecb677b75b04886ff8fada8fad]

Markus Becker (1):
      USB: cp210x: add Virtenio Preon32 device id
         [356fe44f4b8ece867bdb9876b1854d7adbef9de2]

Martin Teichmann (1):
      USB: ftdi_sio: Add support for Newport AGILIS motor drivers
         [d7e14b375b40c04cd735b115713043b69a2c68ac]

Masanari Iida (1):
      drivers/leds/leds-lp5521.c: fix typo
         [3a2fd4a14112452eb5c1a079ac8b3f4842762afe]

Mauro Carvalho Chehab (1):
      i82975x_edac: Fix dimm label initialization
         [479696840239e0cc43efb3c917bdcad2174d2215]

Mel Gorman (1):
      tmpfs: fix shared mempolicy leak
         [18a2f371f5edf41810f6469cb9be39931ef9deb9]

Mikael Pettersson (1):
      sata_promise: fix hardreset lockdep error
         [3100d49d3cd236443faae9d81137c81b22d36003]

Mike Galbraith (1):
      Revert "sched, autogroup: Stop going ahead if autogroup is disabled"
         [fd8ef11730f1d03d5d6555aa53126e9e34f52f12]

Mike Miller (1):
      [SCSI] hpsa: gen8plus Smart Array IDs
         [fe0c9610bb68dd0aad1017456f5e3c31264d70c2]

Mikulas Patocka (1):
      dm persistent data: rename node to btree_node
         [550929faf89e2e2cdb3e9945ea87d383989274cf]

Namjae Jeon (1):
      udf: fix memory leak while allocating blocks during write
         [2fb7d99d0de3fd8ae869f35ab682581d8455887a]

Neil Brown (1):
      nfsd: avoid permission checks on EXCLUSIVE_CREATE replay
         [7007c90fb9fef593b4aeaeee57e6a6754276c97c]

NeilBrown (2):
      NFS: avoid NULL dereference in nfs_destroy_server
         [f259613a1e4b44a0cf85a5dafd931be96ee7c9e5]
      vfs: d_obtain_alias() needs to use "/" as default name.
         [b911a6bdeef5848c468597d040e3407e0aee04ce]

Nikolay@Redhat.Com (1):
      bonding: fix race condition in  bonding_store_slaves_active
         [e196c0e579902f42cf72414461fb034e5a1ffbf7]

Oleg Nesterov (1):
      freezer: PF_FREEZER_NOSIG should be cleared along with PF_NOFREEZE
         [not upstream; flag has been removed]

Ondrej Zary (1):
      x86, 8042: Enable A20 using KBC to fix S3 resume on some MSI laptops
         [ad68652412276f68ad4fe3e1ecf5ee6880876783]

Paul Walmsley (1):
      ARM: 7566/1: vfp: fix save and restore when running on pre-VFPv3 and CONFIG_VFPv3 set
         [39141ddfb63a664f26d3f42f64ee386e879b492c]

Paulo Zanoni (1):
      drm/i915: make the panel fitter work on pipes B and C on IVB
         [13888d78c664a1f61d7b09d282f5916993827a40]

Peter Korsgaard (1):
      usb: ftdi_sio: fixup BeagleBone A5+ quirk
         [1a88d5eee2ef2ad1d3c4e32043e9c4c5347d4fc1]

Peter Popovec (1):
      Input: walkera0701 - fix crash on startup
         [a455e2985f57e2a71566bb8850094af38b2c932d]

Petr Matousek (1):
      KVM: x86: invalid opcode oops on SET_SREGS with OSXSAVE bit set (CVE-2012-4461)
         [6d1068b3a98519247d8ba4ec85cd40ac136dbdf9]

Rafael J. Wysocki (1):
      ACPI / PNP: Do not crash due to stale pointer use during system resume
         [a6b5e88c0e42093b9057856f35770966c8c591e3]

Rafał Miłecki (1):
      bcma: mips: fix clearing device IRQ
         [cbbc0138efe1dcd5426b8fc5d87741f5057aee72]

Rajkumar Manoharan (1):
      ath9k_hw: Enable hw PLL power save for AR9462
         [1680260226a8fd2aab590319da83ad8e610da9bd]

Robin Holt (1):
      SGI-XP: handle non-fatal traps
         [891348ca0f66206f1dc0e30d63757e3df1ae2d15]

Roland Dreier (1):
      iscsi-target: Always send a response before terminating iSCSI connection
         [1c5c12c666fda27c7c494b34934a0a0631a48130]

Russell Webb (1):
      xhci: Add Lynx Point LP to list of Intel switchable hosts
         [bb1e5dd7113d2fd178d3af9aca8f480ae0468edf]

Sarah Sharp (3):
      xHCI: Fix TD Size calculation on 1.0 hosts.
         [4525c0a10dff7ad3669763c28016c7daffc3900e]
      xhci: Extend Fresco Logic MSI quirk.
         [bba18e33f25072ebf70fd8f7f0cdbf8cdb59a746]
      xhci: Fix conditional check in bandwidth calculation.
         [392a07ae3316f2b90b39ce41e66d6f6b5c95de90]

Sarveshwar Bandi (1):
      bonding: Bonding driver does not consider the  gso_max_size/gso_max_segs setting of slave devices.
         [0e376bd0b791ac6ac6bdb051492df0769c840848]

Sasha Levin (1):
      [SCSI] prevent stack buffer overflow in host_reset
         [072f19b4bea31cdd482d79f805413f2f9ac9e233]

Sebastian Andrzej Siewior (5):
      target/file: Fix 32-bit highmem breakage for SGL -> iovec mapping
         [40ff2c3b3da35dd3a00ac6722056a59b4b3f2caf]
      usb: gadget: midi: free hs descriptors
         [d185039f7982eb82cf8d03b6fb6689587ca5af24]
      usb: gadget: network: fix bind() error path
         [e79cc615a9bb44da72c499ccfa2c9c4bbea3aa84]
      usb: gadget: phonet: free requests in pn_bind()'s error path
         [d0eca719dd11ad0619e8dd6a1f3eceb95b0216dd]
      usb: gadget: uvc: fix error path in uvc_function_bind()
         [0f9df939385527049c8062a099fbfa1479fe7ce0]

Sebastian Ott (1):
      s390/cio: fix pgid reserved check
         [d99e79ec5574fc556c988f613ed6175f6de66f4a]

Sergei Shtylyov (1):
      usb: musb: cppi_dma: export cppi_interrupt()
         [8b416b0b25d5d8ddb3a91c1d20e1373582c50405]

Seth Heasley (1):
      ALSA: hda - Add Lynx Point HD Audio Controller DeviceIDs
         [8bc039a1e15a72da8426b84293723fb7181f0b5e]

Shuah Khan (1):
      powerpc: fix wii_memory_fixups() compile error on 3.0.y tree
         [not upstream; code has been removed]

Srinidhi KASAGAR (1):
      drivers/leds/leds-lp5521.c: ret may be uninitialized
         [42960b76d2c6a44d7e8000f4eb9a4ca1780059ff]

Stanislaw Gruszka (2):
      Revert: "rt2x00: Don't let mac80211 send a BAR when an AMPDU subframe fails"
         [ab9d6e4ffe192427ce9e93d4f927b0faaa8a941e]
      mac80211: introduce IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL
         [5b632fe85ec82e5c43740b52e74c66df50a37db3]

Stephan Gatzka (1):
      firewire: net: Fix handling of fragmented multicast/broadcast packets.
         [9d2373420900a39f5212a3b289331aa3535b1000]

Steven Rostedt (1):
      ring-buffer: Fix NULL pointer if rb_set_head_page() fails
         [54f7be5b831254199522523ccab4c3d954bbf576]

Takashi Iwai (6):
      ALSA: hda - Add stereo-dmic fixup for Acer Aspire One 522
         [63a077e27648b4043b1ca1b4e29f0c42d99616b6]
      ALSA: hda - Always turn on pins for HDMI/DP
         [6169b673618bf0b2518ce413b54925782a603f06]
      ALSA: hda - Fix pin configuration of HP Pavilion dv7
         [8ae5865ec77c22462c736846a0679947a6953548]
      ALSA: hda - Fix the wrong pincaps set in ALC861VD dallas/hp fixup
         [b78562b10fa66175e30b76073e32a0ad8d92aa83]
      ALSA: usb-audio: Avoid autopm calls after disconnection
         [59866da9e4ae54819e3c4e0a8f426bdb0c2ef993]
      ALSA: usb-audio: Fix missing autopm for MIDI input
         [f5f165418cabf2218eb466c0e94693b8b1aee88b]

Tejun Heo (4):
      cgroup: cgroup_subsys->fork() should be called after the task is added to css_set
         [5edee61edeaaebafe584f8fb7074c1ef4658596b]
      cgroup: remove incorrect dget/dput() pair in cgroup_create_dir()
         [175431635ec09b1d1bba04979b006b99e8305a83]
      freezer: add missing mb's to freezer_count() and freezer_should_skip()
         [dd67d32dbc5de299d70cc9e10c6c1e29ffa56b92]
      workqueue: convert BUG_ON()s in __queue_delayed_work() to WARN_ON_ONCE()s
         [fc4b514f2727f74a4587c31db87e0e93465518c3]

Thomas Gleixner (1):
      genirq: Always force thread affinity
         [04aa530ec04f61875b99c12721162e2964e3318c]

Tommi Rantala (2):
      sctp: fix -ENOMEM result with invalid user space pointer  in sendto() syscall
         [6e51fe7572590d8d86e93b547fab6693d305fd0d]
      sctp: fix memory leak in sctp_datamsg_from_user() when  copy from user space fails
         [be364c8c0f17a3dd42707b5a090b318028538eb9]

Wei Yongjun (1):
      iscsit: use GFP_ATOMIC under spin lock
         [3c989d7603872bf878840f7ce3ea49b73bea4c6c]

Will Deacon (4):
      ARM: mm: use pteval_t to represent page protection values
         [864aa04cd02979c2c755cb28b5f4fe56039171c0]
      mm: highmem: export kmap_to_page for modules
         [f0263d2d222e9e25f2587e51a9dc58c6fb2a9352]
      virtio: 9p: correctly pass physical address to userspace for high pages
         [b9cdc88df8e63e81c723b82c286fc97f5d0dc325]
      virtio: force vring descriptors to be allocated from lowmem
         [b92b1b89a33c172c075edccf6afb0edc41d851fd]

Wolfram Sang (1):
      mtd: nand: gpmi: reset BCH earlier, too, to avoid NAND startup problems
         [6f2a6a52560ad8d85710aabd92b7a3239b3a6b07]

Wu Fengguang (1):
      ALSA: hda - add id for Atom Cedar Trail HDMI codec
         [6edc59e602b36cd3c95a426ef6e8cad0344af8c7]

Xi Wang (1):
      [SCSI] mvsas: fix undefined bit shift
         [beecadea1b8d67f591b13f7099559f32f3fd601d]

Xiaotian Feng (1):
      [libata] fix Null pointer dereference on disk error
         [26cd4d65deba587f3cf2329b6869ce02bcbe68ec]

Yanchuan Nian (1):
      nfs: fix wrong object type in lockowner_slab
         [3c40794b2dd0f355ef4e6bf8d85af5dcd7da7ece]

Yi Zou (1):
      target/tcm_fc: fix the lockdep warning due to inconsistent lock state
         [9f4ad44b264f8bb61ffdd607148215566568430d]

Zhang Rui (2):
      ACPI / video: ignore BIOS initial backlight value for HP Folio 13-2000
         [129ff8f8d58297b04f47b5d6fad81aa2d08404e1]
      ACPI: do acpisleep dmi check when CONFIG_ACPI_SLEEP is set
         [0ac1b1d7b7424cd6f129b5454b504b3cae746f0e]

 Documentation/hwmon/coretemp                       |   12 +-
 Makefile                                           |    4 +-
 arch/arm/include/asm/hwcap.h                       |    3 +-
 arch/arm/include/asm/vfpmacros.h                   |   12 +-
 arch/arm/kernel/swp_emulate.c                      |    2 +
 arch/arm/mm/mmu.c                                  |    2 +-
 arch/arm/vfp/vfpmodule.c                           |    9 +-
 arch/cris/include/asm/io.h                         |   39 ++-
 arch/mips/kernel/process.c                         |    4 +-
 arch/powerpc/kernel/head_64.S                      |    2 +-
 arch/powerpc/kvm/44x_emulate.c                     |    2 +
 arch/powerpc/platforms/embedded6xx/wii.c           |    6 +-
 arch/s390/kvm/kvm-s390.c                           |    2 +-
 arch/x86/kernel/hpet.c                             |    4 +-
 arch/x86/kvm/x86.c                                 |    6 +
 drivers/acpi/battery.c                             |   77 +++++
 drivers/acpi/processor_driver.c                    |    1 +
 drivers/acpi/sleep.c                               |  340 ++++++++++----------
 drivers/acpi/video.c                               |   14 +
 drivers/acpi/video_detect.c                        |   37 +++
 drivers/ata/libata-core.c                          |    1 +
 drivers/ata/libata-eh.c                            |    1 +
 drivers/ata/libata-scsi.c                          |    6 +-
 drivers/ata/sata_promise.c                         |   15 +-
 drivers/ata/sata_svw.c                             |   35 ++
 drivers/atm/solos-pci.c                            |    5 +-
 drivers/base/regmap/regmap-debugfs.c               |    2 +-
 drivers/bcma/driver_mips.c                         |    2 +-
 drivers/bluetooth/ath3k.c                          |    1 +
 drivers/bluetooth/btusb.c                          |    3 +
 drivers/char/agp/intel-agp.h                       |    1 +
 drivers/char/agp/intel-gtt.c                       |    2 +
 drivers/char/ramoops.c                             |    4 +-
 drivers/edac/i7300_edac.c                          |    8 +-
 drivers/edac/i82975x_edac.c                        |   11 +-
 drivers/firewire/net.c                             |   13 +-
 drivers/gpu/drm/drm_crtc_helper.c                  |    4 +-
 drivers/gpu/drm/drm_edid.c                         |    5 +
 drivers/gpu/drm/i915/i915_debugfs.c                |    4 +-
 drivers/gpu/drm/i915/i915_drv.c                    |    1 +
 drivers/gpu/drm/i915/i915_gem.c                    |    5 +
 drivers/gpu/drm/i915/i915_irq.c                    |    4 +-
 drivers/gpu/drm/i915/i915_reg.h                    |    2 +
 drivers/gpu/drm/i915/intel_bios.c                  |   11 +-
 drivers/gpu/drm/i915/intel_display.c               |   95 +++---
 drivers/gpu/drm/i915/intel_drv.h                   |    5 +-
 drivers/gpu/drm/i915/intel_lvds.c                  |   16 +
 drivers/gpu/drm/radeon/atombios_crtc.c             |    5 +
 drivers/gpu/drm/radeon/atombios_encoders.c         |    2 +-
 drivers/gpu/drm/radeon/evergreen.c                 |    4 +-
 drivers/hid/hid-apple.c                            |    3 +
 drivers/hid/hid-core.c                             |    1 +
 drivers/hid/hid-ids.h                              |    1 +
 drivers/hid/hid-magicmouse.c                       |    2 +
 drivers/hwmon/coretemp.c                           |   34 +-
 drivers/hwmon/fam15h_power.c                       |    4 +
 drivers/input/joystick/walkera0701.c               |    7 +-
 drivers/input/serio/i8042-x86ia64io.h              |    9 +
 drivers/iommu/intel-iommu.c                        |   11 +-
 drivers/leds/leds-lp5521.c                         |   16 +-
 drivers/md/dm-ioctl.c                              |    8 +
 drivers/md/persistent-data/dm-btree-internal.h     |   16 +-
 drivers/md/persistent-data/dm-btree-remove.c       |   50 +--
 drivers/md/persistent-data/dm-btree-spine.c        |    6 +-
 drivers/md/persistent-data/dm-btree.c              |   22 +-
 drivers/mfd/mfd-core.c                             |   15 +-
 drivers/misc/hpilo.c                               |   11 +-
 drivers/misc/sgi-xp/xpc_main.c                     |   34 +-
 drivers/mmc/host/sh_mmcif.c                        |    4 -
 drivers/mtd/nand/gpmi-nand/gpmi-lib.c              |    9 +
 drivers/net/bonding/bond_main.c                    |    7 +
 drivers/net/bonding/bond_sysfs.c                   |    2 +
 drivers/net/can/dev.c                              |    3 +-
 drivers/net/ethernet/8390/ne.c                     |    1 +
 drivers/net/irda/sir_dev.c                         |    2 +-
 drivers/net/usb/ipheth.c                           |    5 +
 drivers/net/wimax/i2400m/i2400m-usb.h              |    3 +
 drivers/net/wimax/i2400m/usb.c                     |    6 +
 .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   |  172 +++++-----
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h     |    6 +-
 drivers/net/wireless/ath/ath9k/ar9003_hw.c         |   11 +-
 drivers/net/wireless/ath/ath9k/calib.c             |    1 +
 drivers/net/wireless/ath/ath9k/calib.h             |    3 +
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c   |   35 +-
 drivers/net/wireless/rt2x00/rt2800lib.c            |    3 +-
 drivers/pnp/pnpacpi/core.c                         |    5 +-
 drivers/regulator/wm831x-dcdc.c                    |    2 +-
 drivers/s390/cio/device_pgid.c                     |   10 +-
 drivers/scsi/aha152x.c                             |    4 +-
 drivers/scsi/hpsa.c                                |   32 +-
 drivers/scsi/mvsas/mv_94xx.h                       |   14 +-
 drivers/scsi/mvsas/mv_sas.h                        |    2 +-
 drivers/scsi/qla2xxx/qla_os.c                      |    4 +-
 drivers/scsi/scsi_sysfs.c                          |   11 +-
 drivers/staging/bcm/InterfaceInit.c                |    4 +-
 drivers/staging/bcm/InterfaceInit.h                |    5 +-
 drivers/staging/vt6656/dpc.c                       |    4 +-
 drivers/staging/vt6656/key.c                       |   53 ++-
 drivers/staging/vt6656/key.h                       |    8 +-
 drivers/staging/vt6656/mac.c                       |    6 +-
 drivers/staging/vt6656/rf.c                        |    3 +
 drivers/staging/vt6656/rxtx.c                      |   18 +-
 drivers/staging/vt6656/ttype.h                     |   16 +-
 drivers/staging/vt6656/wcmd.c                      |   20 +-
 drivers/staging/vt6656/wpa2.h                      |    4 +-
 drivers/target/iscsi/iscsi_target.c                |    2 +-
 drivers/target/iscsi/iscsi_target_login.c          |    8 +-
 drivers/target/iscsi/iscsi_target_nego.c           |   10 +-
 drivers/target/target_core_file.c                  |    9 +-
 drivers/target/tcm_fc/tfc_sess.c                   |    2 +-
 drivers/telephony/ixj.c                            |   24 +-
 drivers/usb/class/cdc-wdm.c                        |    4 +-
 drivers/usb/core/message.c                         |   53 +--
 drivers/usb/gadget/f_ecm.c                         |    4 +-
 drivers/usb/gadget/f_eem.c                         |    5 +-
 drivers/usb/gadget/f_midi.c                        |    1 +
 drivers/usb/gadget/f_ncm.c                         |    4 +-
 drivers/usb/gadget/f_phonet.c                      |    8 +-
 drivers/usb/gadget/f_rndis.c                       |    4 +-
 drivers/usb/gadget/f_subset.c                      |    4 +-
 drivers/usb/gadget/f_uvc.c                         |   39 +--
 drivers/usb/host/ehci-pci.c                        |    3 +-
 drivers/usb/host/ehci-q.c                          |   16 +-
 drivers/usb/host/ehci-sched.c                      |    4 +-
 drivers/usb/host/ohci-q.c                          |   19 ++
 drivers/usb/host/pci-quirks.c                      |    4 +-
 drivers/usb/host/xhci-mem.c                        |   11 +-
 drivers/usb/host/xhci-pci.c                        |    7 +-
 drivers/usb/host/xhci-ring.c                       |   32 +-
 drivers/usb/host/xhci.c                            |    4 +-
 drivers/usb/musb/cppi_dma.c                        |    1 +
 drivers/usb/serial/cp210x.c                        |    1 +
 drivers/usb/serial/ftdi_sio.c                      |    3 +-
 drivers/usb/serial/ftdi_sio_ids.h                  |    6 +
 drivers/usb/serial/option.c                        |   25 ++
 drivers/usb/storage/Kconfig                        |    2 +-
 drivers/virtio/virtio_ring.c                       |    7 +
 fs/binfmt_misc.c                                   |    5 +-
 fs/binfmt_script.c                                 |    4 +-
 fs/dcache.c                                        |    2 +-
 fs/exec.c                                          |   18 +-
 fs/ext4/acl.c                                      |    6 +-
 fs/ext4/inode.c                                    |    1 +
 fs/nfs/client.c                                    |    3 +-
 fs/nfs/nfs4proc.c                                  |   21 +-
 fs/nfsd/nfs4proc.c                                 |    8 +-
 fs/nfsd/nfs4state.c                                |    2 +-
 fs/nfsd/nfs4xdr.c                                  |   11 +-
 fs/nfsd/nfssvc.c                                   |    2 +-
 fs/nfsd/vfs.c                                      |   10 +-
 fs/proc/array.c                                    |    2 +-
 fs/udf/inode.c                                     |    4 +
 include/linux/binfmts.h                            |    1 +
 include/linux/cgroup.h                             |    1 -
 include/linux/freezer.h                            |   51 ++-
 include/linux/highmem.h                            |    7 +
 include/linux/mempolicy.h                          |   16 -
 include/linux/pci_ids.h                            |    1 +
 include/net/mac80211.h                             |    5 +
 kernel/cgroup.c                                    |   52 ++-
 kernel/cgroup_freezer.c                            |   13 +-
 kernel/fork.c                                      |    9 +-
 kernel/irq/manage.c                                |   23 +-
 kernel/rcutree.c                                   |   14 +-
 kernel/sched_autogroup.c                           |    4 -
 kernel/sched_autogroup.h                           |    5 -
 kernel/sys.c                                       |    2 +-
 kernel/trace/ftrace.c                              |    2 +-
 kernel/trace/ring_buffer.c                         |    7 +-
 kernel/workqueue.c                                 |    4 +-
 mm/dmapool.c                                       |   31 +-
 mm/highmem.c                                       |   13 +
 mm/huge_memory.c                                   |    3 +
 mm/memory.c                                        |   18 +-
 mm/mempolicy.c                                     |   22 --
 mm/shmem.c                                         |   26 +-
 mm/vmscan.c                                        |   27 +-
 net/9p/trans_virtio.c                              |    3 +-
 net/bluetooth/rfcomm/sock.c                        |    4 +-
 net/ipv4/ip_fragment.c                             |   19 +-
 net/mac80211/status.c                              |    6 +-
 net/sctp/chunk.c                                   |   20 +-
 net/sctp/socket.c                                  |    4 +-
 security/device_cgroup.c                           |    6 +-
 sound/pci/hda/hda_intel.c                          |    5 +
 sound/pci/hda/patch_conexant.c                     |    1 +
 sound/pci/hda/patch_hdmi.c                         |   20 +-
 sound/pci/hda/patch_realtek.c                      |    5 +-
 sound/pci/hda/patch_sigmatel.c                     |    2 +-
 sound/usb/midi.c                                   |   91 ++++--
 190 files changed, 1641 insertions(+), 926 deletions(-)

-- 
Ben Hutchings
The world is coming to an end.	Please log off.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab2EFWei (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 18:34:38 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63970 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780Ab2EFWef convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 18:34:35 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 6 May 2012 15:34:14 -0700
X-Google-Sender-Auth: piGXalA1sCjpi5wbDHXBHdTELSc
Message-ID: <CA+55aFzeReHRbuS59NNem2wkQvR0s2SQ+mjY3FDJ-UuRjT-csg@mail.gmail.com>
Subject: Linux 3.4-rc6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another week, another -rc - and I think we're getting close to final
3.4. So please do test.

There still are more commits here than I'd like, so it would be nice
if things would calm down even further, but things on the whole have
been pretty smalll and simple.

About half the commits are drivers (and networking driver changes
account for almost half of that), with the rest being mostly arch
(powerpc and arm), fs (btrfs and nfs) and networking (non-driver
changes).

But all of the commits look pretty damn trivial, so on the whole I
feel good about things.

Go forth and test,

                   Linus
---

AceLan Kao (2):
      Bluetooth: Add support for Atheros [13d3:3362]
      Bluetooth: Add support for AR3012 [0cf3:e004]

Al Viro (1):
      x86: fix broken TASK_SIZE for ia32_aout

Alan Cox (1):
      vt: Fix deadlock on scroll-lock

Alan Stern (1):
      EHCI: update PM methods in ehci-tegra.c

Alex Deucher (1):
      drm/radeon: clarify and extend wb setup on APUs and NI+ asics

Alexander Block (1):
      btrfs: Fix mismatching struct members in ioctl.h

Alexander Duyck (1):
      ixgbe: Fix a memory leak in IEEE DCB

Alok Chauhan (1):
      i2c: tegra: Add delay before resetting the controller after NACK

Anatolij Gustschin (1):
      net/davinci_emac: fix failing PHY connect attempts

Andreas Herrmann (1):
      x86/amd: Re-enable CPU topology extensions in case BIOS has disabled it

Andy Adamson (1):
      NFSv4.1 fix page number calculation bug for filelayout decode buffers

Antony Pavlov (1):
      MIPS: JZ4740: Fix the JZ4740_IRQ_DMA macro

Ben Skeggs (3):
      drm/nouveau/bios: fix regression on some nv4x board
      drm/nouveau/hdmi: use correct hdmi regs for nvaa/nvac
      drm/nv10/gpio: fix thinko in mask for gpio lines 2-9

Benjamin Herrenschmidt (1):
      Input: synaptics - fix regression with "image sensor" trackpads

Benjamin Poirier (1):
      tlan: add cast needed for proper 64 bit operation

Bjarke Istrup Pedersen (1):
      arch/x86/platform/geode/net5501.c: change active_low to 0 for LED driver

Bryan Schumaker (6):
      NFS: Fix SECINFO_NO_NAME
      NFS: Handle exceptions coming out of nfs4_proc_fs_locations()
      NFS: Do secinfo as part of lookup
      NFS: Fix following referral mount points with different security
      NFS: Honor the authflavor set in the clone mount data
      NFS: Remove unused function nfs_lookup_with_sec()

Chris Mason (2):
      Btrfs: Add properly locking around add_root_to_dirty_list
      Btrfs: avoid sleeping in verify_parent_transid while atomic

Chris Wilson (2):
      drm/i915: Do not read non-existent DPLL registers on PCH hardware
      drm/i915: Only enable IPS polling for gen5

Christoph Bumiller (1):
      nvc0/fb: shut up PMFB interrupt after the first occurrence

Dan Williams (7):
      [SCSI] libsas: introduce sas_work to fix sas_drain_work vs sas_queue_work
      [SCSI] libsas: fix sas_get_port_device regression
      [SCSI] libsas: unify domain_device sas_rphy lifetimes
      [SCSI] libsas: fix ata_eh clobbering ex_phys via smp_ata_check_ready
      [SCSI] libsas, libata: fix start of life for a sas ata_port
      [SCSI] libsas: fix false positive 'device attached' conditions
      [SCSI] Revert "[SCSI] libsas: fix sas port naming"

Dave Airlie (1):
      nouveau: initialise has_optimus variable.

Dave Jones (1):
      CPU frequency drivers MAINTAINERS update

David Daney (1):
      MIPS: Remove get_current_pgd().

Eldad Zack (1):
      brcmsmac: "INTERMEDIATE but not AMPDU" only when tracing

Eliad Peller (1):
      mac80211: call ieee80211_mgd_stop() on interface stop

Eric Bénard (1):
      ASoC: tlv312aic23: unbreak resume

Eric Dumazet (4):
      net: fix sk_sockets_allocated_read_positive
      net: fix two typos in skbuff.h
      netem: fix possible skb leak
      tcp: change tcp_adv_win_scale and tcp_rmem[2]

Fabio Estevam (1):
      ASoC: dt: sgtl5000.txt: Add description for 'reg' field

Felix Fietkau (1):
      mac80211: fix AP mode EAP tx for VLAN stations

Franky Lin (2):
      brcm80211: fmac: fix SDIO function 0 register r/w issue
      brcm80211: fmac: fix missing completion events issue

Gabor Juhos (3):
      ath9k: add an extra boolean parameter to ath9k_hw_apply_txpower
      ath9k: fix tx power settings for AR9287
      MIPS: ath79: fix AR933X WMAC reset code

Gavin Shan (1):
      powerpc/pseries: Rivet CONFIG_EEH for pSeries platform

Gerard Lledo (1):
      sungem: Fix WakeOnLan

Grant Likely (2):
      powerpc/8xx: Fix NR_IRQ bugs and refactor 8xx interrupt controller
      powerpc/irqdomain: Fix broken NR_IRQ references

Grazvydas Ignotas (2):
      wl1251: fix crash on remove due to premature kfree
      wl1251: fix crash on remove due to leftover work item

Greg Kroah-Hartman (1):
      hfsplus: Fix potential buffer overflows

Guenter Roeck (1):
      hwmon: (coretemp) Increase CPU core limit

H. Peter Anvin (1):
      asm-generic: Use __BITS_PER_LONG in statfs.h

Hans Schillstrom (3):
      ipvs: null check of net->ipvs in lblc(r) shedulers
      ipvs: take care of return value from protocol init_netns
      ipvs: kernel oops - do_ip_vs_get_ctl

Heiko Stübner (1):
      ASoC: s3c2412-i2s: Fix dai registration

Ian Kent (1):
      cifs - check S_AUTOMOUNT in revalidate

Ingo van Lil (1):
      asix: Fix tx transfer padding for full-speed USB

Jan Seiffert (1):
      bpf jit: Let the powerpc jit handle negative offsets

Jeff Kirsher (1):
      e1000e: Fix default interrupt throttle rate not set in NIC HW

Jeff Layton (3):
      cifs: don't cap ra_pages at the same level as default_backing_dev_info
      cifs: add missing initialization of server->req_lock
      cifs: make sure we ignore the credentials= and cred= options

Jeff Mahoney (1):
      dl2k: Clean up rio_ioctl

Jim Faulkner (1):
      alpha: include module.h to fix modpost on Tsunami

Jim Rees (1):
      fix page number calculation bug for block layout decode buffer

Jiri Slaby (1):
      TTY: pdc_cons, fix regression in close

Joakim Tjernlund (2):
      net: ucc_geth, increase no. of HW RX descriptors
      ucc_geth: Add 16 bytes to max TX frame for VLANs

Johannes Berg (1):
      iwlwifi: fix hardware queue programming

John Stultz (1):
      rtc: Fix possible null pointer dereference in rtc-mpc5121.c

Jonathan Bither (1):
      ath5k: add missing iounmap to AHB probe removal

Josef Bacik (1):
      Btrfs: fix page leak when allocing extent buffers

Julian Anastasov (3):
      ipvs: fix crash in ip_vs_control_net_cleanup on unload
      ipvs: add check in ftp for initialized core
      ipvs: reset ipvs pointer in netns

Kirill A. Shutemov (1):
      hwmon: (coretemp) fix oops on cpu unplug

Kusanagi Kouichi (1):
      x86, relocs: Remove an unused variable

Larry Finger (2):
      rtlwifi: Fix oops on unload
      tty/serial/pmac_zilog: Fix "nobody cared" IRQ message

Lars-Peter Clausen (1):
      ASoC: bf5xx-ssm2602: Set DAI format

Lin Ming (4):
      [SCSI] scsi_lib: use correct DMA device in __scsi_alloc_queue
      [SCSI] libata: Pass correct DMA device to scsi host
      libata: skip old error history when counting probe trials
      ACPI: Fix D3hot v D3cold confusion

Linus Torvalds (4):
      vfs: make word-at-a-time accesses handle a non-existing page
      Fix __read_seqcount_begin() to use ACCESS_ONCE for sequence value read
      seqlock: add 'raw_seqcount_begin()' function
      Linux 3.4-rc6

Linus Walleij (1):
      ARM: 7390/1: dts: versatile-pb/ab fix MMC IRQs

Manoj Iyer (1):
      Bluetooth: btusb: Add vendor specific ID (0489 e042) for BCM20702A0

Marc Gariepy (1):
      fixing dmi match for hp t5745 and hp st5747 thin client

Mark Brown (2):
      ASoC: wm_hubs: Make sure we don't disable differential line outputs
      ASoC: wm8350: Don't use locally allocated codec struct

Matt Carlson (1):
      tg3: Avoid panic from reserved statblk field access

Matt Fleming (1):
      MIPS: Use set_current_blocked() and block_sigmask()

Matt Johnson (1):
      ahci: Detect Marvell 88SE9172 SATA controller

Matt Turner (3):
      alpha: VGA_HOSE depends on VGA_CONSOLE
      alpha: properly define get/set_rtc_time on Marvel/SMP
      alpha: silence 'const' warning in sys_marvel.c

Matthew Garrett (3):
      efi: Add new variable attributes
      efi: Validate UEFI boot variables
      efivars: Improve variable validation

Meenakshi Venkataraman (1):
      iwlwifi: use correct released ucode version

Neal Cardwell (1):
      tcp: clean up use of jiffies in tcp_rcv_rtt_measure()

Neil Horman (3):
      drop_monitor: fix sleeping in invalid context warning
      drop_monitor: Make updating data->skb smp safe
      drop_monitor: prevent init path from scheduling on the wrong cpu

NeilBrown (1):
      md/bitmap: fix calculation of 'chunks' - missing shift.

Oleg Matcovschi (1):
      ASoC: omap-pcm: Free dma buffers in case of error.

Pablo Neira Ayuso (1):
      netfilter: xt_CT: fix wrong checking in the timeout assignment path

Paolo Pisati (1):
      smsc95xx: mark link down on startup and let PHY interrupt deal
with carrier changes

Paulo Zanoni (1):
      drm/i915: enable dip before writing data on gen4

Peter Huang (Peng) (1):
      set fake_rtable's dst to NULL to avoid kernel Oops

Prasanna S Panchamukhi (1):
      e1000e: MSI interrupt test failed, using legacy interrupt

Randy Dunlap (1):
      nfsd: fix nfs4recover.c printk format warning

Richard Zhao (1):
      ASoC: core: check of_property_count_strings failure

Roland Dreier (1):
      cxgb3: Don't call cxgb_vlan_mode until q locks are initialized

Roland Stigge (1):
      i2c: pnx: Disable clk in suspend

Russ Dill (2):
      mfd: Fix build breakage in omap-usb-host.c
      ktest.pl: Fix combined usage of BISECT_REVERSE and BISECT_SKIP

Russell King (1):
      ARM: OMAP: fix DMA vs memory ordering

Sachin Bhamare (1):
      pnfs-obj: Remove unused variable from objlayout_get_deviceinfo()

Sachin Prabhu (3):
      Avoid reading past buffer when calling GETACL
      Avoid beyond bounds copy while caching ACL
      CIFS: Fix indentation in cifs_show_options

Samuel Liao (1):
      igbvf: fix the bug when initializing the igbvf

Sasha Levin (3):
      ipvs: Verify that IP_VS protocol has been registered
      net: l2tp: unlock socket lock before returning from l2tp_ip_sendmsg
      init: don't try mounting device as nfs root unless type fully matches

Seth Forshee (1):
      b43: only reload config after successful initialization

Shan Wei (1):
      udp_diag: implement idiag_get_info for udp/udplite to get queue
information

Stanislav Kinsbursky (5):
      SUNRPC: skip dead but not buried clients on PipeFS events
      SUNRPC: skip clients with program without PipeFS entries
      SUNRPC: set per-net PipeFS superblock before notification
      SUNRPC: traverse clients tree on PipeFS event
      NFS: get module in idmap PipeFS notifier callback

Stanislav Yakovlev (1):
      ipw2200: Fix race condition in the command completion acknowledge

Stanislaw Gruszka (1):
      iwlwifi: do not nulify ctx->vif on reset

Stefan Behrens (1):
      Btrfs: fix crash in scrub repair code when device is missing

Stefan Metzmacher (1):
      fs/cifs: fix parsing of dfs referrals

Stefan Raspl (1):
      qeth: Use blkt defaults for OSA Express 4

Stephane Fillod (1):
      net: usb: smsc95xx: fix mtu

Stephen Boyd (1):
      ARM: 7401/1: mm: Fix section mismatches

Stephen Warren (1):
      USB: ehci-tegra: remove redundant gpio_set_value

Steve French (1):
      [CIFS] Update cifs version to 1.78

Steve Glendinning (7):
      smsc75xx: mark link down on startup and let PHY interrupt deal
with carrier changes
      smsc75xx: fix mdio reads and writes
      smsc75xx: add more information to register io failure warnings
      smsc75xx: fix phy init reset loop
      smsc75xx: fix phy interrupt acknowledge
      smsc75xx: declare smsc75xx's MII as GMII capable
      smsc75xx: enable mac to detect speed/duplex from phy

Steven Harms (1):
      Add Foxconn / Hon Hai IDs for btusb module

Steven Rostedt (1):
      ktest: Fix reboot on success stopping all reboots

Szymon Janc (1):
      Bluetooth: Fix missing break in hci_cmd_complete_evt

Tero Roponen (1):
      libata: init ata_print_id to 0

Thadeu Lima de Souza Cascardo (3):
      ehea: only register irq after setting up ports
      ehea: fix allmulticast support
      ehea: fix promiscuous mode

Thomas Jackson (1):
      [SCSI] libsas: fix sas_find_bcast_phy() in the presence of 'vacant' phys

Tomoya MORINAGA (2):
      i2c-eg20t: change timeout value 50msec to 1000msec
      NFSv4.1: Use the correct hostname in the client identifier string

Ursula Braun (1):
      qeth: allow change of blkt default values

Vasu Dev (1):
      [SCSI] libfc: update mfs boundry checking

Viresh Kumar (2):
      ata/pata_arasan_cf: Move arasan_cf_pm_ops out of #ifdef, #endif macros
      ata: ahci_platform: Add synopsys ahci controller in DT's compatible list

Vishal Agarwal (2):
      Bluetooth: hci_persistent_key should return bool
      Bluetooth: Temporary keys should be retained during connection

Vlad Yasevich (1):
      MAINTAINERS: update sctp maintainer address

Weston Andros Adamson (1):
      nfs4: fix referrals on mounts that use IPv6 addrs

Wey-Yi Guy (1):
      iwlwifi: use 6000G2B for 6030 device series

Will Deacon (8):
      ARM: 7396/1: errata: only handle ARM erratum #326103 on affected cores
      ARM: 7397/1: l2x0: only apply workaround for erratum #753970 on PL310
      ARM: 7398/1: l2x0: only write to debug registers on PL310
      ARM: 7399/1: vfp: move user vfp state save/restore code out of signal.c
      ARM: 7400/1: vfp: clear fpscr length and stride bits on entry to
sig handler
      ARM: 7403/1: tls: remove covert channel via TPIDRURW
      ARM: 7405/1: kexec: call platform_cpu_kill on the killer rather
than the victim
      ARM: 7406/1: hotplug: copy the affinity mask when forcefully
migrating IRQs

Wolfram Sang (2):
      i2c: mxs: handle spurious interrupt
      i2c: mxs: disable QUEUE when sending is done

Yi Zou (1):
      ixgbe: fix calling skb_put on nonlinear skb assertion bug

Yong Wang (1):
      intel_mid_powerbtn: mark irq as IRQF_NO_SUSPEND

Yuchung Cheng (1):
      tcp: fix infinite cwnd in tcp_complete_cwr()

alex.bluesman.smirnov@gmail.com (3):
      6lowpan: fix segmentation fault caused by mlme request
      6lowpan: clean up fragments list if module unloaded
      6lowpan: add missing spin_lock_init()

stephen hemminger (2):
      sky2: propogate rx hash when packet is copied
      sky2: fix receive length error in mixed non-VLAN/VLAN traffic

tom.leiming@gmail.com (2):
      usbnet: fix leak of transfer buffer of dev->interrupt
      usbnet: fix failure handling in usbnet_probe

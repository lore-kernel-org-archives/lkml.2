Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab0EPVmX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 17:42:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54867 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751539Ab0EPVmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 17:42:21 -0400
Date: Sun, 16 May 2010 14:39:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.34
Message-ID: <alpine.LFD.2.00.1005161430100.4195@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Nothing very interesting here, which is just how I like it. Various random 
fixes all over, nothing really stands out. Pretty much all of it is one- 
or few-liners, I think the biggest patch in the last week was fixing some 
semantics for the new SR-IOV VF netlink interface. And even that wasn't 
a _big_ patch by any means.

So 2.6.34 is out, and the merge window is thus officially open. As usual, 
I probably won't do any real pulls for a day or two, in the (probably 
futile) hope that we'll have more people running plain 2.6.34 for a while. 
But you can certainly start sending me pull requests.

Go forth and test,

		Linus

---
Al Viro (2):
      Fix the regression created by "set S_DEAD on unlink()..." commit
      Fix double-free in logfs

Alan Cox (1):
      tty: Fix unbalanced BKL handling in error path

Alan Ott (1):
      HID: hidraw: fix numbered reports

Alan Stern (1):
      HID: fix suspend crash by moving initializations earlier

Alex Chiang (1):
      ACPI: sleep: eliminate duplicate entries in acpisleep_dmi_table[]

Anatolij Gustschin (1):
      serial: mpc52xx_uart: fix null pointer dereference

Andreas Herrmann (1):
      x86, amd: Check X86_FEATURE_OSVW bit before accessing OSVW MSRs

Andreas Meissner (1):
      IPv4: unresolved multicast route cleanup

Andrej Gelenberg (1):
      ALSA: hda - add support for Lenovo ThinkPad X100e in conexant codec

Andrew Morton (1):
      drivers/gpu/drm/i915/i915_irq.c:i915_error_object_create(): use correct kmap-atomic slot

André Goddard Rosa (1):
      mqueue: fix kernel BUG caused by double free() on mq_open()

Antonio Ospite (1):
      HID: sony: fix sony_set_operational_bt

Arnaldo Carvalho de Melo (1):
      perf record: Add a fallback to the reference relocation symbol

Bjørn Mork (1):
      ipv4: udp: fix short packet and bad checksum logging

Borislav Petkov (1):
      x86, k8: Fix build error when K8_NB is disabled

Brian Haley (1):
      IPv6: fix IPV6_RECVERR handling of locally-generated errors

Catalin Marinas (5):
      ARM: 6105/1: Fix the __arm_ioremap_caller() definition in nommu.c
      ARM: 6106/1: Implement copy_to_user_page() for noMMU
      ARM: 6111/1: Implement read/write for ownership in the ARMv6 DMA cache ops
      ARM: 6112/1: Use the Inner Shareable I-cache and BTB ops on ARMv7 SMP
      ARM: 6110/1: Fix Thumb-2 kernel builds when UACCESS_WITH_MEMCPY is enabled

Chandrakala Chavva (1):
      MIPS: N32: Use compat version for sys_ppoll.

Chris Wright (1):
      rtnetlink: make SR-IOV VF interface symmetric

Christian Lamparter (1):
      ar9170: wait for asynchronous firmware loading

Clemens Ladisch (1):
      ALSA: virtuoso: fix Xonar D1/DX front panel microphone

Cory Fields (1):
      HID: wacom: remove annoying non-error printk

Dan Carpenter (1):
      fs/sysv: dereferencing ERR_PTR()

Dan Rosenberg (1):
      Btrfs: check for read permission on src file in the clone ioctl

Daniel T Chen (1):
      ALSA: hda: Fix 0 dB for Lenovo models using Conexant CX20549 (Venice)

David Howells (2):
      CacheFiles: Fix occasional EIO on call to vfs_unlink()
      CacheFiles: Fix error handling in cachefiles_determine_cache_security()

David Rientjes (1):
      x86: Fix fake apicid to node mapping for numa emulation

David S. Miller (2):
      phy: Fix initialization in micrel driver.
      net: Fix FDDI and TR config checks in ipv4 arp and LLC.

Denis Turischev (1):
      it8761e_gpio: fix bug in gpio numbering

Dmitry Torokhov (2):
      Input: elantech - use all 3 bytes when checking version
      Input: psmouse - reset all types of mice before reconnecting

Dongxiao Xu (1):
      KVM: x86: Call vcpu_load and vcpu_put in cpuid_update

Eric Dumazet (2):
      veth: Dont kfree_skb() after dev_forward_skb()
      tcp: fix MD5 (RFC2385) support

Eric Paris (2):
      inotify: clean up the inotify_add_watch out path
      inotify: race use after free/double free in inotify inode marks

FUJITA Tomonori (1):
      dma-mapping: fix dma_sync_single_range_*

Frank Arnold (1):
      x86, cacheinfo: Turn off L3 cache index disable feature in virtualized environments

Frederic Weisbecker (1):
      perf: Fix static strings treated like dynamic ones

Gerald Schaefer (1):
      [S390] ptrace: fix return value of do_syscall_trace_enter()

H. Peter Anvin (1):
      x86, mrst: Don't blindly access extended config space

Henrik Rydberg (1):
      hwmon: (applesmc) Correct sysfs fan error handling

Hugh Dickins (2):
      hughd: update email address
      profile: fix stats and data leakage

Ian Kent (1):
      autofs4-2.6.34-rc1 - fix link_count usage

Jan Blunck (1):
      JFS: Free sbi memory in error path

Jan Kara (1):
      vfs: Fix O_NOFOLLOW behavior for paths with trailing slashes

Jan Kiszka (1):
      KVM: VMX: blocked-by-sti must not defer NMI injections

Jean Delvare (1):
      drm/radeon: Fix 3 regressions - since buffer rework

Jeff Layton (1):
      cifs: guard against hardlinking directories

Jiri Kosina (1):
      HID: ntrig: explain firmware quirk

Joerg Roedel (1):
      KVM: SVM: Fix wrong intercept masks on 32 bit

Johannes Berg (1):
      iwlwifi: work around passive scan issue

KAMEZAWA Hiroyuki (2):
      memcg: fix css_id() RCU locking for real
      memcg: fix css_is_ancestor() RCU locking

Kees Cook (1):
      mmap_min_addr check CAP_SYS_RAWIO only for write

Ken Milmore (1):
      hwmon: (asc7621) Bug fixes

Kumar Gala (1):
      powerpc/swiotlb: Fix off by one in determining boundary of which ops to use

Linus Torvalds (2):
      Revert "PCI: update bridge resources to get more big ranges in PCI assign unssigned"
      Linus 2.6.34

Marcelo Tosatti (1):
      KVM: convert ioapic lock to spinlock

Marek Vasut (2):
      Input: iforce - add Guillemot Jet Leader Force Feedback
      Input: iforce - fix Guillemot Jet Leader 3D entry

Mark Brown (1):
      mfd: Clean up after WM83xx AUXADC interrupt if it arrives late

Martin Schwidefsky (1):
      [S390] correct address of _stext with CONFIG_SHARED_KERNEL=y

Masami Hiramatsu (1):
      kprobes/x86: Fix removed int3 checking order

Mel Gorman (1):
      hugetlbfs: kill applications that use MAP_NORESERVE with SIGBUS instead of OOM-killer

Michael Hennerich (1):
      fbdev: bfin-t350mcqb-fb: fix fbmem allocation with blanking lines

Michael S. Tsirkin (1):
      vhost: fix barrier pairing

Michal Simek (4):
      microblaze: Remove compilation warnings in cache macro
      microblaze: Remove powerpc code from Microblaze port
      microblaze: export assembly functions used by modules
      microblaze: Fix module loading on system with WB cache

Michel Lespinasse (1):
      rwsem: Test for no active locks in __rwsem_do_wake undo code

Naoya Horiguchi (1):
      rmap: remove anon_vma check in page_address_in_vma()

Nicolas Ferre (5):
      mmc: atmel-mci: fix two parameters swapped
      mmc: atmel-mci: prevent kernel oops while removing card
      mmc: atmel-mci: remove data error interrupt after xfer
      mmc: atmel-mci: fix in debugfs: response value printing
      mmc: at91_mci: modify cache flush routines

Oliver Neukum (1):
      hp_accel: fix race in device removal

Oskar Schirmer (1):
      Input: ad7877 - keep dma rx buffers in seperate cache lines

Paul Mackerras (1):
      powerpc/perf_event: Fix oops due to perf_event_do_pending call

Pavel Emelyanov (1):
      inotify: don't leak user struct on inotify release

Rafi Rubin (3):
      HID: ntrig: Emit TOUCH with DOUBLETAP for single touch
      HID: ntrig: TipSwitch for single touch mode touch.
      HID: ntrig: Remove unused macro, TripleTap and QuadTap

Raphaël Doursenaud (1):
      HID: add support for cymotion master solar keyboard

Reinette Chatre (1):
      mac80211: remove association work when processing deauth request

Robin Holt (1):
      revert "procfs: provide stack information for threads" and its fixup commits

Roel Kluin (1):
      KVM: PPC: Keep index within boundaries in kvmppc_44x_emul_tlbwe()

Russell King (1):
      Inotify: undefined reference to `anon_inode_getfd'

Sage Weil (9):
      ceph: unregister bdi before kill_anon_super releases device name
      ceph: don't use writeback_control in writepages completion
      ceph: unregister osd request on failure
      ceph: fix open file counting on snapped inodes when mds returns no caps
      ceph: resubmit requests on pg mapping change (not just primary change)
      ceph: fix locking for waking session requests after reconnect
      ceph: zero unused message header, footer fields
      ceph: fix cap removal races
      ceph: preserve seq # on requeued messages after transient transport errors

Sebastian Andrzej Siewior (1):
      net/gianfar: drop recycled skbs on MTU change

Sergei Shtylyov (1):
      DA830: fix USB 2.0 clock entry

Shane McDonald (1):
      MIPS FPU emulator: allow Cause bits of FCSR to be writeable by ctc1

Srinidhi Kasagar (2):
      ARM: 6125/1: ARM TWD: move TWD registers to common header
      ARM: 6126/1: ARM mpcore_wdt: fix build failure and other fixes

Stefan Lippers-Hollmann (1):
      ALSA: Revert "ALSA: hda/realtek: quirk for D945GCLF2 mainboard"

Stefan Weinhuber (1):
      [S390] dasd: fix race between tasklet and dasd_sleep_on

Stephane Chatty (1):
      HID: fix N-trig touch panel with recent firmware

Steven J. Magnani (3):
      microblaze: re-enable interrupts before calling schedule
      microblaze: fix get_user/put_user side-effects
      microblaze: export assembly functions used by modules

Takashi Iwai (4):
      ALSA: hda - Fix mute-LED GPIO pin for HP dv series
      ALSA: hda - Add hp-dv4 model for IDT 92HD71bx
      ALSA: pcm - Use pgprot_noncached() for MIPS non-coherent archs
      ALSA: ice1724 - Fix ESI Maya44 capture source control

Valentin Longchamp (1):
      serial: imx.c: fix CTS trigger level lower to avoid lost chars

Vitaliy Gusev (1):
      bsdacct: use del_timer_sync() in acct_exit_ns()

Vitaly Mayatskikh (1):
      kexec: fix OOPS in crash_kernel_shrink

Vlad Yasevich (1):
      sctp: Fix a race between ICMP protocol unreachable and connect()

Wei Yongjun (1):
      sctp: delete active ICMP proto unreachable timer when free transport

Wu Fengguang (1):
      ALSA: hda - fix DG45ID SPDIF output

Wu Zhangjin (1):
      MIPS: Oprofile: Fix Loongson irq handler

kirjanov@gmail.com (1):
      lib/btree: fix possible NULL pointer dereference

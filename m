Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab1AVEND (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 23:13:03 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33151 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753029Ab1AVENA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 23:13:00 -0500
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 21 Jan 2011 20:12:08 -0800
Message-ID: <AANLkTimEe4-YaEn6iHBqcSthSdKH+W69eiJmQAuDS3rv@mail.gmail.com>
Subject: Linux 2.6.38-rc2
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So it's been distinctly less than a week, but I'm leaving for LCA
tomorrow, so I wanted to  (a) get an -rc out before that and (b)
verify that the laptop I'm taking with me is all prepared with the
proper signing keys and silly release scripts etc. So if you see
something odd in the release, holler, and I can still hopefully make
sure I fix up whatever script/config issue I have.

Anyway. -rc2 is out there, and the only reason it's reasonably sized
is that it was a short -rc2 - I think a few of the pull requests I got
were a bit larger than I would have been happy with. And I might as
well warn people that because the laptop I'm bringing with me is
pitifully slow, I'm also planning on going into "anal" mode, and not
even bother pulling from trees unless they are clearly -rc material.
IOW, don't try to push large pushes on me. I won't take them, and they
can wait for 39.

(Which is just as well - we definitely have enough excitement in 38 already)

Of course, it's entirely possible that things will be quiet due to a
number of other maintainers presumably also being at LCA, so hopefully
that "Linus is going into anal mode" warning was totally superfluous.

So give it a good testing,

               Linus

---

Akinobu Mita (2):
      powerpc/spufs: Use simple_write_to_buffer
      powerpc/rtas_flash: Use simple_read_from_buffer

Alexey Orishko (1):
      USB CDC NCM: tx_fixup() race condition fix

Amitkumar Karwar (1):
      ieee80211: correct IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK macro

Andy Walls (12):
      [media] lirc_zilog: Reword debug message in ir_probe()
      [media] lirc_zilog: Remove disable_tx module parameter
      [media] lirc_zilog: Split struct IR into structs IR, IR_tx, and IR_rx
      [media] lirc_zilog: Don't make private copies of i2c clients
      [media] lirc_zilog: Extensive rework of ir_probe()/ir_remove()
      [media] lirc_zilog: Update IR Rx polling kthread start/stop and
some printks
      [media] lirc_zilog: Remove unneeded tests for existence of the
IR Tx function
      [media] lirc_zilog: Remove useless struct i2c_driver.command function
      [media] lirc_zilog: Add Andy Walls to copyright notice and authors list
      [media] lirc_zilog: Update TODO.lirc_zilog
      [media] ir-kbd-i2c: Add back defaults setting for Zilog Z8's at addr 0x71
      [media] pvrusb2: Provide more information about IR units to
lirc_zilog and ir-kbd-i2c

Anisse Astier (1):
      ALSA: hda - Fix EAPD to low on CZC P10T tablet computer with ALC662

Anton Blanchard (20):
      kernel/smp.c: fix smp_call_function_many() SMP race
      powerpc/kexec: Move all ppc_md kexec function pointers together
      powerpc/kexec: Remove ppc_md.machine_kexec_cleanup
      powerpc/kexec: Remove ppc_md.machine_kexec
      powerpc/kdump: Remove ppc_md.machine_crash_shutdown
      powerpc/kexec: Don't initialise kexec hooks to default handlers
      powerpc/kexec: Remove empty ppc_md.machine_kexec_prepare
      powerpc/kdump: Move crash_kexec_stop_spus to kdump crash handler
      powerpc/kdump: Disable ftrace during kexec
      powerpc: Print 32 bits of DSISR in show_regs
      powerpc: Don't force MSR_RI in machine_check_exception
      powerpc: Never halt RTAS error logging after receiving an
unrecoverable machine check
      powerpc: Remove duplicate debugger hook in machine_check_exception
      powerpc: Don't silently handle machine checks from userspace
      powerpc: Rework pseries machine check handler
      powerpc: Fix corruption when grabbing FWNMI data
      powerpc: Check RTAS extended log flag before checking length
      powerpc: machine_check_generic is wrong on 64bit
      powerpc: Disable mcount tracers in pseries defconfig
      powerpc: Enable 64kB pages and 1024 threads in pseries config

Anton Vorontsov (1):
      gianfar: Fix misleading indentation in startup_gfar()

Antti Palosaari (1):
      [media] af9013: fix AF9013 TDA18271 IF config

Axel Lin (1):
      iwmc3200wifi: Return proper error for iwm_if_alloc

Barry Song (2):
      ASoC: Blackfin TDM: use external frame syncs
      ASoC: Blackfin: fix DAI/SPORT config dependency issues

Ben Hutchings (1):
      powerpc/boot/dts: Install dts from the right directory

Benjamin Marzinski (1):
      GFS2: remove iopen glocks from cache on failed deletes

Bharata B Rao (2):
      sched: Reinstate group names in /proc/sched_debug
      sched: Display autogroup names in /proc/sched_debug

Bob Copeland (1):
      ath5k: fix locking in tx_complete_poll_work

Bob Moore (3):
      ACPICA: Debugger: Lock namespace for duration of a namespace dump
      ACPICA: Update all ACPICA copyrights and signons to 2011
      ACPICA: Update version to 20110112

Brian Bloniarz (1):
      ALSA: ice1712 delta - initialize SPI clock

Christian Gmeiner (1):
      [media] adv7175: support s_power

Christoph Lameter (2):
      x86,percpu: Move out of place 64 bit ops into X86_64 section
      lguest: Use this_cpu_ops

Dan Carpenter (2):
      caif: checking the wrong variable
      [media] [v3,media] av7110: check for negative array offset

Dana Myers (1):
      ACPICA: Fix namespace race condition

Daniel De Graaf (3):
      xenbus: add missing wakeup in concurrent read/write
      xenbus: avoid zero returns from read()
      xenbus: Fix memory leak on release

David Dillow (1):
      fs/direct-io.c: don't try to allocate more than BIO_MAX_PAGES in a bio

David Henningsson (1):
      ALSA: HDA: Add SKU ignore for another Thinkpad Edge 14

David Howells (2):
      KEYS: Do some style cleanup in the key management code.
      KEYS: Fix up comments in key management code

David Rientjes (1):
      kconfig: rename CONFIG_EMBEDDED to CONFIG_EXPERT

David S. Miller (1):
      Revert "netlink: test for all flags of the NLM_F_DUMP composite"

Diego Ongaro (1):
      xenbus: allow any xenbus command over /proc/xen/xenbus

Dmitri Belimov (1):
      [media] tm6000: rework init code

Eric Dumazet (1):
      net: fix can_checksum_protocol() arguments swap

Frank Blaschka (1):
      qeth: l3 hw tx csum circumvent hw bug

Geert Uytterhoeven (1):
      [media] radio-aimslab.c needs #include <linux/delay.h>

Grant Likely (1):
      powerpc/83xx: fix build failures on dt compatible list.

Greg Kroah-Hartman (3):
      tty: move hvc drivers to drivers/tty/hvc/
      tty: move drivers/serial/ to drivers/tty/serial/
      tty: update MAINTAINERS file due to driver movement

Hans Verkuil (20):
      [media] tda9875: remove duplicate driver
      [media] bttv: remove obsolete 'no_tda9875' field
      [media] saa7146: Convert from .ioctl to .unlocked_ioctl
      [media] cpia2: convert .ioctl to .unlocked_ioctl
      [media] davinci: convert vpif_capture to core-assisted locking
      [media] davinci: convert vpif_display to core-assisted locking
      [media] radio-maxiradio.c: use sensible frequency range
      [media] radio-gemtek-pci: remove duplicate driver
      [media] v4l2-ioctl: fix incorrect error code if
VIDIOC_DBG_G/S_REGISTER are unsupported
      [media] v4l2-subdev: remove core.s_config and v4l2_i2c_new_subdev_cfg()
      [media] v4l2-subdev: add (un)register internal ops
      [media] v4l2-ctrls: v4l2_ctrl_handler_setup must set is_new to 1
      [media] v4l2-ctrls: fix missing 'read-only' check
      [media] v4l2-ctrls: queryctrl shouldn't attempt to replace
V4L2_CID_PRIVATE_BASE IDs
      [media] DocBook/v4l: fix validation error in dev-rds.xml
      [media] DocBook/v4l: update V4L2 revision and update copyright years
      [media] w9966: zero device state after a detach
      [media] zoran: use video_device_alloc instead of kmalloc
      [media] v4l2-dev: don't memset video_device.dev
      [media] v4l2-device: fix 'use-after-freed' oops

Hans de Goede (19):
      [media] gspca_main: Locking fixes 1
      [media] gspca_main: Locking fixes 2
      [media] gspca_main: Update buffer flags even when user_copy fails
      [media] gspca_main: Remove no longer used users variable
      [media] gspca_main: Set memory type to GSPCA_MEMORY_NO on buffer release
      [media] gspca_main: Simplify read mode memory type checks
      [media] gspca_main: Allow switching from read to mmap / userptr mode
      [media] gspca_main: wake wq on streamoff
      [media] et61x251: remove wrongly claimed usb ids
      [media] sn9c102: Remove not supported and non existing usb ids
      [media] gspca_sonixb: Refactor to unify bridge handling
      [media] gspca_sonixb: Adjust autoexposure window for vga cams so
that it is centered
      [media] gspca_sonixb: Fix TAS5110D sensor gain control
      [media] gspca_sonixb: TAS5130C brightness control really is a gain control
      [media] gspca_sonixb: Add usb ids for known sn9c103 cameras
      [media] gspca_sonixj: Enable more usb ids when sn9c102 gets compiled too
      [media] gspca_sonixj: Probe sensor type independent of bridge type
      [media] gspca_sonixj: Add one more commented out usb-id
      [media] gspca_sonixb: Fix mirrored image with ov7630

Ilya Yanok (1):
      powerpc/mpc8308: fix USB DR controller initialization

Ingo Molnar (1):
      Revert "x86: Make relocatable kernel work with new binutils"

Jan Beulich (1):
      x86: Unify "numa=" command line option handling

Jan Kara (2):
      quota: Fix deadlock during path resolution
      mm: fix truncate_setsize() comment

Janusz Krzysztofik (1):
      drivers/leds/ledtrig-gpio.c: make output match input, tighten
input checking

Jarod Wilson (8):
      [media] rc/imon: fix ffdc device detection oops
      [media] rc/imon: need to submit urb before ffdc type check
      [media] rc: fix up and genericize some time unit conversions
      [media] rc/imon: default to key mode instead of mouse mode
      [media] rc/mceusb: timeout should be in ns, not us
      [media] hdpvr: enable IR part
      [media] hdpvr: reduce latency of i2c read/write w/recycled buffer
      [media] staging/lirc: fix mem leaks and ptr err usage

Jean-François Moine (8):
      [media] gspca: Version change
      [media] gspca: Remove __devinit, __devinitconst and __devinitdata
      [media] gspca: Remove useless instructions
      [media] gspca - ov519: Cleanup source and add a comment
      [media] gspca - ov534: Clearer debug messages
      [media] gspca - ov534: Propagate errors to higher level
      [media] gspca - sonixj: Infrared bug fix and enhancement
      [media] gspca - sonixj: Add LED (illuminator) control to the
webcam 0c45:614a

Jeff Layton (23):
      cifs: don't fail writepages on -EAGAIN errors
      cifs: no need to mark smb_ses_list as cifs_demultiplex_thread is exiting
      cifs: make wait_for_free_request take a TCP_Server_Info pointer
      cifs: clean up accesses to midCount
      cifs: move locked sections out of DeleteMidQEntry and AllocMidQEntry
      cifs: move mid result processing into common function
      cifs: wait indefinitely for responses
      cifs: don't reconnect server when we don't get a response
      cifs: clean up sync_mid_result
      cifs: allow for different handling of received response
      cifs: add cifs_call_async
      cifs: add ability to send an echo request
      cifs: set up recurring workqueue job to do SMB echo requests
      cifs: remove code for setting timeouts on requests
      cifs: mangle existing header for SMB_COM_NT_CANCEL
      cifs: TCP_Server_Info diet
      cifs: move time field in cifsInodeInfo
      cifs: use get/put_unaligned functions to access ByteCount
      cifs: clean up unaligned accesses in validate_t2
      cifs: fix unaligned access in check2ndT2 and coalesce_t2
      cifs: clean up unaligned accesses in cifs_unicode.c
      cifs: fix unaligned accesses in cifsConvertToUCS
      cifs: fix up CIFSSMBEcho for unaligned access

Jeremy Fitzhardinge (1):
      xenfs/xenbus: report partial reads/writes correctly

Jesper Juhl (7):
      rt2x00: Don't leak mem in error path of rt2x00lib_request_firmware()
      batman-adv: Even Batman should not dereference NULL pointers
      ns83820: Avoid bad pointer deref in ns83820_init_one().
      ACPICA: Fix memory leak in acpi_ev_asynch_execute_gpe_method().
      [media] frontends/ix2505v: Remember to free allocated memory in
failure path
      [media] media, tlg2300: Fix memory leak in alloc_bulk_urbs_generic()
      mm/vmscan.c: remove duplicate include of compaction.h

Jesse Gross (1):
      net offloading: Do not mask out NETIF_F_HW_VLAN_TX for vlan.

Johannes Berg (1):
      mac80211: fix lockdep warning

Johannes Weiner (3):
      thp: keep highpte mapped until it is no longer needed
      mm: compaction: prevent division-by-zero during user-requested compaction
      memcg: correctly order reading PCG_USED and pc->mem_cgroup

KAMEZAWA Hiroyuki (4):
      memcg: modify accounting function for supporting THP better
      memcg: fix USED bit handling at uncharge in THP
      memcg: fix LRU accounting with THP
      memcg: fix rmdir, force_empty with THP

Kuninori Morimoto (1):
      net/irda/sh_irda: return to RX mode when TX error

Kurt Van Dijck (1):
      can: test size of struct sockaddr in sendmsg

Kyle McMartin (1):
      [media] rc/ene_ir: fix oops on module load

Laurent Pinchart (2):
      [media] v4l: Include linux/videodev2.h in media/v4l2-ctrls.h
      [media] v4l: Fix a use-before-set in the control framework

Li Yang (1):
      powerpc/85xx: add e500 HID1 bit definition

Lin Ming (1):
      ACPICA: Fix issues/fault with automatic "serialized" method support

Linus Torvalds (4):
      ACPI / Battery: remove battery refresh on resume
      i915: Fix i915 suspend delay
      Fix broken "pipe: use event aware wakeups" optimization
      Linux 2.6.38-rc2

Luciano Coelho (1):
      mac80211: use maximum number of AMPDU frames as default in BA RX

Luis R. Rodriguez (1):
      ath9k_hw: ASPM interoperability fix for AR9380/AR9382

Mats Randgaard (5):
      [media] vpif_cap/disp: Add debug functionality
      [media] vpif: Consolidate formats from capture and display
      [media] vpif_cap/disp: Add support for DV presets
      [media] vpif_cap/disp: Added support for DV timings
      [media] vpif_cap/disp: Cleanup, improved comments

Matti Aaltonen (1):
      [media] V4L2: WL1273 FM Radio: Replace ioctl with unlocked_ioctl

Mauro Carvalho Chehab (12):
      [media] rc-dib0700-nec: Fix keytable for Pixelview SBTVD
      [media] dib0700: Fix IR keycode handling
      [media] ir-kbd-i2c: Make IR debug messages more useful
      [media] em28xx: Fix IR support for WinTV USB2
      [media] tda8290: Make all read operations atomic
      [media] tda8290: Fix a bug if no tuner is detected
      [media] tda8290: Turn tda829x on before touching at the I2C gate
      [media] mb86a20s: Fix i2c read/write error messages
      [media] mb86a20s: Be sure that device is initialized before starting DVB
      [media] saa7134: Fix analog mode for Kworld SBTVD
      [media] saa7134: Fix digital mode on Kworld SBTVD
      [media] saa7134: Kworld SBTVD: make both analog and digital to work

Maxim Levitsky (1):
      firewire: net: invalidate ARP entries of removed nodes

Michael Ellerman (1):
      powerpc: Ensure the else case of feature sections will fit

Michal Simek (1):
      mm: System without MMU do not need pte_mkwrite

Mike Frysinger (2):
      ASoC: Blackfin TDM: fix missed snd_soc_dai_get_drvdata update
      ASoC: Blackfin AC97: fix build error after multi-component update

Mike Galbraith (2):
      sched, autogroup: Fix CONFIG_RT_GROUP_SCHED sched_setscheduler() failure
      sched: Fix signed unsigned comparison in check_preempt_tick()

Milton Miller (2):
      virtio: remove virtio-pci root device
      kernel/smp.c: consolidate writes in smp_call_function_interrupt()

Mimi Zohar (1):
      trusted-keys: free memory bugfix

Nicolas Ferre (1):
      MAINTAINERS: update Atmel AT91 entry

Nishanth Aravamudan (1):
      powerpc/pseries: Add BNX2=m to defconfig

Paul Turner (1):
      sched: Update effective_load() to use global share weights

Pavel Shilovsky (5):
      CIFS: Fix oplock break handling (try #2)
      CIFS: Make cifsFileInfo_put work with strict cache mode
      CIFS: Implement cifs_strict_fsync
      CIFS: Implement cifs_file_strict_mmap (try #2)
      CIFS: Implement cifs_strict_readv (try #4)

Peter Zijlstra (1):
      sched, cgroup: Use exit hook to avoid use-after-free crash

Philip Sanderson (3):
      lguest: --username and --chroot options
      lguest: example launcher to use guard pages, drop PROT_EXEC, fix
limit logic
      lguest: document --rng in example Launcher

Rafael J. Wysocki (2):
      ACPI: Introduce acpi_os_ioremap()
      ACPI / PM: Call suspend_nvs_free() earlier during resume

Rajkumar Manoharan (2):
      ath9k_htc: Fix endian issue in tx header
      ath9k_hw: do PA offset calibration only on longcal interval

Randy Dunlap (4):
      [media] ir-raw: fix sparse non-ANSI function warning
      LGUEST_GUEST: fix unmet direct dependencies (VIRTUALIZATION && VIRTIO)
      xen: fix non-ANSI function warning in irq.c
      backlight: fix 88pm860x_bl macro collision

Roland Dreier (1):
      MAINTAINERS: Update Roland Dreier's email address

Romain Francoise (1):
      ipv6: Silence privacy extensions initialization

Rusty Russell (1):
      lguest: compile fixes

Scott Wood (1):
      powerpc/mpic: Fix mask/unmask timeout message

Seungwhan Youn (1):
      ASoC: documentation updates

Shan Wei (1):
      sctp: user perfect name for Delayed SACK Timer option

Shaohui Xie (1):
      powerpc/fsl_rio: Fix non-standard HID1 register access

Shirish Pargaonkar (2):
      cifs: Fix regression during share-level security mounts (Repost)
      cifs: Use mask of ACEs for SID Everyone to calculate all three
permissions user, group, and other

Shreyas Bhatewara (8):
      vmxnet3: fix ring size update
      vmxnet3: Preserve the MAC address configured by ifconfig
      vmxnet3: Enable HW Rx VLAN stripping by default
      vmxnet3: Provide required number of bytes in first SG buffer
      vmxnet3: Make ethtool handlers multiqueue aware
      vmxnet3: Disable napi in suspend, reenable in resume.
      vmxnet3: Add locking for access to command register
      vmxnet3: Dont allocate extra MSI-x vectors

Stefan Bader (1):
      xen: p2m: correctly initialize partial p2m leaf

Stefan Richter (3):
      [media] firedtv: fix remote control with newer Xorg evdev
      firewire: core: fix unstable I/O with Canon camcorder
      firewire: net: is not experimental anymore

Stephen Boyd (1):
      msm: qsd8x50: Platform data isn't init data

Steve French (2):
      [CIFS] Update cifs version number
      [CIFS] cifs: reconnect unresponsive servers

Steven Rostedt (2):
      powerpc/ppc64/tracing: Add stack frame to calls of trace_hardirqs_on/off
      powerpc/ppc32/tracing: Add stack frame to calls of trace_hardirqs_on/off

Steven Whitehouse (1):
      GFS2: Fix error path in gfs2_lookup_by_inum()

Sven Eckelmann (1):
      batman-adv: Use "__attribute__" shortcut macros

Takashi Iwai (3):
      Revert "ALSA: HDA: Create mixers on ALC887"
      ALSA: hda - Add quirk for HP Z-series workstation
      ALSA: hda - Fix "unused variable" compile warning

Tejun Heo (6):
      workqueue: relax lockdep annotation on flush_work()
      workqueue: note the nested NOT_RUNNING test in
worker_clr_flags() isn't a noop
      [media] v4l/cx18: update workqueue usage
      lockdep: Move early boot local IRQ enable/disable status to init/main.c
      smp: Allow on_each_cpu() to be called while
early_boot_irqs_disabled status to init/main.c
      powerpc/cell: Use system_wq in cpufreq_spudemand

Tetsuo Handa (3):
      trusted-keys: another free memory bugfix
      trusted-keys: check for NULL before using it
      trusted-keys: avoid scattring va_end()

Thadeu Lima de Souza Cascardo (1):
      [media] DVB: cx231xx drivers does not use dummy frontend anymore

Thomas Gleixner (37):
      h8300: Convert to new irq_chip functions
      h8300: Convert interrupt handling to flow handler
      h8300: Use generic irq Kconfig
      cris: Use irq handling wrapper
      cris: Convert V10 interrupt handling
      cris: Convert V32 interrupt handling
      cris: Use generic irq Kconfig
      m32r: Cleanup direct irq_desc access
      m32r: Convert m32104ut irq handling
      m32r: Convert m32104ut irq chip
      m32r: Convert m32700ut pld irq chip
      m32r: Convert m32700ut lanpld irq chip
      m32r: Convert m32700ut lcdpld irq chip
      m32r: Convert mappi irq chips
      m32r: Convert mappi2 irq chip
      m32r: Convert mappi3 irq chip
      m32r: Convert oaks32r irq chips
      m32r: Convert opsput irq chip
      m32r: Convert opsput pld irq chip
      m32r: Convert opsput lanpld irq chip
      m32r: Convert opsput_lcdpld irq chip
      m32r: Convert usrv platform irq handling
      m32r: Convert to generic irq Kconfig
      genirq: Remove __do_IRQ
      alpha: Use generic irq Kconfig
      blackfin: Use generic irq Kconfig
      frv: Use generic irq Kconfig
      ia64: Use generic irq Kconfig
      m68knommu: Use generic irq Kconfig
      microblaze: Use generic irq Kconfig
      mn10300: Use generic irq Kconfig
      parisc: Use generic irq Kconfig
      powerpc: Use generic irq Kconfig
      score: Use generic irq Kconfig
      sparc: Use generic irq Kconfig
      tile: Use generic irq Kconfig
      um: Use generic irq Kconfig

Timur Tabi (2):
      powerpc/85xx: fix compatible properties of the P1022DS DMA nodes
used for audio
      powerpc: fix warning when compiling immap_qe.h

Tobias Lorenz (2):
      [media] radio-si470x: de-emphasis should be set if requested by
module parameter
      [media] radio-si470x: Always report support for RDS

Tomi Valkeinen (1):
      memblock: fix memblock_is_region_memory()

Ursula Braun (1):
      qeth: postpone open till recovery is finished

Vasily Khoruzhick (2):
      ASoC: PXA: Fix jack detection on Zipit Z2
      ASoC: PXA: Fix codec address on Zipit Z2

Wey-Yi Guy (1):
      iwlwifi: fix valid chain reading from EEPROM

Yaniv Rosner (8):
      bnx2x: Swap BCM8073 PHY polarity if required
      bnx2x: Common init will be executed only once after POR
      bnx2x: LED fix for BCM8727 over BCM57712
      bnx2x: Fix BCM8073/BCM8727 microcode loading
      bnx2x: Mark full duplex on some external PHYs
      bnx2x: Fix BCM84823 LED behavior
      bnx2x: Fix AER setting for BCM57712
      bnx2x: Update bnx2x version to 1.62.00-4

Yong Zhang (1):
      sched: Replace rq->bkl_count with rq->rq_sched_info.bkl_count

roel kluin (1):
      powerpc/macintosh: Fix wrong test in fan_{read,write}_reg()

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab2EUAAp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 20:00:45 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:63899 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab2EUAAn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 20:00:43 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 20 May 2012 17:00:21 -0700
X-Google-Sender-Auth: xen4ms_lPFmTLpscu7lNt_NNfz8
Message-ID: <CA+55aFwaobhbBZkE1LTyQJYhk8w8zk-cyOXXuXfPyE=BXzT3PA@mail.gmail.com>
Subject: Linux 3.4 released
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just pushed out the 3.4 release.

Nothing really exciting happened since -rc7, although the workaround
for a linker bug on x86 is larger than I'd have liked at this stage,
and sticks out like a sore thumb in the diffstat. That said, it's not
like even that patch was really all that scary.

In fact, I think the 3.4 release cycle as a whole has been fairly
calm. Sure, I always wish for the -rc's to calm down more quickly than
they ever seem to do, but I think on the whole we didn't have any big
disruptive events, which is just how I like it. Let's hope the 3.5
merge window is a calm one too.

                       Linus

--- ShortLog since 3.4-rc7 ---

Alan Cox (2):
      tty: Fix LED error return
      x86, kvm: KVM paravirt kernels don't check for CPUID being unavailable

Alexander Clouter (1):
      crypto: mv_cesa requires on CRYPTO_HASH to build

Alexander Graf (3):
      KVM: PPC: Book3S: PR: Handle EMUL_ASSIST
      KVM: PPC: Fix PR KVM on POWER7 bare metal
      KVM: PPC: Book3S: PR: Fix hsrr code

Amit Shah (2):
      virtio: console: tell host of open ports after resume from s3/s4
      virtio: balloon: let host know of updated balloon size before
module removal

Asai Thambi S P (1):
      mtip32xx: release the semaphore on an error path

Barry Song (1):
      ARM: PRIMA2: fix irq domain size and IRQ mask of internal
interrupt controller

Benjamin Herrenschmidt (1):
      powerpc/kvm: Fix VSID usage in 64-bit "PR" KVM

Bernd Schubert (1):
      bio allocation failure due to bio_get_nr_vecs()

Bernhard Kohl (1):
      target: Fix SPC-2 RELEASE bug for multi-session iSCSI client setups

Brian Austin (1):
      ASoC: cs42l73: Sync digital mixer kcontrols to allow for 0dB

Chris Metcalf (3):
      arch/tile: fix up some issues in calling do_work_pending()
      arch/tile: apply commit 74fca9da0 to the compat signal handling as well
      tilegx: enable SYSCALL_WRAPPERS support

Cyrill Gorcunov (1):
      fs, proc: fix ABBA deadlock in case of execution attempt of
map_files/ entries

Dan Carpenter (2):
      [media] fintek-cir: change || to &&
      openvswitch: checking wrong variable in queue_userspace_packet()

Dan Williams (1):
      cdc_ether: add Novatel USB551L device IDs for FLAG_WWAN

David Ahern (1):
      perf stat: handle ENXIO error for perf_event_open

David S. Miller (1):
      bonding: Fix LACPDU rx_dropped commit.

Eric Dumazet (2):
      pch_gbe: fix transmit races
      pktgen: fix module unload for good

Geert Uytterhoeven (1):
      ptp_pch: Add missing #include <linux/slab.h>

Greg Kroah-Hartman (1):
      perf: Turn off compiler warnings for flex and bison generated files

Guennadi Liakhovetski (1):
      [media] V4L: soc-camera: protect hosts during probing from
overzealous user-space

Gustavo Padovan (1):
      Bluetooth: notify userspace of security level change

H Hartley Sweeten (2):
      [media] media: videobuf2-dma-contig: quiet sparse noise about
plain integer as NULL pointer
      [media] media: videobuf2-dma-contig: include header for exported symbols

H. Peter Anvin (3):
      x86, realmode: 16-bit real-mode code support for relocs tool
      x86, relocs: Workaround for binutils 2.22.52.0.1 section bug
      x86, relocs: When printing an error, say relative or absolute

Hugh Dickins (1):
      memcg,thp: fix res_counter:96 regression

Igor Mammedov (1):
      sched: Fix KVM and ia64 boot crash due to sched_groups circular
linked list assumption

James Bottomley (2):
      [PARISC] fix PA1.1 oops on boot
      [PARISC] fix panic on prefetch(NULL) on PA7300LC

Jan Beulich (1):
      x86: Fix section annotation of acpi_map_cpu2node()

Janusz Krzysztofik (1):
      mtd: ams-delta: fix request_mem_region() failure

Jean-François Moine (1):
      [media] gspca - sonixj: Fix a zero divide in isoc interrupt

Jeff Layton (1):
      cifs: fix misspelling of "forcedirectio"

Jeff Moyer (1):
      block: don't mark buffers beyond end of disk as mapped

Jesper Juhl (1):
      dac960: Remove unused variables from DAC960_CreateProcEntries()

Jiri Kosina (1):
      genirq: export handle_edge_irq() and irq_to_desc()

Johan Hedberg (1):
      Bluetooth: mgmt: Fix device_connected sending order

John David Anglin (1):
      [PARISC] fix crash in flush_icache_page_asm on PA1.1

Jonathan Brassow (1):
      MD: Add del_timer_sync to mddev_suspend (fix nasty panic)

Jonathan Corbet (1):
      [media] marvell-cam: fix an ARM build error

Josh Cartwright (1):
      jffs2: Fix lock acquisition order bug in gc path

Jozsef Kadlecsik (1):
      netfilter: ipset: fix hash size checking in kernel

Larry Finger (1):
      rtlwifi: fix for race condition when firmware is cached

Laurent Pinchart (1):
      [media] media: vb2-memops: Export vb2_get_vma symbol

Linus Torvalds (2):
      proc: move fd symlink i_mode calculations into tid_fd_revalidate()
      Linux 3.4

Luis Henriques (1):
      [media] rc: Postpone ISR registration

Mark Brown (1):
      ASoC: wm8994: Fix AIF2ADC power down

Mauro Carvalho Chehab (1):
      [media] dvb_frontend: fix a regression with DVB-S zig-zag

Michael S. Tsirkin (1):
      virtio_net: invoke softirqs after __napi_schedule

Mike Snitzer (1):
      dm thin: fix table output when pool target disables discard
passdown internally

Ming Lei (1):
      usbnet: fix skb traversing races during unlink(v2)

Namhyung Kim (1):
      perf build-id: Fix filename size calculation

NeilBrown (2):
      md/raid10: set dev_sectors properly when resizing devices in array.
      md/raid10: fix transcription error in calc_sectors conversion.

Nicholas Bellinger (1):
      target: Fix bug in handling of FILEIO + block_device resize ops

Paul Gortmaker (1):
      frv: delete incorrect task prototypes causing compile fail

Paul Mackerras (1):
      KVM: PPC: Book3S HV: Fix bug leading to deadlock in guest HPT updates

Peter De Schrijver (1):
      ARM: tegra: Fix flow controller accesses

Rafael J. Wysocki (1):
      ACPI / PCI / PM: Fix device PM regression related to D3hot/D3cold

Rajkumar Kasirajan (1):
      drivers/rtc/rtc-pl031.c: configure correct wday for 2000-01-01

Russell King (2):
      Fix blkdev.h build errors when BLOCK=n
      ARM: prevent VM_GROWSDOWN mmaps extending below FIRST_USER_ADDRESS

Srivatsa S. Bhat (3):
      x86/microcode: Ensure that module is only loaded on supported Intel CPUs
      parisc/CPU hotplug: Add missing call to notify_cpu_starting()
      mn10300/CPU hotplug: Add missing call to notify_cpu_starting()

Stephane Eranian (1):
      perf stat: Fix case where guest/host monitoring is not supported by kernel

Steven Rostedt (1):
      tracing: Do not enable function event with enable

Subramaniam Chanderashekarapuram (1):
      remoteproc: fix off-by-one bug in __rproc_free_vrings

Sylwester Nawrocki (3):
      [media] V4L: Schedule V4L2_CID_HCENTER, V4L2_CID_VCENTER
controls for removal
      [media] s5p-fimc: Fix locking in subdev set_crop op
      [media] s5p-fimc: Correct memory allocation for VIDIOC_CREATE_BUFS

Takashi Iwai (1):
      ALSA: hda/idt - Fix power-map for speaker-pins with some HP laptops

Tejun Heo (1):
      block: fix buffer overflow when printing partition UUIDs

Tony Luck (1):
      x86/mce: Only restart instruction after machine check recovery
if it is safe

Tushar Dave (1):
      e1000: Prevent reset task killing itself.

Vinod Koul (2):
      dmaengine: pl330: dont complete descriptor for cyclic dma
      dmaengine: fix cyclic dma usage

Vitaly Andrianov (1):
      ARM: 7418/1: LPAE: fix access flag setup in mem_type_table

Will Deacon (2):
      ARM: 7417/1: vfp: ensure preemption is disabled when enabling VFP access
      ARM: 7419/1: vfp: fix VFP flushing regression on sigreturn path

Will Newton (1):
      mtd: fix oops in dataflash driver

Willy Tarreau (1):
      tcp: do_tcp_sendpages() must try to push data out on oom conditions

majianpeng (1):
      slub: missing test for partial pages flush work in flush_all()

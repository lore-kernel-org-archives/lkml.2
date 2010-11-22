Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305Ab0KVTUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 14:20:38 -0500
Received: from kroah.org ([198.145.64.141]:55837 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756601Ab0KVTUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 14:20:09 -0500
Date: Mon, 22 Nov 2010 11:17:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.35.9
Message-ID: <20101122191738.GE4340@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.35.9 kernel.

All users of the 2.6.35 kernel series must upgrade.

Please note, the 2.6.35 kernel is now "End Of Life" and will not be
getting any more updates.  Please move on to using the .36 kernel series
instead.

The updated 2.6.35.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.35.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.35.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                         |    2 
 arch/arm/mach-cns3xxx/include/mach/debug-macro.S |    2 
 arch/powerpc/kernel/ppc970-pmu.c                 |    2 
 arch/x86/include/asm/cpufeature.h                |    2 
 arch/x86/include/asm/io.h                        |    1 
 arch/x86/include/asm/kvm_emulate.h               |   10 +++
 arch/x86/include/asm/smp.h                       |    9 ++-
 arch/x86/kernel/apic/io_apic.c                   |    2 
 arch/x86/kernel/cpu/mtrr/cleanup.c               |    2 
 arch/x86/kernel/cpu/perf_event_amd.c             |    4 -
 arch/x86/kernel/crash_dump_64.c                  |    3 -
 arch/x86/kernel/olpc.c                           |    5 +
 arch/x86/kernel/reboot.c                         |    2 
 arch/x86/kernel/smp.c                            |   15 +++--
 arch/x86/kernel/traps.c                          |    1 
 arch/x86/kernel/vm86_32.c                        |   10 ++-
 arch/x86/kvm/emulate.c                           |    9 +--
 arch/x86/kvm/svm.c                               |   37 +++++++++++-
 arch/x86/kvm/x86.c                               |    4 -
 arch/x86/xen/enlighten.c                         |    2 
 arch/x86/xen/smp.c                               |    6 +-
 drivers/ata/ahci.h                               |    1 
 drivers/ata/libahci.c                            |   18 +++++-
 drivers/bluetooth/hci_ldisc.c                    |    7 ++
 drivers/char/pcmcia/synclink_cs.c                |    2 
 drivers/idle/intel_idle.c                        |    2 
 drivers/isdn/i4l/isdn_tty.c                      |    6 --
 drivers/misc/sgi-xp/xpc_uv.c                     |   17 +++++
 drivers/net/gianfar.c                            |    6 +-
 drivers/net/gianfar_ethtool.c                    |    2 
 drivers/net/netxen/netxen_nic_init.c             |    3 -
 drivers/net/qlcnic/qlcnic_init.c                 |    5 -
 drivers/net/r6040.c                              |   22 ++++---
 drivers/net/wireless/p54/eeprom.c                |    4 +
 drivers/net/wireless/p54/p54usb.c                |   15 ++++-
 drivers/platform/x86/asus-laptop.c               |    6 +-
 drivers/scsi/gdth.c                              |    8 ++
 drivers/scsi/libsas/sas_ata.c                    |    1 
 drivers/scsi/scsi_lib.c                          |    3 -
 drivers/scsi/scsi_sysfs.c                        |    3 -
 drivers/scsi/sd.c                                |   15 +++--
 drivers/staging/phison/phison.c                  |    2 
 drivers/staging/usbip/usbip_event.c              |   16 +----
 drivers/staging/usbip/vhci_hcd.c                 |    2 
 drivers/usb/core/hub.c                           |    9 ++-
 drivers/usb/core/message.c                       |   14 ++--
 drivers/usb/gadget/atmel_usba_udc.c              |    3 +
 drivers/usb/gadget/composite.c                   |    3 -
 drivers/usb/gadget/f_acm.c                       |    2 
 drivers/usb/gadget/g_ffs.c                       |    4 -
 drivers/usb/gadget/multi.c                       |    4 -
 drivers/usb/host/r8a66597.h                      |    2 
 drivers/usb/musb/blackfin.c                      |    7 +-
 drivers/usb/musb/davinci.c                       |    2 
 drivers/usb/musb/musb_core.c                     |    4 -
 drivers/usb/musb/omap2430.c                      |    1 
 drivers/usb/musb/tusb6010.c                      |    4 +
 drivers/usb/serial/cp210x.c                      |    2 
 drivers/usb/serial/ftdi_sio.c                    |   39 +++++++++++--
 drivers/usb/serial/ftdi_sio_ids.h                |   39 ++++++++++++-
 drivers/usb/serial/mct_u232.c                    |    7 +-
 drivers/usb/serial/opticon.c                     |    6 +-
 drivers/usb/serial/option.c                      |   23 ++++++-
 drivers/usb/serial/visor.c                       |   11 +++
 fs/cifs/cifsproto.h                              |    3 -
 fs/cifs/dir.c                                    |   12 +---
 fs/cifs/file.c                                   |    4 -
 fs/pipe.c                                        |    2 
 include/linux/tipc.h                             |   30 ++++++----
 kernel/futex.c                                   |   31 +++++-----
 kernel/perf_event.c                              |    8 ++
 kernel/sched.c                                   |   13 +---
 mm/vmalloc.c                                     |    9 +++
 net/core/dev.c                                   |   14 ++++
 net/core/ethtool.c                               |    4 -
 net/core/stream.c                                |    8 +-
 net/ipv4/ip_output.c                             |   19 ++++--
 net/ipv4/tcp.c                                   |   11 ++-
 net/ipv4/tcp_input.c                             |    2 
 net/ipv4/tcp_timer.c                             |   24 ++++----
 net/ipv4/udp.c                                   |    4 +
 net/ipv4/xfrm4_policy.c                          |    2 
 net/ipv6/addrconf.c                              |    4 +
 net/ipv6/ip6_output.c                            |   18 ++++--
 net/ipv6/route.c                                 |   28 ++++++++-
 net/netfilter/xt_SECMARK.c                       |    2 
 net/phonet/pep.c                                 |    3 -
 net/rose/af_rose.c                               |    4 -
 net/sctp/protocol.c                              |    4 +
 net/tipc/subscr.c                                |   68 ++++++++++++-----------
 net/tipc/subscr.h                                |    2 
 91 files changed, 563 insertions(+), 252 deletions(-)

Alan Cox (1):
      bluetooth: Fix missing NULL check

Alan Stern (2):
      USB: disable endpoints after unbinding interfaces, not before
      USB: accept some invalid ep0-maxpacket values

Alok Kataria (1):
      x86, kexec: Make sure to stop all CPUs before exiting the kernel

Alon Ziv (1):
      USB: opticon: Fix long-standing bugs in opticon driver

Anders Larsen (1):
      USB: cp210x: Add WAGO 750-923 Service Cable device ID

Andre Przywara (1):
      x86, cpu: Fix renamed, not-yet-shipping AMD CPUID feature bit

Andreas Herrmann (1):
      x86, mtrr: Assume SYS_CFG[Tom2ForceMemTypeWB] exists on all future AMD CPUs

Avi Kivity (1):
      KVM: x86 emulator: fix regression with cmpxchg8b on i386 hosts

Bart Oldeman (1):
      x86, vm86: Fix preemption bug for int1 debug and int3 breakpoint handlers.

Ben Greear (1):
      net/core: Allow tagged VLAN packets to flow through VETH devices.

Ben Hutchings (1):
      r6040: Fix multicast filter some more

Christian Lamparter (2):
      p54usb: fix off-by-one on !CONFIG_PM
      p54usb: add five more USBIDs

Christof Schmitt (1):
      Fix race when removing SCSI devices

Cliff Wickman (2):
      mm, x86: Saving vmcore with non-lazy freeing of vmas
      x86, kdump: Change copy_oldmem_page() to use cached addressing

Corentin Chary (1):
      asus-laptop: fix gps rfkill

DJ Delorie (1):
      USB: cp210x: Add Renesas RX-Stick device ID

Damian Lukowski (1):
      net-2.6: SYN retransmits: Add new parameter to retransmits_timed_out()

Dan Carpenter (2):
      gdth: integer overflow in ioctl
      gianfar: fix double lock typo

Daniel Suchy (1):
      USB: ftdi_sio: new VID/PIDs for various Papouch devices

Darren Hart (1):
      futex: Fix errors in nested key ref-counting

David Milburn (1):
      libsas: fix NCQ mixing with non-NCQ

David S. Miller (1):
      rose: Fix signedness issues wrt. digi count.

Eric Dumazet (4):
      ip: fix truesize mismatch in ip fragmentation
      netxen: dont set skb->truesize
      qlcnic: dont set skb->truesize
      net: add a recursion limit in xmit path

Eric Paris (1):
      secmark: do not return early if there was no error

Greg Kroah-Hartman (3):
      Staging: phison: fix problem caused by libata change
      USB: ftdi_sio: add device ids for ScienceScope
      Linux 2.6.35.9

Jarek Poplawski (1):
      gianfar: Fix crashes on RX path (Was Re: [Bugme-new] [Bug 19692] New: linux-2.6.36-rc5 crash with gianfar ethernet at full line rate traffic)

Jean-Christophe PLAGNIOL-VILLARD (1):
      USB: atmel_usba_udc: force vbus_pin at -EINVAL when gpio_request failled

Joerg Roedel (2):
      KVM: X86: Report SVM bit to userspace only when supported
      KVM: SVM: Restore correct registers after sel_cr0 intercept emulation

Johan Hovold (3):
      USB: mct_u232: fix broken close
      USB: ftdi_sio: revert "USB: ftdi_sio: fix DTR/RTS line modes"
      USB: visor: fix initialisation of UX50/TH55 devices

Julia Lawall (1):
      drivers/net/wireless/p54/eeprom.c: Return -ENOMEM on memory allocation failure

Kees Cook (1):
      net: clear heap allocations for privileged ethtool actions

Kumar Sanghvi (1):
      Phonet: Correct header retrieval after pskb_may_pull

Len Brown (1):
      intel_idle: do not use the LAPIC timer for ATOM C2

Linus Walleij (1):
      sched: Drop all load weight manipulation for RT tasks

Mac Lin (1):
      ARM: cns3xxx: Fixup the missing second parameter to addruart macro to allow them to build.

Maciej Żenczykowski (1):
      net: Fix IPv6 PMTU disc. w/ asymmetric routes

Mathieu Desnoyers (1):
      sched: Fix string comparison in /proc/sched_features

Mauro Carvalho Chehab (1):
      USB: option: Add more ZTE modem USB id's

Max Vozeler (2):
      staging: usbip: Notify usb core of port status changes
      staging: usbip: Process event flags without delay

Michael Reed (1):
      sd name space exhaustion causes system hang

Michal Nazarewicz (2):
      USB: gadget: g_ffs: fixed vendor and product ID
      USB: gadget: g_multi: fixed vendor and product ID

Mike Christie (1):
      Fix regressions in scsi_internal_device_block

Nagendra Tomar (1):
      net: Fix the condition passed to sk_wait_event()

Neil Horman (2):
      Revert c6537d6742985da1fbf12ae26cde6a096fd35b5c
      Revert d88dca79d3852a3623f606f781e013d61486828a

Nicolas Kaiser (1):
      pipe: fix failure to return error code on ->confirm()

Nobuhiro Iwamatsu (1):
      usb: r8a66597-hcd: Change mistake of the outsw function

Paul Fox (1):
      x86, olpc: Don't retry EC commands forever

Paul Mackerras (1):
      powerpc/perf: Fix sampling enable for PPC970

Praveena Nadahally (1):
      USB: Change acm_iad_descriptor bFunctionProtocol to USB_CDC_ACM_PROTO_AT_V25TER

Rainer Keller (1):
      USB: add PID for FTDI based OpenDCC hardware

Rich Mattes (1):
      USB: ftdi_sio: Add PID for accesio products

Robin Holt (1):
      sgi-xp: incoming XPC channel messages can come in after the channel's partition structures have been torn down

Roger Quadros (1):
      usb gadget: composite: prevent OOPS for non-standard control request

Sergei Shtylyov (3):
      USB: MUSB: fix kernel WARNING/oops when unloading module in OTG mode
      usb: musb: blackfin: call usb_nop_xceiv_unregister() in musb_platform_exit()
      usb: musb: blackfin: call gpio_free() on error path in musb_platform_init()

Stephane Eranian (2):
      perf_events: Fix bogus AMD64 generic TLB events
      perf_events: Fix bogus context time tracking

Suresh Jayaraman (1):
      cifs: fix broken oplock handling

Suresh Siddha (1):
      x86, intr-remap: Set redirection hint in the IRTE

Tejun Heo (1):
      libahci: fix result_tf handling after an ATA PIO data-in command

Tilman Schmidt (1):
      isdn: avoid calling tty_ldisc_flush() in atomic context

Tom Marshall (1):
      tcp: Fix race in tcp_poll

Ulrich Weber (1):
      xfrm4: strip ECN bits from tos field

Ursula Braun (1):
      ipv6: fix refcnt problem related to POSTDAD state

Vasiliy Kulikov (1):
      pcmcia: synclink_cs: fix information leak to userland

holt@sgi.com (1):
      Limit sysctl_tcp_mem and sysctl_udp_mem initializers to prevent integer overflows.


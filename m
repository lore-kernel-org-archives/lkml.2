Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108Ab1KHKj7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 05:39:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56069 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab1KHKjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 05:39:55 -0500
Message-ID: <4EB906F6.3010007@canonical.com>
Date: Tue, 08 Nov 2011 11:39:50 +0100
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111031 Thunderbird/7.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.32.47
References: <20111107213431.GA8483@kroah.com>
In-Reply-To: <20111107213431.GA8483@kroah.com>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 07.11.2011 22:34, Greg KH wrote:
> I'm announcing the release of the 2.6.32.47 kernel.
> 
> All users of the 2.6.32 series must upgrade.
> 
> The updated 2.6.32.y git tree can be found at (NOTE THE ADDRESS CHANGE): 
> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
> linux-2.6.32.y and can be browsed at the normal kernel.org git web
> browser: 
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=shortlog;h=refs/heads/linux-2.6.32.y
>
>  thanks,
> 
> greg k-h
> 
> ------------
> 
> Documentation/stable_kernel_rules.txt       |    4 Makefile
> |    2 arch/arm/mach-davinci/board-da850-evm.c     |   28 ++ 
> arch/arm/plat-mxc/include/mach/iomux-v3.h   |   10 - 
> arch/mips/alchemy/mtx-1/platform.c          |    9 
> arch/powerpc/kernel/pci_of_scan.c           |    2 
> arch/powerpc/sysdev/mpic.c                  |   17 - 
> arch/s390/kvm/kvm-s390.c                    |   14 + 
> arch/sparc/include/asm/sigcontext.h         |   14 + 
> arch/sparc/kernel/Makefile                  |    1 arch/sparc/kernel/pcic.c
> |    4 arch/sparc/kernel/signal32.c                |  184
> +++++++++++-------- arch/sparc/kernel/signal_32.c               |  172
> ++++++++---------- arch/sparc/kernel/signal_64.c               |  108
> ++++------- arch/sparc/kernel/sigutil.h                 |    9 
> arch/sparc/kernel/sigutil_32.c              |  120 ++++++++++++ 
> arch/sparc/kernel/sigutil_64.c              |   93 +++++++++ 
> arch/um/drivers/ubd_kern.c                  |   31 +++ 
> arch/x86/include/asm/processor.h            |   23 ++ 
> arch/x86/kernel/amd_iommu.c                 |    2 
> arch/x86/kernel/kprobes.c                   |    4 
> arch/x86/kernel/smpboot.c                   |   85 --------- 
> arch/x86/kvm/svm.c                          |    1 arch/x86/kvm/vmx.c
> |    1 arch/x86/xen/smp.c                          |   10 + 
> arch/x86/xen/time.c                         |    4 
> arch/x86/xen/xen-asm_32.S                   |    8 block/cfq-iosched.c
> |  264 +++++++++++++++++++++------- drivers/ata/ahci.c
> |   12 + drivers/base/sys.c                          |    6 
> drivers/block/xen-blkfront.c                |    2 
> drivers/char/hvc_console.c                  |    8 drivers/char/tpm/tpm.c
> |    9 drivers/hid/hid-ids.h                       |    3 
> drivers/hid/usbhid/hid-quirks.c             |    1 
> drivers/hwmon/w83627ehf.c                   |   15 + drivers/md/linear.h
> |    2 drivers/md/md.c                             |   12 + 
> drivers/media/video/cx23885/cx23885-dvb.c   |    2 
> drivers/media/video/uvc/uvc_driver.c        |    2 
> drivers/media/video/uvc/uvc_video.c         |   10 - 
> drivers/media/video/uvc/uvcvideo.h          |    2 drivers/net/cnic.c
> |    4 drivers/net/e1000/e1000_hw.c                |    6 
> drivers/net/e1000e/netdev.c                 |    2 
> drivers/net/igb/igb_main.c                  |    2 
> drivers/net/igbvf/netdev.c                  |    2 
> drivers/net/irda/smsc-ircc2.c               |    2 
> drivers/net/ixgbe/ixgbe_main.c              |    2 drivers/net/rionet.c
> |    4 drivers/net/usb/asix.c                      |    4 
> drivers/net/wireless/b43/main.c             |    3 
> drivers/net/wireless/rt2x00/rt2x00usb.c     |   14 - 
> drivers/platform/x86/thinkpad_acpi.c        |    7 
> drivers/s390/cio/ccwgroup.c                 |   42 ++-- 
> drivers/scsi/3w-9xxx.c                      |    2 
> drivers/scsi/aacraid/commsup.c              |    2 drivers/scsi/ipr.c
> |    2 drivers/scsi/libiscsi_tcp.c                 |   14 - 
> drivers/scsi/libsas/sas_expander.c          |   14 - 
> drivers/scsi/qla2xxx/qla_init.c             |    3 
> drivers/scsi/qla2xxx/qla_isr.c              |    1 
> drivers/staging/quatech_usb2/quatech_usb2.c |    9 
> drivers/usb/class/cdc-acm.c                 |    3 drivers/usb/core/devio.c
> |    6 drivers/usb/core/quirks.c                   |   21 ++ 
> drivers/usb/host/ehci-hub.c                 |    7 
> drivers/usb/host/fhci-sched.c               |   19 +- 
> drivers/usb/host/xhci-mem.c                 |   22 +- 
> drivers/usb/mon/mon_bin.c                   |    2 
> drivers/usb/musb/musb_core.c                |    1 
> drivers/usb/serial/ftdi_sio.c               |   25 ++ 
> drivers/usb/serial/ftdi_sio_ids.h           |   13 + 
> drivers/usb/serial/pl2303.c                 |   27 ++ 
> drivers/usb/serial/pl2303.h                 |    5 
> drivers/usb/serial/qcserial.c               |    2 
> drivers/usb/storage/transport.c             |   34 ++- 
> drivers/video/carminefb.c                   |    6 
> drivers/watchdog/mtx-1_wdt.c                |    5 drivers/xen/events.c
> |    2 fs/cifs/cifssmb.c                           |    3 fs/eventpoll.c
> |   25 +- fs/ext4/ext4.h                              |    3 
> fs/ext4/extents.c                           |    1 fs/lockd/clntproc.c
> |    8 fs/nfsd/nfs4proc.c                          |    2 
> fs/nfsd/nfs4state.c                         |    2 fs/proc/base.c
> |   69 +++++-- fs/proc/kcore.c                             |    2 
> fs/splice.c                                 |    3 include/linux/ext2_fs.h
> |    4 include/linux/ext3_fs.h                     |    4 
> include/linux/interrupt.h                   |    5 
> include/linux/iocontext.h                   |    5 include/linux/jiffies.h
> |    2 include/linux/sunrpc/sched.h                |    4 include/net/scm.h
> |    5 kernel/irq/pm.c                             |   35 ++- kernel/kmod.c
> |    4 kernel/time.c                               |    2 
> lib/kobject_uevent.c                        |    2 mm/mmap.c
> |   20 +- net/9p/client.c                             |   13 - 
> net/atm/br2684.c                            |    7 net/bluetooth/l2cap.c
> |    3 net/bluetooth/rfcomm/sock.c                 |    1 net/core/scm.c
> |   10 - net/core/skbuff.c                           |    8 
> net/ipv6/ip6_output.c                       |    2 net/ipv6/ip6_tunnel.c
> |    4 net/sched/sch_api.c                         |   14 - 
> net/sunrpc/clnt.c                           |    3 net/sunrpc/sched.c
> |    1 net/wireless/nl80211.c                      |    9 
> net/wireless/reg.c                          |    1 net/x25/af_x25.c
> |    3 sound/pci/hda/patch_cirrus.c                |    2 
> sound/pci/hda/patch_realtek.c               |    6 
> sound/soc/codecs/ak4535.c                   |   10 - 
> sound/soc/codecs/ak4642.c                   |   22 +- 
> sound/soc/codecs/wm8940.c                   |    2 sound/soc/soc-jack.c
> |    2 122 files changed, 1318 insertions(+), 666 deletions(-)
> 
> 
> Al Viro (1): deal with races in /proc/*/{syscall,stack,personality}
> 
> Alexandre Bounine (1): drivers/net/rionet.c: fix ethernet address macros
> for LE platforms
> 
> Andrew Vasquez (1): qla2xxx: Correct inadvertent loop state transitions
> during port-update handling.
> 
> Aneesh Kumar K.V (1): fs/9p: Fid is not valid after a failed clunk.
> 
> Anton Blanchard (1): ipr: Always initiate hard reset in kdump kernel
> 
> Artur Zimmer (1): USB: Serial: Add PID(0xF7C0) to FTDI SIO driver for a
> zeitcontrol-device
> 

> Axel Lin (2): ASoC: wm8940: Properly set codec->dapm.bias_level

The above breaks the build I did here. It looks to me that this variable was
not introduced before 2.6.38:

  CC [M]  drivers/input/gameport/fm801-gp.o
sound/soc/codecs/wm8940.c: In function 'wm8940_set_bias_level':
sound/soc/codecs/wm8940.c:476: error: 'struct snd_soc_codec' has no member
named 'dapm'

commit ce6120cca2589ede530200c7cfe11ac9f144333c
Author: Liam Girdwood <lrg@slimlogic.co.uk>
Date:   Fri Nov 5 15:53:46 2010 +0200

    ASoC: Decouple DAPM from CODECs

- -Stefan

> ASoC: ak4535: fixup cache register table
> 
> Bernd Schubert (1): nfsd4: Remove check for a 32-bit cookie in
> nfsd4_readdir()
> 
> Carsten Otte (1): KVM: s390: check cpu_id prior to using it
> 
> Changli Gao (1): splice: direct_splice_actor() should not use pos in sd
> 
> Dan Carpenter (1): kcore: fix test for end of list
> 
> Dan Rosenberg (1): Bluetooth: Prevent buffer overflow in l2cap config
> request
> 
> Daniel Schwierzeck (1): atm: br2684: Fix oops due to skb->dev being NULL
> 
> David Henningsson (2): ALSA: HDA: Cirrus - fix "Surround Speaker" volume
> control name ALSA: HDA: Add new revision for ALC662
> 
> David S. Miller (1): sparc: Allow handling signals when stack is
> corrupted.
> 
> Denis Pershin (1): usb: cdc-acm: Owen SI-30 support
> 
> Eric Benoit (1): USB: pl2303: add id for SMART device
> 
> Eric Dumazet (2): scm: lower SCM_MAX_FD net_sched: Fix qdisc_notify()
> 
> Eric Van Hensbergen (1): net/9p: fix client code to fail more gracefully on
> protocol error
> 
> Filip Palian (1): Bluetooth: l2cap and rfcomm: fix 1 byte infoleak to
> userspace.
> 
> Florian Echtler (1): USB: Serial: Add device ID for Sierra Wireless MC8305
> 
> Florian Fainelli (2): Revert "MIPS: MTX-1: Make au1000_eth probe all PHY 
> watchdog: mtx1-wdt: fix build failure
> 
> Greg Kroah-Hartman (3): Revert "x86, hotplug: Use mwait to offline a
> processor, fix the legacy case" Revert "usb: musb: restore INDEX register
> in resume path" Linux 2.6.32.47
> 
> Hakan Kvist (1): USB: ftdi_sio: add PID for Sony Ericsson Urban
> 
> Hendrik Brueckner (1): hvc_console: Improve tty/console put_chars handling
> 
> Herbert Xu (1): ipv6: Add GSO support on forwarding path
> 
> Hugh Dickins (1): vm: fix vm_pgoff wrap in upward expansion
> 
> Ian Campbell (3): sparc: fix array bounds error setting up PCIC NMI trap 
> xen/timer: Missing IRQF_NO_SUSPEND in timer code broke suspend. genirq: Add
> IRQF_RESUME_EARLY and resume such IRQs earlier
> 
> Igor Mammedov (1): xen: x86_32: do not enable iterrupts when returning from
> exception in interrupt context
> 
> J. Bruce Fields (1): nfsd4: ignore WANT bits in open downgrade
> 
> Jack Wang (1): libsas: set sas_address and device type of rphy
> 
> James Bottomley (1): 3w-9xxx: fix iommu_iova leak
> 
> Jean Delvare (2): hwmon: (w83627ehf) Properly report thermal diode sensors 
> carminefb: Fix module parameters permissions
> 
> Jean-Christophe PLAGNIOL-VILLARD (1): USB: ftdi_sio: add Calao reference
> board support
> 
> Jeff Kirsher (1): e1000: Fix driver to be used on PA RISC C8000
> workstations
> 
> Jeff Layton (1): cifs: fix possible memory corruption in CIFSFindNext
> 
> Jeff Moyer (5): cfq: calculate the seek_mean per cfq_queue not per
> cfq_io_context cfq: merge cooperating cfq_queues cfq: change the meaning of
> the cfqq_coop flag cfq: break apart merged cfqqs if they stop cooperating 
> cfq: Don't allow queue merges for queues that have no process references
> 
> Jens Axboe (1): cfq-iosched: get rid of the coop_preempt flag
> 
> Jeremiah Matthey (1): HID: usbhid: Add support for SiGma Micro chip
> 
> Jerry Huang (1): QE/FHCI: fixed the CONTROL bug
> 
> Jiri Kosina (1): kmod: prevent kmod_loop_msg overflow in
> __request_module()
> 
> Joerg Roedel (1): iommu/amd: Fix wrong shift direction
> 
> Johannes Stezenbach (1): usbmon vs. tcpdump: fix dropped packet count
> 
> Josh Boyer (1): Update email address for stable patch submission
> 
> Josh Stone (1): x86: Fix compilation bug in kprobes' twobyte_is_boostable
> 
> Jouni Malinen (1): cfg80211: Fix validation of AKM suites
> 
> Kautuk Consul (2): staging: quatech_usb2: Potential lost wakeup scenario in
> TIOCMIWAIT xhci-mem.c: Check for ring->first_seg != NULL
> 
> Konrad Rzeszutek Wilk (1): xen/smp: Warn user why they keel over - nosmp or
> noapic and what to use instead.
> 
> Kuninori Morimoto (1): ASoC: ak4642: fixup cache register table
> 
> Linus Torvalds (1): vm: fix vm_pgoff wrap in stack expansion
> 
> Luben Tuikov (1): USB: storage: Use normalized sense when emulating
> autosense
> 
> Luciano Coelho (1): nl80211: fix overflow in ssid_len
> 
> Manoj Iyer (1): thinkpad-acpi: module autoloading for newer Lenovo
> ThinkPads.
> 
> Manual Munz (1): b43: Fix beacon problem in ad-hoc mode
> 
> Marek Marczykowski (1): xen-blkfront: fix data size for xenbus_gather in
> blkfront_connect
> 
> Marek Vasut (1): ASIX: Add AX88772B USB ID
> 
> Mark Brown (1): ASoC: Fix reporting of partial jack updates
> 
> Mark Nelson (1): ahci: Enable SB600 64bit DMA on Asus M3A
> 
> Mark Salyzyn (2): libsas: fix failure to revalidate domain for anything but
> the first expander child. libsas: fix panic when single phy is disabled on
> a wide port
> 
> Matthew Daley (1): x25: Prevent skb overreads when checking call user data
> 
> Mauro Carvalho Chehab (1): tuner_xc2028: Allow selection of the frequency
> adjustment code for XC3028
> 
> Michael Chan (1): cnic: Improve NETDEV_UP event handling
> 
> Michal Schmidt (1): GRO: fix merging a paged skb after non-paged skbs
> 
> Michal Sroczynski (1): USB: PL2303: correctly handle baudrates above
> 115200
> 
> Mike Christie (1): libiscsi_tcp: fix LLD data allocation
> 
> Milan Broz (1): kobj_uevent: Ignore if some listeners cannot handle
> message
> 
> Ming Lei (1): uvcvideo: Set alternate setting 0 on resume if the bus has
> been reset
> 
> NeilBrown (2): md/linear: avoid corrupting structure while waiting for
> rcu_free to complete. md: Fix handling for devices from 2TB to 4TB in 0.90
> metadata.
> 
> Nelson Elhage (1): epoll: fix spurious lockdep warnings
> 
> Oliver Neukum (1): USB: add RESET_RESUME for webcams shown to be quirky
> 
> Paul Fertser (1): plat-mxc: iomux-v3.h: implicitly enable pull-up/down when
> that's desired
> 
> Peter Huewe (2): TPM: Call tpm_transmit with correct size TPM: Zero buffer
> after copying to userspace
> 
> Peter Stuge (1): USB: ftdi_sio: Support TI/Luminary Micro Stellaris BD-ICDI
> Board
> 
> Philipp Hahn (1): KVM: x86: Reset tsc_timestamp on TSC writes
> 
> Rajkumar Manoharan (1): wireless: Reset beacon_found while updating
> regulatory
> 
> Randy Dunlap (1): irda: fix smsc-ircc2 section mismatch warning
> 
> Richard Weinberger (1): um: fix ubd cow size
> 
> Rigbert Hamisch (1): USB: qcserial: add device ID for "HP un2430 Mobile
> Broadband Module"
> 
> Sebastian Ott (1): ccwgroup: move attributes to attribute group
> 
> Serge Hallyn (1): USB: pid_ns: ensure pid is not freed during
> kill_pid_info_as_uid
> 
> Sonny Rao (1): powerpc/pci: Check devices status property when scanning OF
> tree
> 
> Sridhar Samudrala (1): net: Fix IPv6 GSO type checks in Intel ethernet
> drivers
> 
> Stanislaw Gruszka (1): rt2x00: do not drop usb dev reference counter on
> suspend
> 
> Stratos Psomadakis (1): Fix broken backport for IPv6 tunnels
> 
> Sudhakar Rajashekhara (1): ARM: davinci: da850 EVM: read mac address from
> SPI flash
> 
> Takashi Iwai (1): ALSA: hda/realtek - Avoid bogus HP-pin assignment
> 
> Theodore Ts'o (1): ext2,ext3,ext4: don't inherit APPEND_FL or IMMUTABLE_FL
> for new inodes
> 
> Trond Myklebust (1): NLM: Don't hang forever on NLM unlock requests
> 
> Vasily Averin (1): aacraid: reset should disable MSI interrupt
> 
> Venkateswararao Jujjuri (JV) (1): net/9p: Fix the msize calculation.
> 
> Wang Zhi (1): USB: EHCI: Do not rely on PORT_SUSPEND to stop USB resuming
> in ehci_bus_resume().
> 
> Yang Li (1): powerpc/mpic: Fix problem that affinity is not updated
> 
> Zheng Liu (1): ext4: fix BUG_ON() in ext4_ext_insert_extent()
> 
> hank (1): time: Change jiffies_to_clock_t() argument type to unsigned long
> 

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBCgAGBQJOuQb2AAoJEOhnXe7L7s6jSTcQAMxOH5Ep28w6ncqGBfaumZ47
5+C9s7Lp9P5ci64bZjlT76O7/XVH4JLq39K4wwwbTelsuqzVtMnNGfxwZ6VYQwaK
VmUBANy96DHr3OFA+hIDzkdl5rp07CER7/Mqb4hAL8p2FPwxUxDLiwxxTQyFHc7Z
2ertwUAIbk1rOXd8gh18rMzeRlaGQVgVpLVh0myuFgG3uPKiDc1p7NOfkOviE1cC
geUiK5VqcKsLh10VzON2f1Z4jDz2+H/q/aReEumOL9LZ4o86boSkTQZnPER68Xi4
IDjuXSD7zOJ2RJPwK4tOLGp1Io2FufvsSfsuTAchuoQtRjYwGD/8M7u3ukKAvER1
zSaNCTvImjXQUAgbISZ5w5fKIyqwZPyw+1gMkMAGmhQ/7uUO/BV3i7bR16QBjq3k
j3XzfBfTqS48wO3FJWzgxi2PwEnkxV1OEc7m93iZweaJzXyrK5ncvtd1ghf6yD1q
IyqTjdXHmDaAchYS8Ktul6MyBDNdBhXzplQCAb03q5ldxcJ4NMKNGNAYB0O2h+kp
90ixHbO93ne/qiFdH+T1XQJqxR4rjmM3+JYVZS3YgS3dpLrgvPq2Z+X1hzjD1ehj
GnbpjvyHW3OG+vg5nyljFYut+fTrkBGgHxnhzawaiBC2XrtcEcrwElnMI9lVEr9j
Vb3Q1I3VDsUl9fFLF5rO
=iu15
-----END PGP SIGNATURE-----

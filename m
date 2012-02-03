Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567Ab2BCUbW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 15:31:22 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:44802 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757299Ab2BCUbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 15:31:02 -0500
X-Sasl-enc: BvfEGrPyLBoOTIyfWBk5jLT9Wo6dHVtNmu/ghUSkKKWi 1328301061
Date: Fri, 3 Feb 2012 12:30:53 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Re: Linux 3.2.3
Message-ID: <20120203203053.GA21269@kroah.com>
References: <20120203174758.GA18584@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120203174758.GA18584@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 09:47:58AM -0800, Greg KH wrote:
> I'm announcing the release of the 3.2.3 kernel.

And here's the shortlog:

Alan Cox (1):
      USB: ftdi_sio: Add more identifiers

Alex Deucher (3):
      drm/radeon/kms: Add an MSI quirk for Dell RS690
      drm/radeon/kms: move panel mode setup into encoder mode set
      drm/radeon/kms: rework modeset sequence for DCE41 and DCE5

Alexander Shishkin (1):
      usb: gadget: langwell: don't call gadget's disconnect()

Alexey Dobriyan (2):
      crypto: sha512 - make it work, undo percpu message schedule
      crypto: sha512 - reduce stack usage to safe number

Andiry Xu (2):
      usb: gadget: storage: endian fix
      xHCI: Cleanup isoc transfer ring when TD length mismatch found

Andreas Herrmann (1):
      x86/microcode_amd: Add support for CPU family specific container files

Andreas Schwab (1):
      m68k: Fix assembler constraint to prevent overeager gcc optimisation

Bjørn Mork (5):
      USB: cdc-wdm: updating desc->length must be protected by spin_lock
      USB: cdc-wdm: use two mutexes to allow simultaneous read and write
      USB: cdc-wdm: call wake_up_all to allow driver to shutdown on device removal
      USB: cdc-wdm: better allocate a buffer that is at least as big as we tell the USB core
      USB: cdc-wdm: Avoid hanging on interface with no USB_CDC_DMM_TYPE

Cliff Wickman (1):
      x86/uv: Fix uninitialized spinlocks

Dan Williams (1):
      qcaux: add more Pantech UML190 and UML290 ports

Daniel Vetter (1):
      drm/i915: paper over missed irq issues with force wake voodoo

David S. Miller (1):
      rds: Make rds_sock_lock BH rather than IRQ safe.

David Vrabel (1):
      x86: xen: size struct xen_spinlock to always fit in arch_spinlock_t

Eric Anholt (1):
      drm/i915: Re-enable gen7 RC6 and GPU turbo after resume.

Eric Dumazet (5):
      netns: fix net_alloc_generic()
      af_unix: fix EPOLLET regression for stream sockets
      macvlan: fix a possible use after free
      net: bpf_jit: fix divide by 0 generation
      net: reintroduce missing rcu_assign_pointer() calls

Eric W. Biederman (4):
      sysfs: Complain bitterly about attempts to remove files from nonexistent directories.
      usb: io_ti: Make edge_remove_sysfs_attrs the port_remove method.
      netns: Fail conspicously if someone uses net_generic at an inappropriate time.
      net caif: Register properly as a pernet subsystem.

Felipe Balbi (1):
      usb: dwc3: ep0: tidy up Pending Request handling

Greg Kroah-Hartman (1):
      Linux 3.2.3

Guenter Roeck (1):
      hwmon: (w83627ehf) Disable setting DC mode for pwm2, pwm3 on NCT6776F

Gustavo Maciel Dias Vieira (1):
      ALSA: hda: set mute led polarity for laptops with buggy BIOS based on SSID

Harrison Metzger (1):
      USB: usbsevseg: fix max length

James Chapman (1):
      l2tp: l2tp_ip - fix possible oops on packet receive

Jan Kara (2):
      xfs: Fix missing xfs_iunlock() on error recovery path in xfs_readlink()
      jbd: Issue cache flush after checkpointing

Jean Delvare (1):
      hwmon: (f71805f) Fix clamping of temperature limits

Jiri Bohac (1):
      bonding: fix enslaving in alb mode when link down

Jiri Slaby (1):
      TTY: fix UV serial console regression

Johan Hovold (8):
      USB: ftdi_sio: fix TIOCSSERIAL baud_base handling
      USB: ftdi_sio: fix initial baud rate
      USB: cp210x: call generic open last in open
      USB: cp210x: do not map baud rates to B0
      USB: cp210x: fix up set_termios variables
      USB: cp210x: clean up, refactor and document speed handling
      USB: cp210x: initialise baud rate at open
      USB: cp210x: allow more baud rates above 1Mbaud

Johannes Berg (2):
      mac80211: fix work removal on deauth request
      iwlwifi: fix PCI-E transport "inta" race

Julia Lawall (1):
      drivers/usb/host/ehci-fsl.c: add missing iounmap

Kentaro Matsuyama (1):
      USB: option: Add LG docomo L-02C

Lucas Kannebley Tavares (1):
      jsm: Fixed EEH recovery error

Mark Brown (4):
      ASoC: Mark WM5100 register map cache only when going into BIAS_OFF
      ASoC: Disable register synchronisation for low frequency WM8996 SYSCLK
      ASoC: Don't go through cache when applying WM5100 rev A updates
      ASoC: wm8996: Call _POST_PMU callback for CPVDD

Neal Cardwell (1):
      tcp: fix tcp_trim_head() to adjust segment count with skb MSS

Nicolas Ferre (1):
      ARM: at91: fix at91rm9200 soc subtype handling

Paulo Zanoni (1):
      drm/i915/sdvo: always set positive sync polarity

Peter Korsgaard (1):
      USB: ftdi_sio: add PID for TI XDS100v2 / BeagleBone A3

Peter Naulls (1):
      USB: serial: ftdi additional IDs

Philippe Langlais (1):
      mach-ux500: no MMC_CAP_SD_HIGHSPEED on Snowball

Preston Fick (1):
      USB: cp210x: fix CP2104 baudrate usage

Rabin Vincent (1):
      serial: amba-pl011: lock console writes against interrupts

Renato Caldas (1):
      USB: serial: CP210x: Added USB-ID for the Link Instruments MSO-19

Russ Anderson (1):
      x86/uv: Fix uv_gpa_to_soc_phys_ram() shift

Ryan Mallon (1):
      vmwgfx: Fix assignment in vmw_framebuffer_create_handle

Sarah Sharp (1):
      xhci: Fix USB 3.0 device restart on resume.

Sekhar Nori (1):
      usb: musb: davinci: fix build breakage

Srinidhi KASAGAR (1):
      mach-ux500: enable ARM errata 764369

Stanislaw Gruszka (2):
      brcmsmac: fix tx queue flush infinite loop
      USB: Realtek cr: fix autopm scheduling while atomic

Stefan Berger (1):
      tpm_tis: add delay after aborting command

Takashi Iwai (4):
      ALSA: hda - Fix buffer-alignment regression with Nvidia HDMI
      ALSA: hda - Fix silent outputs from docking-station jacks of Dell laptops
      ALSA: hda - Fix silent output on ASUS A6Rp
      ALSA: hda - Fix silent output on Haier W18 laptop

Thomas Hellstrom (1):
      drm: Fix authentication kernel crash

Tim Gardner (1):
      ecryptfs: Improve metadata read failure logging

Tyler Hicks (4):
      eCryptfs: Sanitize write counts of /dev/ecryptfs
      eCryptfs: Make truncate path killable
      eCryptfs: Check inode changes in setattr
      eCryptfs: Fix oops when printing debug info in extent crypto functions

Vivien Didelot (1):
      hwmon: (sht15) fix bad error code

Will Deacon (1):
      ARM: 7296/1: proc-v7.S: remove HARVARD_CACHE preprocessor guards

nagalakshmi.nandigama@lsi.com (1):
      mpt2sas: Removed redundant calling of _scsih_probe_devices() from _scsih_probe

shawnlu (1):
      tcp: md5: using remote adress for md5 lookup in rst packet


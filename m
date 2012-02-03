Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273Ab2BCUbA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 15:31:00 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:59945 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755449Ab2BCUa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 15:30:58 -0500
X-Sasl-enc: 4wNrgzajs1JiWAdbCXqQacNJWVek1wJMR0s2MuOCrvqa 1328301057
Date: Fri, 3 Feb 2012 12:29:12 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Re: Linux 3.0.19
Message-ID: <20120203202912.GA12549@kroah.com>
References: <20120203173831.GA18014@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120203173831.GA18014@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 09:38:31AM -0800, Greg KH wrote:
> I'm announcing the release of the 3.0.19 kernel.

I forgot to include the shortlog for this release, here it is.


Alan Cox (1):
      USB: ftdi_sio: Add more identifiers

Alex Deucher (1):
      drm/radeon/kms: Add an MSI quirk for Dell RS690

Alexey Dobriyan (2):
      crypto: sha512 - make it work, undo percpu message schedule
      crypto: sha512 - reduce stack usage to safe number

Andiry Xu (1):
      xHCI: Cleanup isoc transfer ring when TD length mismatch found

Andreas Herrmann (1):
      x86/microcode_amd: Add support for CPU family specific container files

Bjørn Mork (5):
      USB: cdc-wdm: updating desc->length must be protected by spin_lock
      USB: cdc-wdm: use two mutexes to allow simultaneous read and write
      USB: cdc-wdm: call wake_up_all to allow driver to shutdown on device removal
      USB: cdc-wdm: better allocate a buffer that is at least as big as we tell the USB core
      USB: cdc-wdm: Avoid hanging on interface with no USB_CDC_DMM_TYPE

Dan Williams (1):
      qcaux: add more Pantech UML190 and UML290 ports

Dave Chinner (1):
      xfs: fix endian conversion issue in discard code

David S. Miller (1):
      rds: Make rds_sock_lock BH rather than IRQ safe.

Eric Dumazet (2):
      netns: fix net_alloc_generic()
      net: bpf_jit: fix divide by 0 generation

Eric W. Biederman (3):
      usb: io_ti: Make edge_remove_sysfs_attrs the port_remove method.
      netns: Fail conspicously if someone uses net_generic at an inappropriate time.
      net caif: Register properly as a pernet subsystem.

Greg Kroah-Hartman (1):
      Linux 3.0.19

Guenter Roeck (1):
      hwmon: (w83627ehf) Disable setting DC mode for pwm2, pwm3 on NCT6776F

Harrison Metzger (1):
      USB: usbsevseg: fix max length

James Chapman (1):
      l2tp: l2tp_ip - fix possible oops on packet receive

Jan Kara (1):
      xfs: Fix missing xfs_iunlock() on error recovery path in xfs_readlink()

Jean Delvare (1):
      hwmon: (f71805f) Fix clamping of temperature limits

Jiri Bohac (1):
      bonding: fix enslaving in alb mode when link down

Jiri Olsa (1):
      ftrace: Fix unregister ftrace_ops accounting

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

Jonathan Nieder (1):
      cap_syslog: don't use WARN_ONCE for CAP_SYS_ADMIN deprecation warning

Julia Lawall (1):
      drivers/usb/host/ehci-fsl.c: add missing iounmap

Kentaro Matsuyama (1):
      USB: option: Add LG docomo L-02C

Lucas Kannebley Tavares (1):
      jsm: Fixed EEH recovery error

Neal Cardwell (1):
      tcp: fix tcp_trim_head() to adjust segment count with skb MSS

Nick Bowler (1):
      ah: Don't return NET_XMIT_DROP on input.

Paulo Zanoni (1):
      drm/i915/sdvo: always set positive sync polarity

Peter Korsgaard (1):
      USB: ftdi_sio: add PID for TI XDS100v2 / BeagleBone A3

Peter Naulls (1):
      USB: serial: ftdi additional IDs

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

Srinidhi KASAGAR (1):
      mach-ux500: enable ARM errata 764369

Steven Rostedt (2):
      ftrace: Balance records when updating the hash
      ftrace: Update filter when tracing enabled in set_ftrace_filter()

Takashi Iwai (3):
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

shawnlu (1):
      tcp: md5: using remote adress for md5 lookup in rst packet


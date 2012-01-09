Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab2AILxV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 06:53:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40749 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753691Ab2AILxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 06:53:20 -0500
Date: Mon, 9 Jan 2012 12:53:15 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [GIT] HID #2
Message-ID: <alpine.LNX.2.00.1201091248360.24984@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

this is an updated pull request (I sent you the original one on Thu, 5 Jan 
2012 22:39:01 +0100 (CET)); as you haven't pulled the previous one yet, I 
have update the for-linus branch with the patches from Jeremy that fix 
battery reporting for apple devices, as due to my mistake, outdated 
version of the patchset has been included in the branch originally.

Other than that, nothing new has been added on top of previous request.

Thanks in advance.


The following changes are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

Aaron Tian (1):
      HID: multitouch: support PixArt optical touch screen

Benjamin Tissoires (10):
      HID: multitouch: create sysfs attribute to control quirks from user-space
      HID: multitouch: cleanup eGalax quirks
      HID: multitouch: remove .maxcontacts field for eGalax
      HID: multitouch: cleanup with eGalax PID definitions
      HID: multitouch: add support for the MSI Windpad 110W
      HID: multitouch: correct eGalax a001 protocol
      HID: multitouch: merge quanta driver into hid-multitouch
      HID: hid-multitouch: add support for new Hanvon panels
      HID: multitouch: add support of Atmel multitouch panels
      HID: multitouch: add support for 3M 32"

Chase Douglas (1):
      HID: bump maximum global item tag report size to 96 bytes

Chris Bagwell (1):
      HID: hid-multitouch - add another eGalax id

Dan Delaney (1):
      HID/usbled: add support for Dream Cheeky DL100B Mailbox Friends Alert

Daniel Kurtz (3):
      HID: usbhid: remove LED_ON
      HID: usbhid: hid-core: submit queued urbs before suspend
      HID: usbhid: defer LED setting to a workqueue

Daniel Nicoletti (1):
      hid-input: add support for HID devices reporting Battery Strength

David Herrmann (18):
      HID: wiimote: Rename driver to allow multiple source files
      HID: wiimote: Move common symbols into header
      HID: wiimote: Add read-mem helpers
      HID: wiimote: Add extension support stub
      HID: wiimote: Add extension initializer stubs
      HID: wiimote: Add extension initializers
      HID: wiimote: Add extension sysfs attribute
      HID: wiimote: Register input devices for extensions
      HID: wiimote: Add extension handler stubs
      HID: wiimote: Parse motion+ data
      HID: wiimote: Parse nunchuck data
      HID: wiimote: Parse classic controller data
      HID: wiimote: Add debugfs support stubs
      HID: wiimote: Allow direct eeprom access
      HID: wiimote: Allow direct DRM debug access
      HID: wiimote: Remove module version number
      HID: wiimote: Enable NO_INIT_REPORTS quirk
      HID: wiimote: Select INPUT_FF_MEMLESS

Ignaz Forster (1):
      HID: Enable HID_QUIRK_MULTI_INPUT for Trio Linker Plus II

Jeremy Fitzhardinge (10):
      HID: debugfs: decode Generic Device Controls Usage Page
      HID: hid-input: add support for HID devices reporting Battery Strength
      HID: hid-input: fix compile for !HID_BATTERY_STRENGTH
      hid-input/battery: remove apparently redundant kmalloc
      hid-input/battery: add quirks for battery
      hid-input/battery: deal with both FEATURE and INPUT report batteries
      hid-input/battery: make the battery setup common for INPUTs and FEATUREs
      hid-input/battery: power-supply type really *is* a battery
      hid-input/battery: remove battery_val
      hid-input/battery: add FEATURE quirk

Jiri Kosina (9):
      HID: ignore absolute values which don't fit between logical min and max
      HID: be more strict when ignoring out-of-range fields
      HID: hyperv: fixup Kconfig / Makefile entries
      HID: multitouch: make struct mt_classess static
      HID: picolcd: make fb_pending_lock and picolcd_fb_cleanup static
      HID: make parser more verbose about parsing errors by default
      HID: introduce proper dependency of HID_BATTERY on POWER_SUPPLY
      HID: Kconfig: fix syntax
      HID: emsff: use symbolic name instead of hardcoded PID constant

K. Y. Srinivasan (3):
      HID: Move the hid-hyperv driver out of staging
      Staging: hv: mousevsc: Remove the mouse driver from the staging tree
      HID: hv_mouse: Properly add the hid device

Marek Vasut (1):
      HID: multitouch: Add egalax ID for Acer Iconia W500

Masatoshi Hoshikawa (1):
      HID: hid-multitouch: add support 9 new Xiroku devices

Przemo Firszt (2):
      HID: wacom: Move parsing to a separate function
      HID: wacom: Initial driver for Wacom Intuos4 Wireless (Bluetooth)

Stefan Achatz (1):
      HID: roccat: Add support for Isku keyboard

Thomas Meyer (2):
      HID: hid-lg4ff: Casting (void *) value returned by kmalloc is useless
      HID: roccat: Use kmemdup rather than duplicating its implementation

Willem Penninckx (2):
      HID: usbkbd: synchronize LED URB submission
      HID: usbkbd: kill LED URB on disconnect

 .../ABI/testing/sysfs-driver-hid-multitouch        |    9 +
 .../ABI/testing/sysfs-driver-hid-roccat-isku       |  135 ++++
 Documentation/ABI/testing/sysfs-driver-hid-wiimote |   12 +
 drivers/hid/Kconfig                                |   38 +-
 drivers/hid/Makefile                               |   11 +-
 drivers/hid/hid-core.c                             |   82 ++-
 drivers/hid/hid-debug.c                            |    8 +
 drivers/hid/hid-emsff.c                            |    2 +-
 .../{staging/hv/hv_mouse.c => hid/hid-hyperv.c}    |  303 ++++----
 drivers/hid/hid-ids.h                              |   43 +-
 drivers/hid/hid-input.c                            |  228 ++++++-
 drivers/hid/hid-lg4ff.c                            |    2 +-
 drivers/hid/hid-multitouch.c                       |  213 +++++--
 drivers/hid/hid-picolcd.c                          |    4 +-
 drivers/hid/hid-quanta.c                           |  261 -------
 drivers/hid/hid-roccat-common.c                    |    4 +-
 drivers/hid/hid-roccat-isku.c                      |  487 +++++++++++++
 drivers/hid/hid-roccat-isku.h                      |  147 ++++
 drivers/hid/hid-roccat-kone.c                      |    4 +-
 drivers/hid/hid-wacom.c                            |  179 ++++-
 drivers/hid/{hid-wiimote.c => hid-wiimote-core.c}  |  246 +++----
 drivers/hid/hid-wiimote-debug.c                    |  227 ++++++
 drivers/hid/hid-wiimote-ext.c                      |  752 ++++++++++++++++++++
 drivers/hid/hid-wiimote.h                          |  208 ++++++
 drivers/hid/usbhid/hid-core.c                      |  241 ++++---
 drivers/hid/usbhid/hid-quirks.c                    |    4 +
 drivers/hid/usbhid/usbhid.h                        |    3 +-
 drivers/hid/usbhid/usbkbd.c                        |   64 ++-
 drivers/staging/hv/Kconfig                         |    6 -
 drivers/staging/hv/Makefile                        |    1 -
 drivers/usb/misc/usbled.c                          |    2 +
 include/linux/hid.h                                |   21 +
 32 files changed, 3151 insertions(+), 796 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-hid-multitouch
 create mode 100644 Documentation/ABI/testing/sysfs-driver-hid-roccat-isku
 rename drivers/{staging/hv/hv_mouse.c => hid/hid-hyperv.c} (75%)
 delete mode 100644 drivers/hid/hid-quanta.c
 create mode 100644 drivers/hid/hid-roccat-isku.c
 create mode 100644 drivers/hid/hid-roccat-isku.h
 rename drivers/hid/{hid-wiimote.c => hid-wiimote-core.c} (89%)
 create mode 100644 drivers/hid/hid-wiimote-debug.c
 create mode 100644 drivers/hid/hid-wiimote-ext.c
 create mode 100644 drivers/hid/hid-wiimote.h

-- 
Jiri Kosina
SUSE Labs

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759167Ab2CTWz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 18:55:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47525 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801Ab2CTWzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 18:55:25 -0400
Date: Tue, 20 Mar 2012 23:55:23 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1203202346510.18356@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive HID subsystem updates listed below.

It contains HID driver updates all over the place -- a lot of new hardware 
support especially in the multitouch area, including generic handling of 
all multitouch devices by the hid-multitiouch driver automatically.

Thanks.

Andreas Hübner (1):
      HID: add new driver for non-compliant Saitek devices

Andreas Nielsen (1):
      HID: multitouch: add PID for Fructel product

Benjamin Tissoires (11):
      HID: multitouch: add support for trackpads
      HID: multitouch: add control of the feature "Maximum Contact Number"
      HID: multitouch: support Perixx PERIPAD 701
      HID: multitouch: add support for Atmel maXTouch 03eb:2118
      HID: multitouch: add new PID from Ideacom
      HID: multitouch: add more eGalax devices
      HID: usbhid: add quirk no_get for quanta 3008 devices
      HID: multitouch: add support for eGalax 0x722a
      HID: multitouch: fix handling of buggy reports descriptors for Dell ST2220T
      HID: handle all multitouch devices through hid-multitouch
      HID: multitouch: detect serial protocol

Chase Douglas (1):
      HID: hid-magicmouse: Add pointer and buttonpad properties for Magic Trackpad

Denis Kovalev (1):
      HID: multitouch: add support of Panasonic multitouch panels

Jarod Wilson (1):
      HID: add support for tivo slide remote

Jeremy Fitzhardinge (1):
      HID: hid-input/battery: set scope and powered device for HID battery

Jiri Kosina (4):
      HID: tivo: fix broken build
      HID: correct PID for saitek PS1000
      HID: make it possible to force hid-core claim the device
      HID: tivo: add support for BT-version (0x1200)

Keng-Yu Lin (2):
      HID: add extra hotkeys in Asus AIO keyboards
      HID: add more hotkeys in Asus AIO keyboards

Konstantin Khlebnikov (1):
      HID: use generic driver for Logitech Unifying receivers if !CONFIG_HID_LOGITECH_DJ

Nestor Lopez Casado (1):
      HID: logitech: fix mask to enable DJ mode

Nikolai Kondrashov (5):
      HID: waltop: Add support for Waltop Q Pad
      HID: kye: Add support for 3 tablets
      HID: uclogic: Replace original rdescs with links
      HID: waltop: Replace original rdescs with links
      HID: waltop: Add support for tablet with PID 0038

Przemo Firszt (9):
      HID: wacom: Force new name for Wacom Intuos4 WL PTK-540WL
      HID: wacom: fix proximity tool release
      HID: wacom: set ABS_MISC bit for Intuos4 WL
      HID: wacom: Add serial and id reporting for Wacom Intuos4 WL
      HID: wacom: report distance for Intuos4 WL
      HID: wacom: Add pad buttons reporting on Intuos4 WL
      HID: wacom: Reset stylus buttons - Intuos4 WL
      HID: wacom: Replace __set_bit with input_set_capability
      HID: wacom: Add reporting of wheel for Intuos4 WL

Sean Young (1):
      HID: sjoy: Add device ID for Super Joy Box 3

Stefan Achatz (1):
      HID: roccat: Only one Kconfig entry for all roccat drivers

Ville Ranki (1):
      HID: Add quirk for CH Products Fighterstick

 drivers/hid/Kconfig             |   77 ++---
 drivers/hid/Makefile            |   13 +-
 drivers/hid/hid-chicony.c       |    7 +
 drivers/hid/hid-core.c          |   37 ++-
 drivers/hid/hid-ids.h           |   32 ++-
 drivers/hid/hid-input.c         |    9 +-
 drivers/hid/hid-kye.c           |  399 +++++++++++++++++-
 drivers/hid/hid-logitech-dj.c   |    2 +-
 drivers/hid/hid-magicmouse.c    |    2 +
 drivers/hid/hid-multitouch.c    |  222 ++++++++---
 drivers/hid/hid-saitek.c        |   70 +++
 drivers/hid/hid-sjoy.c          |    6 +-
 drivers/hid/hid-tivo.c          |   90 ++++
 drivers/hid/hid-uclogic.c       |  413 +------------------
 drivers/hid/hid-wacom.c         |   95 ++++-
 drivers/hid/hid-waltop.c        |  881 ++++++++++-----------------------------
 drivers/hid/usbhid/hid-quirks.c |    4 +
 17 files changed, 1150 insertions(+), 1209 deletions(-)
 create mode 100644 drivers/hid/hid-saitek.c
 create mode 100644 drivers/hid/hid-tivo.c

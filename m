Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360Ab0INJGE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 05:06:04 -0400
Received: from cantor.suse.de ([195.135.220.2]:53663 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198Ab0INJGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 05:06:01 -0400
Date: Tue, 14 Sep 2010 11:05:59 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1009141103490.26813@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

could you please pull from 'for-linus' branch from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive the following fixes for HID layer.

Most importantly, one hiddev and one hidraw regressions get fixed, and a 
few changes are done to fix/add support for a few specific device IDs.

Thanks.

Alan Ott (1):
      HID: Set Report ID properly for Output reports on the Control endpoint.

David Gow (1):
      HID: Add support for chicony multitouch screens.

Decio Fonini (1):
      HID: Kanvus Note A5 tablet needs HID_QUIRK_MULTI_INPUT

Guillaume Chazarain (1):
      HID: fix hiddev's use of usb_find_interface

Jiri Kosina (2):
      HID: add support for another BTC Emprex remote control
      HID: fixup blacklist entry for Asus T91MT

Johan Hovold (1):
      HID: add no-get quirk for eGalax touch controller

Roland Baum (1):
      HID: add device ID for new Asus Multitouch Controller

Thierry Reding (1):
      HID: Add quirk for eGalax touch controler.

 drivers/hid/hid-core.c          |    4 +++-
 drivers/hid/hid-ids.h           |    4 ++++
 drivers/hid/hid-mosart.c        |    1 +
 drivers/hid/hid-topseed.c       |    1 +
 drivers/hid/usbhid/hid-core.c   |    8 +++++++-
 drivers/hid/usbhid/hid-quirks.c |    4 ++++
 drivers/hid/usbhid/hiddev.c     |    2 +-
 drivers/hid/usbhid/usbhid.h     |    1 +
 8 files changed, 22 insertions(+), 3 deletions(-)

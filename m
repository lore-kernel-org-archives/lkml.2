Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab1HXSKQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 14:10:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57418 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697Ab1HXSKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 14:10:15 -0400
Date: Wed, 24 Aug 2011 20:10:13 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1108242005560.13644@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from 'for-linus' branch from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive a few HID layer updates for 3.1. There are two simple device ID 
additions, and David's series that fixes a few things in the new wiimote 
driver.

Thanks.

Dan Bastone (1):
      HID: add support for new revision of Apple aluminum keyboard

David Herrmann (5):
      HID: wiimote: Simplify synchronization
      HID: wiimote: Correctly call HID open/close callbacks
      HID: wiimote: Register led class devices
      HID: wiimote: Add drm request
      HID: wiimote: Add status and return request handlers

Jeremiah Matthey (1):
      HID: usbhid: Add support for SiGma Micro chip

 drivers/hid/Kconfig             |    1 +
 drivers/hid/hid-apple.c         |    6 +
 drivers/hid/hid-core.c          |    3 +
 drivers/hid/hid-ids.h           |    6 +
 drivers/hid/hid-wiimote.c       |  277 ++++++++++++++++++++++++++-------------
 drivers/hid/usbhid/hid-quirks.c |    1 +
 6 files changed, 200 insertions(+), 94 deletions(-)

-- 
Jiri Kosina
SUSE Labs


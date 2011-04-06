Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296Ab1DFVgs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 17:36:48 -0400
Received: from cantor.suse.de ([195.135.220.2]:39046 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932225Ab1DFVgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 17:36:46 -0400
Date: Wed, 6 Apr 2011 14:36:45 -0700 (PDT)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1104061431340.5855@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from 'for-linus' branch at

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive update for HID layer.

Most important change is Chase's patch which makes sure that no events are 
being lost when using more fingers simultaneously. This matches what we 
already do for other multitouch devices.

Other than that, it's only a few USB ID additions and a typo fix.

Thanks.

Chase Douglas (1):
      HID: hid-magicmouse: Increase evdev buffer size

Jiri Kosina (2):
      HID: add support for Skycable 0x3f07 wireless presenter
      HID: Add support for CH Pro Throttle

Simon Wood (1):
      HID: add FF support for Logitech G25/G27

Stefan Achatz (1):
      HID: roccat: Add support for wireless variant of Pyra

Stephen Boyd (1):
      HID: Fix typo Keyoutch -> Keytouch

 drivers/hid/Kconfig             |   13 ++++++++++---
 drivers/hid/hid-core.c          |    2 ++
 drivers/hid/hid-ids.h           |    4 ++++
 drivers/hid/hid-lgff.c          |    2 ++
 drivers/hid/hid-magicmouse.c    |    2 ++
 drivers/hid/hid-ortek.c         |   16 +++++++++++++---
 drivers/hid/hid-roccat-pyra.c   |    3 ++-
 drivers/hid/usbhid/hid-quirks.c |    1 +
 8 files changed, 36 insertions(+), 7 deletions(-)

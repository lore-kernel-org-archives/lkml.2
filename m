Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab0GLQ6L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 12:58:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45178 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528Ab0GLQ6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 12:58:09 -0400
Date: Mon, 12 Jul 2010 18:58:07 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1007121855180.4741@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from 'for-linus' branch

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive the fixes below. Most of the patches are simple USB ID 
additions, but the fix from Alan Ott fixes a bug introduced by 
a8ab5d58b023 (" HID: hidraw: Use Interrupt Endpoint for OUT Transfers if 
Available"), so we'd rather have that fixed for .35 still.

Thanks.

Alan Ott (1):
      HID: Send Report ID when numbered reports are sent over the control endpoint.

Jindrich Makovicka (1):
      HID: check for HID_QUIRK_IGNORE during probing

Jonathan Rockway (1):
      HID: add support for CH Eclipse yoke

Julia Lawall (1):
      HID: eliminate a double lock in debug code

Peter Edwards (1):
      HID: Enable HID_QUIRK_MULTI_INPUT for Retro Adaptor

Randy Dunlap (1):
      HID: roccat: fix modules interdependencies

micki (1):
      HID: ntrig: add support for new firwmare versions

 drivers/hid/Kconfig             |    1 +
 drivers/hid/hid-core.c          |   21 ++++++++++++++++++++-
 drivers/hid/hid-debug.c         |    2 +-
 drivers/hid/hid-ids.h           |   21 +++++++++++++++++++++
 drivers/hid/hid-ntrig.c         |   36 ++++++++++++++++++++++++++++++++++++
 drivers/hid/usbhid/hid-core.c   |   13 ++++++++++---
 drivers/hid/usbhid/hid-quirks.c |    2 ++
 7 files changed, 91 insertions(+), 5 deletions(-)

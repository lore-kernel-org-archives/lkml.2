Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645Ab2GSNec (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 09:34:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37701 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188Ab2GSNe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 09:34:28 -0400
Date: Thu, 19 Jul 2012 15:34:22 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1207191531520.28447@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git upstream-fixes

to receive a final round of changes for HID for 3.5. It's just device ID 
additions.

Thanks.

Benjamin Tissoires (1):
      HID: hid-multitouch: add support for Zytronic panels

Daniel Nicoletti (1):
      HID: add battery quirk for Apple Wireless ANSI

Frank Kunz (1):
      HID: add Sennheiser BTD500USB device support

 drivers/hid/Kconfig             |    1 +
 drivers/hid/hid-ids.h           |    6 ++++++
 drivers/hid/hid-input.c         |    3 +++
 drivers/hid/hid-multitouch.c    |    5 +++++
 drivers/hid/usbhid/hid-quirks.c |    1 +
 5 files changed, 16 insertions(+), 0 deletions(-)

-- 
Jiri Kosina
SUSE Labs

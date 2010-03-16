Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966281Ab0CPOTN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 10:19:13 -0400
Received: from cantor.suse.de ([195.135.220.2]:33936 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966252Ab0CPOTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 10:19:12 -0400
Date: Tue, 16 Mar 2010 15:19:10 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1003161402250.18642@pobox.suse.cz>
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

to receive fixes for HID code. One oops fix, some device ID updates and 
a few tiny fixes.

Thanks!


Andrej Gelenberg (1):
      HID: add quirk for UC-Logik WP4030 tablet

Bruno Prémont (1):
      HID: avoid '\0' in hid debugfs events file

Markus Rathgeb (1):
      HID: Add RGT Clutch Wheel clutch device id

Michael Poole (1):
      HID: magicmouse: fix oops after device removal

Rafi Rubin (1):
      HID: ntrig: fix touch events

 drivers/hid/hid-core.c          |    1 +
 drivers/hid/hid-debug.c         |    6 +++---
 drivers/hid/hid-ids.h           |    1 +
 drivers/hid/hid-magicmouse.c    |    7 +++++--
 drivers/hid/hid-ntrig.c         |   11 +++++++++++
 drivers/hid/hid-tmff.c          |    2 ++
 drivers/hid/usbhid/hid-quirks.c |    1 +
 7 files changed, 24 insertions(+), 5 deletions(-)

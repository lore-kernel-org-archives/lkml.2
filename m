Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758663Ab0EGVjQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 17:39:16 -0400
Received: from cantor.suse.de ([195.135.220.2]:32884 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753033Ab0EGVjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 17:39:14 -0400
Date: Fri, 7 May 2010 23:39:12 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1005072333030.9849@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please consider pulling from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive fixes which are destined for 2.6.34 still. Most of them are 
tiny behavior adjustments/fixes to individual hardware-specific drivers, 
but the one from Alan Stern is a crucial fix for bug which prevents 
suspend/resume hang.

Thanks.

Alan Ott (1):
      HID: hidraw: fix numbered reports

Alan Stern (1):
      HID: fix suspend crash by moving initializations earlier

Antonio Ospite (1):
      HID: sony: fix sony_set_operational_bt

Cory Fields (1):
      HID: wacom: remove annoying non-error printk

Jiri Kosina (1):
      HID: ntrig: explain firmware quirk

Rafi Rubin (3):
      HID: ntrig: Emit TOUCH with DOUBLETAP for single touch
      HID: ntrig: TipSwitch for single touch mode touch.
      HID: ntrig: Remove unused macro, TripleTap and QuadTap

Raphaël Doursenaud (1):
      HID: add support for cymotion master solar keyboard

Stephane Chatty (1):
      HID: fix N-trig touch panel with recent firmware

 drivers/hid/hid-cherry.c      |    1 +
 drivers/hid/hid-core.c        |   10 ++----
 drivers/hid/hid-ids.h         |    1 +
 drivers/hid/hid-ntrig.c       |   72 +++++++++++++++++++---------------------
 drivers/hid/hid-sony.c        |    2 +-
 drivers/hid/hid-wacom.c       |    1 -
 drivers/hid/usbhid/hid-core.c |   13 +++----
 7 files changed, 46 insertions(+), 54 deletions(-)

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

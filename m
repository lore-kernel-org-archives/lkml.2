Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423028Ab2JaOvE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 10:51:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53718 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422900Ab2JaOu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 10:50:57 -0400
Date: Wed, 31 Oct 2012 15:50:54 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1210311058250.25394@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive HID updates for -rc.

It contains fixes for two devices by Jiri Slaby and Xianhan Yu, new device 
IDs for MacBook Pro 10,2 from Dirk Hohndel and generic multitouch code fix 
from Alan Cox.

Thanks!

Alan Cox (1):
      HID: multitouch: put the case in the right switch statement

Dirk Hohndel (1):
      HID: Add support for the MacBook Pro 10,2 keyboard / touchpad

Jiri Slaby (1):
      HID: microsoft: fix invalid rdesc for 3k kbd

Xianhan Yu (1):
      HID: multitouch: fix maxcontacts problem on GeneralTouch

 drivers/hid/hid-apple.c       |    6 ++++++
 drivers/hid/hid-core.c        |    6 ++++++
 drivers/hid/hid-ids.h         |    3 +++
 drivers/hid/hid-microsoft.c   |   18 +++++++++++++-----
 drivers/hid/hid-multitouch.c  |    5 ++---
 drivers/input/mouse/bcm5974.c |   21 +++++++++++++++++++++
 6 files changed, 51 insertions(+), 8 deletions(-)

-- 
Jiri Kosina
SUSE Labs

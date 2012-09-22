Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab2IVJl1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 05:41:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46968 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754423Ab2IVJl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 05:41:26 -0400
Date: Sat, 22 Sep 2012 11:41:17 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1209221139140.32086@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git upstream-fixes

to receive HID fixes that should still go into 3.6. Thanks.


The most important fix is Logitech Unifying receiver regression in device 
enumeration fix from Nestor Lopez Casado. In addition to that, there is a 
small memory leak fix for Thinkpad keyboard driver from Axel Lin.


Axel Lin (1):
      HID: lenovo-tpkbd: Fix memory leak in tpkbd_remove_tp()

Nestor Lopez Casado (1):
      HID: Fix logitech-dj: missing Unifying device issue

 drivers/hid/hid-lenovo-tpkbd.c |    2 +
 drivers/hid/hid-logitech-dj.c  |   45 ++++++++++++++++++++++++++++++++++++++++
 drivers/hid/hid-logitech-dj.h  |    1 +
 3 files changed, 48 insertions(+), 0 deletions(-)

-- 
Jiri Kosina
SUSE Labs

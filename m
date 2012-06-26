Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab2FZKIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 06:08:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46633 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429Ab2FZKIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 06:08:37 -0400
Date: Tue, 26 Jun 2012 12:08:30 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1206261204360.18612@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git upstream-fixes

to receive HID patches below which should still go in 3.5. 

The most important one is a purification of Kconfig for CONFIG_HID; the 
inclusion of HID groups and autoloading didn't leave the Kconfig in a 
really consistent state. Henrik's patch fixes that.
In addition to that, there are two small fixes for logitech and magicmouse 
drivers.

Thanks.

Henrik Rydberg (1):
      HID: Fix the generic Kconfig options

Marc Dionne (1):
      HID: logitech: don't use stack based dj_report structures

Yufeng Shen (1):
      HID: magicmouse: Correct report range of major / minor axes

 drivers/hid/Kconfig           |   43 +++++++++++++++++++---------------------
 drivers/hid/hid-logitech-dj.c |   38 ++++++++++++++++++++++-------------
 drivers/hid/hid-magicmouse.c  |    6 +++-
 drivers/hid/usbhid/Kconfig    |    8 +++---
 net/bluetooth/hidp/Kconfig    |    2 +-
 5 files changed, 53 insertions(+), 44 deletions(-)

-- 
Jiri Kosina
SUSE Labs

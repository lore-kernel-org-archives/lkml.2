Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab1F0Nlv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 09:41:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45525 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435Ab1F0Nln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 09:41:43 -0400
Date: Mon, 27 Jun 2011 15:41:42 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1106271539340.11049@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from 'for-linus' branch from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive three minimalistic and self-contained fixes (and one device ID 
addition) for hid-multitouch driver.

Thanks!

Benjamin Tissoires (3):
      HID: hid-multitouch: ensure slots are initialized
      HID: hid-multitouch: correct VID for Stantum panels
      HID: hid-multitouch: add support for a new Lumio dual-touch panel

 drivers/hid/hid-core.c       |    1 +
 drivers/hid/hid-ids.h        |    1 +
 drivers/hid/hid-multitouch.c |   12 +++++++-----
 3 files changed, 9 insertions(+), 5 deletions(-)

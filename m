Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964778Ab2CENko (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 08:40:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50815 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932326Ab2CENkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:40:42 -0500
Date: Mon, 5 Mar 2012 14:40:40 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1203051434520.23367@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git upstream-fixes

to receive updates for HID layer. Nikolai's patch is rather important and 
should still go in for 3.3, as it's a regression fix for commit b4b583d. 

Thanks.

Alan Stern (1):
      HID: usbhid: Add NOGET quirk for the AIREN Slim+ keyboard

Nikolai Kondrashov (1):
      HID: hid-input: allow array fields out of range

 drivers/hid/hid-ids.h           |    3 +++
 drivers/hid/hid-input.c         |    9 +++++++--
 drivers/hid/usbhid/hid-quirks.c |    1 +
 3 files changed, 11 insertions(+), 2 deletions(-)

-- 
Jiri Kosina
SUSE Labs

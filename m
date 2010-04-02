Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173Ab0DBOjF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 10:39:05 -0400
Received: from cantor.suse.de ([195.135.220.2]:55529 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754249Ab0DBOi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 10:38:57 -0400
Date: Fri, 2 Apr 2010 16:38:56 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1004021636150.8345@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive two simple HID fixes that should be in 2.6.34.

Anisse Astier (1):
      HID: Add NOGET quirk for Quanta Pixart touchscreen

Jiri Kosina (1):
      HID: fix oops in gyration_event()

 drivers/hid/hid-gyration.c      |    5 ++++-
 drivers/hid/usbhid/hid-quirks.c |    1 +
 2 files changed, 5 insertions(+), 1 deletions(-)

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

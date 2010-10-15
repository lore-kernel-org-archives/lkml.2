Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab0JOOOj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 10:14:39 -0400
Received: from cantor.suse.de ([195.135.220.2]:59678 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754438Ab0JOOOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 10:14:38 -0400
Date: Fri, 15 Oct 2010 16:14:36 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1010151612040.6879@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from 'upstream-fixes' branch from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git upstream-fixes

to receive the fixes below. There are two one-liner fixes specific to 
support for two particular devices, but more importantly the patches from 
Antonio fix two potential NULL pointer dereferences (not a regression, and 
not triggering under normal circumstances, but still worth fixing for 
.36).

Thanks.

Antonio Ospite (2):
      HID: hidraw, fix a NULL pointer dereference in hidraw_ioctl
      HID: hidraw, fix a NULL pointer dereference in hidraw_write

François Jaouen (1):
      HID: Add Cando touch screen 15.6-inch product id

Pierre BAILLY (1):
      HID: Add MULTI_INPUT quirk for turbox/mosart touchscreen

 drivers/hid/hid-cando.c         |    2 ++
 drivers/hid/hid-core.c          |    1 +
 drivers/hid/hid-ids.h           |    2 ++
 drivers/hid/hidraw.c            |   11 +++++++++++
 drivers/hid/usbhid/hid-quirks.c |    1 +
 5 files changed, 17 insertions(+), 0 deletions(-)

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

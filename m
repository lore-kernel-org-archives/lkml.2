Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759253Ab0EZLYm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 07:24:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35777 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759196Ab0EZLYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 07:24:40 -0400
Date: Wed, 26 May 2010 13:24:39 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1005261322070.28092@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from 'for-linus' branch at

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive 2nd round of merge window updates for HID subsystem. 

Most importantly, there is a fixup patch for driver core API change which 
didn't make it from linux-next to Greg's tree from Stephen Rothwell.

On top of that, there is an update to roccat driver which was by mistake 
omitted in the initial large pull request.

Plus one minor device ID addition.

Thanks.

Cory Maccarrone (1):
      HID: Add the GYR4101US USB ID to hid-gyration

Jiri Kosina (1):
      HID: roccat: fix build failure if built as module

Stefan Achatz (1):
      HID: roccat: propagate special events of roccat hardware to userspace

Stephen Rothwell (1):
      HID: fix hid-roccat-kone for bin_attr API change

 drivers/hid/Kconfig           |    8 +
 drivers/hid/Makefile          |    1 +
 drivers/hid/hid-core.c        |    1 +
 drivers/hid/hid-gyration.c    |    1 +
 drivers/hid/hid-ids.h         |    1 +
 drivers/hid/hid-roccat-kone.c |   73 ++++++--
 drivers/hid/hid-roccat-kone.h |    9 +
 drivers/hid/hid-roccat.c      |  428 +++++++++++++++++++++++++++++++++++++++++
 drivers/hid/hid-roccat.h      |   31 +++
 9 files changed, 541 insertions(+), 12 deletions(-)
 create mode 100644 drivers/hid/hid-roccat.c
 create mode 100644 drivers/hid/hid-roccat.h

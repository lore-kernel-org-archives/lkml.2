Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348Ab1KCKuE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 06:50:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42140 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932112Ab1KCKuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 06:50:01 -0400
Date: Thu, 3 Nov 2011 11:49:59 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1111031142500.348@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from 'for-linus' branch at

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive the fixes below.

It contains a few new device ID additions, null-pointer dereference fix 
and revert of automatic binding of hid-multitouch to multitouch devices. 
It turned out to be broken and a proper solution will need quite some work 
still.

Thanks.

Andreas Krist (1):
      HID: hid-apple: add device ID of another wireless aluminium

Gökçen Eraslan (1):
      HID: Add device IDs for Macbook Pro 8 keyboards

Henrik Rydberg (1):
      Revert "HID: multitouch: decide if hid-multitouch needs to handle mt devices"

Julia Lawall (1):
      HID: drivers/hid/hid-roccat.c: eliminate a null pointer dereference

 drivers/hid/hid-apple.c      |    9 ++++++++
 drivers/hid/hid-core.c       |    7 ++++++
 drivers/hid/hid-ids.h        |    4 +++
 drivers/hid/hid-multitouch.c |   47 +++--------------------------------------
 drivers/hid/hid-roccat.c     |   18 ++++++++--------
 5 files changed, 33 insertions(+), 52 deletions(-)

-- 
Jiri Kosina
SUSE Labs

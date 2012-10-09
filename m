Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643Ab2JINa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 09:30:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754320Ab2JINaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 09:30:25 -0400
From: David Howells <dhowells@redhat.com>
To: socketcan@hartkopp.net
Cc: dhowells@redhat.com, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Disintegrate UAPI for can
Date: Tue, 09 Oct 2012 14:30:02 +0100
Message-ID: <30687.1349789402@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you merge the following branch into the can tree please.

This is to complete part of the Userspace API (UAPI) disintegration for which
the preparatory patches were pulled recently.  After these patches, userspace
headers will be segregated into:

	include/uapi/linux/.../foo.h

for the userspace interface stuff, and:

	include/linux/.../foo.h

for the strictly kernel internal stuff.

---
The following changes since commit 9e2d8656f5e8aa214e66b462680cf86b210b74a8:

  Merge branch 'akpm' (Andrew's patch-bomb) (2012-10-09 16:23:15 +0900)

are available in the git repository at:


  git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-can-20121009

for you to fetch changes up to c523b9b41d6bfdd035b5c25063ad13967f3306cd:

  UAPI: (Scripted) Disintegrate include/linux/can (2012-10-09 09:48:41 +0100)

----------------------------------------------------------------
UAPI Disintegration 2012-10-09

----------------------------------------------------------------
David Howells (1):
      UAPI: (Scripted) Disintegrate include/linux/can

 include/linux/can/Kbuild               | 5 -----
 include/uapi/linux/can/Kbuild          | 5 +++++
 include/{ => uapi}/linux/can/bcm.h     | 0
 include/{ => uapi}/linux/can/error.h   | 0
 include/{ => uapi}/linux/can/gw.h      | 0
 include/{ => uapi}/linux/can/netlink.h | 0
 include/{ => uapi}/linux/can/raw.h     | 0
 7 files changed, 5 insertions(+), 5 deletions(-)
 rename include/{ => uapi}/linux/can/bcm.h (100%)
 rename include/{ => uapi}/linux/can/error.h (100%)
 rename include/{ => uapi}/linux/can/gw.h (100%)
 rename include/{ => uapi}/linux/can/netlink.h (100%)
 rename include/{ => uapi}/linux/can/raw.h (100%)
.

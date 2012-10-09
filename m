Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887Ab2JINds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 09:33:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755717Ab2JINan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 09:30:43 -0400
From: David Howells <dhowells@redhat.com>
To: dwmw2@infradead.org
Cc: dhowells@redhat.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Disintegrate UAPI for mtd
Date: Tue, 09 Oct 2012 14:30:31 +0100
Message-ID: <30720.1349789431@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you merge the following branch into the mtd tree please.

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


  git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-mtd-20121009

for you to fetch changes up to 4a8e43feeac7996b8de2d5b2823e316917493df4:

  UAPI: (Scripted) Disintegrate include/mtd (2012-10-09 09:49:09 +0100)

----------------------------------------------------------------
UAPI Disintegration 2012-10-09

----------------------------------------------------------------
David Howells (1):
      UAPI: (Scripted) Disintegrate include/mtd

 include/mtd/Kbuild                  | 5 -----
 include/uapi/mtd/Kbuild             | 5 +++++
 include/{ => uapi}/mtd/inftl-user.h | 0
 include/{ => uapi}/mtd/mtd-abi.h    | 0
 include/{ => uapi}/mtd/mtd-user.h   | 0
 include/{ => uapi}/mtd/nftl-user.h  | 0
 include/{ => uapi}/mtd/ubi-user.h   | 0
 7 files changed, 5 insertions(+), 5 deletions(-)
 rename include/{ => uapi}/mtd/inftl-user.h (100%)
 rename include/{ => uapi}/mtd/mtd-abi.h (100%)
 rename include/{ => uapi}/mtd/mtd-user.h (100%)
 rename include/{ => uapi}/mtd/nftl-user.h (100%)
 rename include/{ => uapi}/mtd/ubi-user.h (100%)
.

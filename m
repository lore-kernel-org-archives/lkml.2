Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab2JINax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 09:30:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18965 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755646Ab2JINam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 09:30:42 -0400
From: David Howells <dhowells@redhat.com>
To: neilb@suse.de
Cc: dhowells@redhat.com, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Disintegrate UAPI for raid
Date: Tue, 09 Oct 2012 14:30:38 +0100
Message-ID: <30738.1349789438@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you merge the following branch into the raid tree please.

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


  git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-raid-20121009

for you to fetch changes up to fc5a40a2301aa241eedb16caf9169ca5763707c1:

  UAPI: (Scripted) Disintegrate include/linux/raid (2012-10-09 09:49:02 +0100)

----------------------------------------------------------------
(from the branch description for disintegrate-raid local branch)

clone of "disintegrate-scsi"
UAPI Disintegration 2012-10-09

----------------------------------------------------------------
David Howells (1):
      UAPI: (Scripted) Disintegrate include/linux/raid

 include/linux/raid/Kbuild            |   2 -
 include/linux/raid/md_u.h            | 141 +------------------------------
 include/uapi/linux/raid/Kbuild       |   2 +
 include/{ => uapi}/linux/raid/md_p.h |   0
 include/uapi/linux/raid/md_u.h       | 155 +++++++++++++++++++++++++++++++++++
 5 files changed, 158 insertions(+), 142 deletions(-)
 rename include/{ => uapi}/linux/raid/md_p.h (100%)
 create mode 100644 include/uapi/linux/raid/md_u.h
.

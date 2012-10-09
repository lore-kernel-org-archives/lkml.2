Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827Ab2JINa4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 09:30:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755664Ab2JINap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 09:30:45 -0400
From: David Howells <dhowells@redhat.com>
To: dillowda@ornl.gov
Cc: dhowells@redhat.com, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Disintegrate UAPI for rdma
Date: Tue, 09 Oct 2012 14:30:40 +0100
Message-ID: <30746.1349789440@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you merge the following branch into the rdma tree please.

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


  git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-rdma-20121009

for you to fetch changes up to e70078e9af5a4012a20448ce0af9b3b0813cc4bb:

  UAPI: (Scripted) Disintegrate include/rdma (2012-10-09 14:14:45 +0100)

----------------------------------------------------------------
(from the branch description for disintegrate-rdma local branch)

clone of "disintegrate-scsi"
UAPI Disintegration 2012-10-09

----------------------------------------------------------------
David Howells (1):
      UAPI: (Scripted) Disintegrate include/rdma

 include/rdma/Kbuild                     |  6 ------
 include/rdma/rdma_netlink.h             | 36 +-------------------------------
 include/uapi/rdma/Kbuild                |  6 ++++++
 include/{ => uapi}/rdma/ib_user_cm.h    |  0
 include/{ => uapi}/rdma/ib_user_mad.h   |  0
 include/{ => uapi}/rdma/ib_user_sa.h    |  0
 include/{ => uapi}/rdma/ib_user_verbs.h |  0
 include/uapi/rdma/rdma_netlink.h        | 37 +++++++++++++++++++++++++++++++++
 include/{ => uapi}/rdma/rdma_user_cm.h  |  0
 9 files changed, 44 insertions(+), 41 deletions(-)
 rename include/{ => uapi}/rdma/ib_user_cm.h (100%)
 rename include/{ => uapi}/rdma/ib_user_mad.h (100%)
 rename include/{ => uapi}/rdma/ib_user_sa.h (100%)
 rename include/{ => uapi}/rdma/ib_user_verbs.h (100%)
 create mode 100644 include/uapi/rdma/rdma_netlink.h
 rename include/{ => uapi}/rdma/rdma_user_cm.h (100%)
.

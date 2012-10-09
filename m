Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649Ab2JINbm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 09:31:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755713Ab2JINbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 09:31:01 -0400
From: David Howells <dhowells@redhat.com>
To: konrad.wilk@oracle.com
Cc: dhowells@redhat.com, jeremy@goop.org, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Disintegrate UAPI for xen
Date: Tue, 09 Oct 2012 14:30:52 +0100
Message-ID: <30773.1349789452@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you merge the following branch into the xen tree please.

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


  git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-xen-20121009

for you to fetch changes up to 72503791edffe516848d0f01d377fa9cd0711970:

  UAPI: (Scripted) Disintegrate include/xen (2012-10-09 09:49:15 +0100)

----------------------------------------------------------------
UAPI Disintegration 2012-10-09

----------------------------------------------------------------
David Howells (1):
      UAPI: (Scripted) Disintegrate include/xen

 include/uapi/xen/Kbuild          | 2 ++
 include/{ => uapi}/xen/evtchn.h  | 0
 include/{ => uapi}/xen/privcmd.h | 0
 include/xen/Kbuild               | 2 --
 4 files changed, 2 insertions(+), 2 deletions(-)
 rename include/{ => uapi}/xen/evtchn.h (100%)
 rename include/{ => uapi}/xen/privcmd.h (100%)
.

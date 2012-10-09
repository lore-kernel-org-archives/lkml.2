Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776Ab2JINau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 09:30:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38737 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755703Ab2JINal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 09:30:41 -0400
From: David Howells <dhowells@redhat.com>
To: khc@pm.waw.pl
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Disintegrate UAPI for hdlc
Date: Tue, 09 Oct 2012 14:30:15 +0100
Message-ID: <30693.1349789415@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you merge the following branch into the hdlc tree please.

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


  git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-hdlc-20121009

for you to fetch changes up to 76fbc143cdcb5cd13f333a71e7f9190a2e639c66:

  UAPI: (Scripted) Disintegrate include/linux/hdlc (2012-10-09 09:48:43 +0100)

----------------------------------------------------------------
UAPI Disintegration 2012-10-09

----------------------------------------------------------------
David Howells (1):
      UAPI: (Scripted) Disintegrate include/linux/hdlc

 include/linux/hdlc/Kbuild             | 1 -
 include/uapi/linux/hdlc/Kbuild        | 1 +
 include/{ => uapi}/linux/hdlc/ioctl.h | 0
 3 files changed, 1 insertion(+), 1 deletion(-)
 rename include/{ => uapi}/linux/hdlc/ioctl.h (100%)
.

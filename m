Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709Ab2JINal (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 09:30:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755674Ab2JINah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 09:30:37 -0400
From: David Howells <dhowells@redhat.com>
To: FlorianSchandinat@gmx.de
Cc: dhowells@redhat.com, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Disintegrate UAPI for fbdev
Date: Tue, 09 Oct 2012 14:30:09 +0100
Message-ID: <30690.1349789409@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you merge the following branch into the fbdev tree please.

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


  git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-fbdev-20121009

for you to fetch changes up to c86cba891a10fdc9c2218973435d0b7d0f9f5cf0:

  UAPI: (Scripted) Disintegrate include/video (2012-10-09 11:15:01 +0100)

----------------------------------------------------------------
(from the branch description for disintegrate-fbdev local branch)

clone of "disintegrate-media"
UAPI Disintegration 2012-10-09

----------------------------------------------------------------
David Howells (1):
      UAPI: (Scripted) Disintegrate include/video

 include/uapi/video/Kbuild    |   3 +
 include/uapi/video/edid.h    |   9 ++
 include/uapi/video/sisfb.h   | 209 +++++++++++++++++++++++++++++++++++++++++++
 include/uapi/video/uvesafb.h |  60 +++++++++++++
 include/video/Kbuild         |   3 -
 include/video/edid.h         |   7 +-
 include/video/sisfb.h        | 189 +-------------------------------------
 include/video/uvesafb.h      |  58 +-----------
 8 files changed, 284 insertions(+), 254 deletions(-)
 create mode 100644 include/uapi/video/edid.h
 create mode 100644 include/uapi/video/sisfb.h
 create mode 100644 include/uapi/video/uvesafb.h
.

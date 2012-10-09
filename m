Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754Ab2JINar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 09:30:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755676Ab2JINai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 09:30:38 -0400
From: David Howells <dhowells@redhat.com>
To: mchehab@infradead.org
Cc: dhowells@redhat.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Disintegrate UAPI for media
Date: Tue, 09 Oct 2012 14:30:24 +0100
Message-ID: <30699.1349789424@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you merge the following branch into the media tree please.

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


  git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-media-20121009

for you to fetch changes up to 1c436decd49665be131887b08d172a7989cdceee:

  UAPI: (Scripted) Disintegrate include/linux/dvb (2012-10-09 09:48:42 +0100)

----------------------------------------------------------------
UAPI Disintegration 2012-10-09

----------------------------------------------------------------
David Howells (1):
      UAPI: (Scripted) Disintegrate include/linux/dvb

 include/linux/dvb/Kbuild                |   8 -
 include/linux/dvb/dmx.h                 | 130 +--------------
 include/linux/dvb/video.h               | 249 +----------------------------
 include/uapi/linux/dvb/Kbuild           |   8 +
 include/{ => uapi}/linux/dvb/audio.h    |   0
 include/{ => uapi}/linux/dvb/ca.h       |   0
 include/uapi/linux/dvb/dmx.h            | 155 ++++++++++++++++++
 include/{ => uapi}/linux/dvb/frontend.h |   0
 include/{ => uapi}/linux/dvb/net.h      |   0
 include/{ => uapi}/linux/dvb/osd.h      |   0
 include/{ => uapi}/linux/dvb/version.h  |   0
 include/uapi/linux/dvb/video.h          | 274 ++++++++++++++++++++++++++++++++
 12 files changed, 439 insertions(+), 385 deletions(-)
 rename include/{ => uapi}/linux/dvb/audio.h (100%)
 rename include/{ => uapi}/linux/dvb/ca.h (100%)
 create mode 100644 include/uapi/linux/dvb/dmx.h
 rename include/{ => uapi}/linux/dvb/frontend.h (100%)
 rename include/{ => uapi}/linux/dvb/net.h (100%)
 rename include/{ => uapi}/linux/dvb/osd.h (100%)
 rename include/{ => uapi}/linux/dvb/version.h (100%)
 create mode 100644 include/uapi/linux/dvb/video.h
.

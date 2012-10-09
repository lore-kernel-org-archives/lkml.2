Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab2JINbF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 09:31:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755790Ab2JINav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 09:30:51 -0400
From: David Howells <dhowells@redhat.com>
To: gregkh@linuxfoundation.org
Cc: dhowells@redhat.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Disintegrate UAPI for usb
Date: Tue, 09 Oct 2012 14:30:48 +0100
Message-ID: <30767.1349789448@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you merge the following branch into the usb tree please.

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


  git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-usb-20121009

for you to fetch changes up to 5e1ddb481776a487b15b40579a000b279ce527c9:

  UAPI: (Scripted) Disintegrate include/linux/usb (2012-10-09 09:49:07 +0100)

----------------------------------------------------------------
UAPI Disintegration 2012-10-09

----------------------------------------------------------------
David Howells (1):
      UAPI: (Scripted) Disintegrate include/linux/usb

 include/linux/usb/Kbuild                 |  10 -
 include/linux/usb/audio.h                | 524 +---------------
 include/linux/usb/ch9.h                  | 960 +-----------------------------
 include/linux/usb/functionfs.h           | 167 +-----
 include/uapi/linux/usb/Kbuild            |  10 +
 include/uapi/linux/usb/audio.h           | 545 +++++++++++++++++
 include/{ => uapi}/linux/usb/cdc.h       |   0
 include/{ => uapi}/linux/usb/ch11.h      |   0
 include/uapi/linux/usb/ch9.h             | 993 +++++++++++++++++++++++++++++++
 include/uapi/linux/usb/functionfs.h      | 169 ++++++
 include/{ => uapi}/linux/usb/g_printer.h |   0
 include/{ => uapi}/linux/usb/gadgetfs.h  |   0
 include/{ => uapi}/linux/usb/midi.h      |   0
 include/{ => uapi}/linux/usb/tmc.h       |   0
 include/{ => uapi}/linux/usb/video.h     |   0
 15 files changed, 1720 insertions(+), 1658 deletions(-)
 create mode 100644 include/uapi/linux/usb/audio.h
 rename include/{ => uapi}/linux/usb/cdc.h (100%)
 rename include/{ => uapi}/linux/usb/ch11.h (100%)
 create mode 100644 include/uapi/linux/usb/ch9.h
 create mode 100644 include/uapi/linux/usb/functionfs.h
 rename include/{ => uapi}/linux/usb/g_printer.h (100%)
 rename include/{ => uapi}/linux/usb/gadgetfs.h (100%)
 rename include/{ => uapi}/linux/usb/midi.h (100%)
 rename include/{ => uapi}/linux/usb/tmc.h (100%)
 rename include/{ => uapi}/linux/usb/video.h (100%)
.

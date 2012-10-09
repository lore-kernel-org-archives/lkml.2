Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874Ab2JINbD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 09:31:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755786Ab2JINav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 09:30:51 -0400
From: David Howells <dhowells@redhat.com>
To: perex@perex.cz
Cc: dhowells@redhat.com, tiwai@suse.de, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Disintegrate UAPI for sound
Date: Tue, 09 Oct 2012 14:30:42 +0100
Message-ID: <30751.1349789442@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you merge the following branch into the sound tree please.

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


  git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-sound-20121009

for you to fetch changes up to 674e95ca446369e9ca40e4e92b214a616a52bcd6:

  UAPI: (Scripted) Disintegrate include/sound (2012-10-09 09:49:13 +0100)

----------------------------------------------------------------
UAPI Disintegration 2012-10-09

----------------------------------------------------------------
David Howells (1):
      UAPI: (Scripted) Disintegrate include/sound

 include/sound/Kbuild                        |  10 -
 include/sound/asequencer.h                  | 594 +----------------
 include/sound/asound.h                      | 935 +--------------------------
 include/sound/emu10k1.h                     | 355 +----------
 include/sound/sb16_csp.h                    | 104 +--
 include/uapi/sound/Kbuild                   |  10 +
 include/uapi/sound/asequencer.h             | 614 ++++++++++++++++++
 include/uapi/sound/asound.h                 | 957 ++++++++++++++++++++++++++++
 include/{ => uapi}/sound/asound_fm.h        |   0
 include/{ => uapi}/sound/compress_offload.h |   0
 include/{ => uapi}/sound/compress_params.h  |   0
 include/uapi/sound/emu10k1.h                | 373 +++++++++++
 include/{ => uapi}/sound/hdsp.h             |   0
 include/{ => uapi}/sound/hdspm.h            |   0
 include/uapi/sound/sb16_csp.h               | 122 ++++
 include/{ => uapi}/sound/sfnt_info.h        |   0
 16 files changed, 2084 insertions(+), 1990 deletions(-)
 create mode 100644 include/uapi/sound/asequencer.h
 create mode 100644 include/uapi/sound/asound.h
 rename include/{ => uapi}/sound/asound_fm.h (100%)
 rename include/{ => uapi}/sound/compress_offload.h (100%)
 rename include/{ => uapi}/sound/compress_params.h (100%)
 create mode 100644 include/uapi/sound/emu10k1.h
 rename include/{ => uapi}/sound/hdsp.h (100%)
 rename include/{ => uapi}/sound/hdspm.h (100%)
 create mode 100644 include/uapi/sound/sb16_csp.h
 rename include/{ => uapi}/sound/sfnt_info.h (100%)
.

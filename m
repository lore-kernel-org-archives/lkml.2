Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab1JVFpu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 01:45:50 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42321 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab1JVFpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 01:45:49 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Joe Perches <joe@perches.com>, Ilia Mirkin <imirkin@alum.mit.edu>,
        Youquan Song <youquan.song@intel.com>,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: [PATCH 00/36] Staging: cx25821: Clean up patch series
Date: Sat, 22 Oct 2011 13:43:20 +0800
Message-Id: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series fixes some style issues in drivers/staging/cx25821
Mostly I was hoping to improve readability and fix some issues found by
checkpatch.pl script.

There is one question, however, in patch no. 18:
I deleted part of the comment that contradicts to the code and in this
case maybe I should edit the code to match the comment instead. I am not
sure if in this case it makes sense to check if width > 0.

Leonid V. Fedorenchik (36):
      Staging: cx25821: cx25821-alsa.c: Line up comments
      Staging: cx25821: cx25821-alsa.c: Add braces to else clause
      Staging: cx25821: cx25821-alsa.c: Fix indent
      Staging: cx25821: cx25821-alsa.c: Change line endings
      Staging: cx25821: cx25821-audio-upstream.c: Fix indent
      Staging: cx25821: cx25821-audio-upstream.c: Move operators
      Staging: cx25821: cx25821-audio-upstream.c: Change line endings
      Staging: cx25821: cx25821-audio.h: Line up defines
      Staging: cx25821: cx25821-audio.h: Fix multiline defines
      Staging: cx25821: cx25821-cards.c: Fix indent
      Staging: cx25821: cx25821-core.c: Delete empty line
      Staging: cx25821: cx25821-core.c: Fix indent
      Staging: cx25821: cx25821-core.c: Change line endings
      Staging: cx25821: cx25821-i2c.c: Change line endings
      Staging: cx25821: cx25821-medusa-defines.h: Fix typo
      Staging: cx25821: cx25821-medusa-defines.h: Line up defines
      Staging: cx25821: cx25821-medusa-reg.h: Line up defines
      Staging: cx25821: cx25821-medusa-video.c: Fix comment
      Staging: cx25821: cx25821-medusa-video.c: Move operators
      Staging: cx25821: cx25821-medusa-video.c: Change line endings
      Staging: cx25821: cx25821-video-upstream-ch2.c: Line up comments
      Staging: cx25821: cx25821-video-upstream-ch2.c: Fix indent
      Staging: cx25821: cx25821-video-upsstream-ch2.c: Move operators
      Staging: cx25821: cx25821-video-upstream-ch2.c: Remove braces
      Staging: cx25821: cx25821-video-upstream-ch2.c: Change line endings
      Staging: cx25821: cx25821-video-upstream.c: Remove braces
      Staging: cx25821: cx25821-video-upstream.c: Fix indent
      Staging: cx25821: cx25821-video-upstream.c: Change line endings
      Staging: cx25821: cx25821-video.c: Delete empty line
      Staging: cx25821: cx25821-video.c: Change spaces
      Staging: cx25821: cx25821-video.c: Fix assignment
      Staging: cx25821: cx25821-video.c: Fix definitions
      Staging: cx25821: cx25821-video.c: Move operators
      Staging: cx25821: cx25821-video.c: Fix indent
      Staging: cx25821: cx25821-video.c: Change line endings
      Staging: cx25821: cx25821.h: Line up defines

 drivers/staging/cx25821/cx25821-alsa.c             |   73 ++--
 drivers/staging/cx25821/cx25821-audio-upstream.c   |  102 ++--
 drivers/staging/cx25821/cx25821-audio.h            |   39 +-
 drivers/staging/cx25821/cx25821-cards.c            |    2 +-
 drivers/staging/cx25821/cx25821-core.c             |   57 +--
 drivers/staging/cx25821/cx25821-i2c.c              |   10 +-
 drivers/staging/cx25821/cx25821-medusa-defines.h   |    6 +-
 drivers/staging/cx25821/cx25821-medusa-reg.h       |  518 ++++++++++----------
 drivers/staging/cx25821/cx25821-medusa-video.c     |  410 ++++++----------
 .../staging/cx25821/cx25821-video-upstream-ch2.c   |  126 ++---
 drivers/staging/cx25821/cx25821-video-upstream.c   |  146 +++----
 drivers/staging/cx25821/cx25821-video.c            |  145 +++---
 drivers/staging/cx25821/cx25821.h                  |    4 +-
 13 files changed, 745 insertions(+), 893 deletions(-)


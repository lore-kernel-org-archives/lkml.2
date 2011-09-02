Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108Ab1IBD4r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 23:56:47 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:42704 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757Ab1IBD4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 23:56:42 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ruslan Pisarev <ruslan@rpisarev.org.ua>,
        Ilia Mirkin <imirkin@alum.mit.edu>, Joe Perches <joe@perches.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Arnd Bergmann <arnd@arndb.de>,
        Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH v4 00/19] Staging: cx25821: Fix style issues
Date: Fri,  2 Sep 2011 11:55:28 +0800
Message-Id: <1314935747-6881-1-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series fixes some style issues in drivers/staging/cx25821

I split my previous patches per logical change and combined them into
one patch series.

Changes in v4 based on reviews of v3.

Leonid V. Fedorenchik (19):
  Staging: cx25821: Get rid of typedef in cx25821.h
  Staging: cx25821: Rename member name in struct cx25821_dev
  Staging: cx25821: Delete file cx25821-gpio.h
  Staging: cx25821: Move EXPORT_SYMBOL() to the right place
  Staging: cx25821: Use DEFINE_PCI_DEVICE_TABLE for cx25821_pci_tbl
  Staging: cx25821: Fix wrong statement indent in cx25821-cards.c
  Staging: cx25821: Fix wrong statement indent in cx25821-core.c
  Staging: cx25821: Fix wrong statement indent in cx25821-i2c.c
  Staging: cx25821: Fix too long lines in cx25821-audio.h
  Staging: cx25821: Fix obscure line endings in cx25821-audio-upstream.c
  Staging: cx25821: Fix long lines in cx25821-audio-upstream.c
  Staging: cx25821: Fix long lines in cx25821-audio-upstream.h
  Staging: cx25821: Replace :? by if-else in cx25821-video-upstream-ch2.c
  Staging: cx25821: Fix labels' placement in cx25821-video-upstream-ch2.c
  Staging: cx25821: Fix wrong line endings in cx25821-video-upstream-ch2.c
  Staging: cx25821: Fix long lines in cx25821-video-upstream-ch2.c
  Staging: cx25821: Fix long lines in cx25821-video-upstream-ch2.h
  Staging: cx25821: Fix long lines in cx25821-video-upstream.c
  Staging: cx25821: Fix long lines in cx25821-video-upstream.h

 drivers/staging/cx25821/cx25821-audio-upstream.c   |   41 +-
 drivers/staging/cx25821/cx25821-audio-upstream.h   |    9 +-
 drivers/staging/cx25821/cx25821-audio.h            |    6 +-
 drivers/staging/cx25821/cx25821-cards.c            |   26 +-
 drivers/staging/cx25821/cx25821-core.c             |  503 ++++++++++----------
 drivers/staging/cx25821/cx25821-gpio.c             |    1 +
 drivers/staging/cx25821/cx25821-gpio.h             |    2 -
 drivers/staging/cx25821/cx25821-i2c.c              |   30 +-
 .../staging/cx25821/cx25821-video-upstream-ch2.c   |   79 ++--
 .../staging/cx25821/cx25821-video-upstream-ch2.h   |   83 +++-
 drivers/staging/cx25821/cx25821-video-upstream.c   |   16 +-
 drivers/staging/cx25821/cx25821-video-upstream.h   |   78 +++-
 drivers/staging/cx25821/cx25821.h                  |   10 +-
 13 files changed, 465 insertions(+), 419 deletions(-)
 delete mode 100644 drivers/staging/cx25821/cx25821-gpio.h

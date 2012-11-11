Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab2KKMZA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 07:25:00 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60902 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538Ab2KKMY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 07:24:59 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>, Daniel Mack <zonque@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 0/8] staging: line6: checkpatch.pl cleanups
Date: Sun, 11 Nov 2012 13:24:38 +0100
Message-Id: <1352636686-31170-1-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.7.12.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series addresses a number of checkpatch.pl warnings, mostly exceeding the
80 character line limit.

Some checkpatch.pl warnings remain in the line6 driver but they are either more
difficult to resolve or I intend to drop that code entirely.  So expect a
little more time before the driver passes checkpatch.pl completely.

Stefan Hajnoczi (8):
  staging: line6: wrap >80 char lines in capture.c
  staging: line6: fix quoted string across lines in midibuf.c
  staging: line6: shorten comment below 80 chars in pcm.c
  staging: line6: drop trailing whitespace in pcm.h
  staging: line6: wrap lines to 80 chars in playback.c
  staging: line6: replace deprecated strict_strtol() in toneport.c
  staging: line6: wrap lines to 80 chars in usbdefs.h
  staging: line6: wrap comment to 80 chars in variax.c

 drivers/staging/line6/capture.c  | 13 ++++++++-----
 drivers/staging/line6/midibuf.c  |  6 +++---
 drivers/staging/line6/pcm.c      |  4 ++--
 drivers/staging/line6/pcm.h      |  2 +-
 drivers/staging/line6/playback.c | 17 +++++++++++------
 drivers/staging/line6/toneport.c |  8 ++------
 drivers/staging/line6/usbdefs.h  | 10 +++++++---
 drivers/staging/line6/variax.c   |  4 +++-
 8 files changed, 37 insertions(+), 27 deletions(-)

-- 
1.7.12.1


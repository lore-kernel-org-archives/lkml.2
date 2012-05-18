Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188Ab2EROuN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 10:50:13 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:58381 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab2EROuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 10:50:09 -0400
From: Johannes Thumshirn <morbidrsa@googlemail.com>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: grabner@icg.tugraz.at, andor.daam@googlemail.com, thomas@m3y3r.de,
        jj@chaosbits.net, stefanha@gmail.com,
        Johannes Thumshirn <morbidrsa@googlemail.com>
Subject: [PATCH] drivers/staging/line6/config.h: Delete unused header
Date: Fri, 18 May 2012 16:49:32 +0200
Message-Id: <1337352572-12026-1-git-send-email-morbidrsa@googlemail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete unused header file drivers/staging/line6/config.h

Signed-off-by: Johannes Thumshirn <morbidrsa@googlemail.com>
---
 drivers/staging/line6/config.h |   43 ----------------------------------------
 1 files changed, 0 insertions(+), 43 deletions(-)
 delete mode 100644 drivers/staging/line6/config.h

diff --git a/drivers/staging/line6/config.h b/drivers/staging/line6/config.h
deleted file mode 100644
index 2493491..0000000
--- a/drivers/staging/line6/config.h
+++ /dev/null
@@ -1,43 +0,0 @@
-/*
- * Line6 Linux USB driver - 0.8.0
- *
- * Copyright (C) 2004-2009 Markus Grabner (grabner@icg.tugraz.at)
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License as
- *	published by the Free Software Foundation, version 2.
- *
- */
-
-#ifndef CONFIG_H
-#define CONFIG_H
-
-
-#ifdef CONFIG_USB_DEBUG
-#define DEBUG 1
-#endif
-
-
-/*
- * Development tools.
- */
-#define DO_DEBUG_MESSAGES    0
-#define DO_DUMP_URB_SEND     DO_DEBUG_MESSAGES
-#define DO_DUMP_URB_RECEIVE  DO_DEBUG_MESSAGES
-#define DO_DUMP_PCM_SEND     0
-#define DO_DUMP_PCM_RECEIVE  0
-#define DO_DUMP_MIDI_SEND    DO_DEBUG_MESSAGES
-#define DO_DUMP_MIDI_RECEIVE DO_DEBUG_MESSAGES
-#define DO_DUMP_ANY          (DO_DUMP_URB_SEND || DO_DUMP_URB_RECEIVE || \
-			      DO_DUMP_PCM_SEND || DO_DUMP_PCM_RECEIVE || \
-			      DO_DUMP_MIDI_SEND || DO_DUMP_MIDI_RECEIVE)
-#define CREATE_RAW_FILE      0
-
-#if DO_DEBUG_MESSAGES
-#define DEBUG_MESSAGES(x) (x)
-#else
-#define DEBUG_MESSAGES(x)
-#endif
-
-
-#endif
-- 
1.7.7.6


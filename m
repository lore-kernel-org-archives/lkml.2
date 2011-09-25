Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751442Ab1IYHjD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 03:39:03 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36496 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab1IYHjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 03:39:01 -0400
From: David Kilroy <kilroyd@googlemail.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Cc: pe1dnn@amsat.org, David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 0/4] staging: wlags49_h2: WEXT cleanups
Date: Sun, 25 Sep 2011 08:30:17 +0100
Message-Id: <1316935821-6980-1-git-send-email-kilroyd@googlemail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are some fixes found while verifying the driver has been updated
for changes between WEXT v15 and 21. IOCTLs used for WEP look like
they should work. WPA related IOCTLS look like more work is needed
(but WPA is known to be be broken with this driver).

Should apply on top of the series "wlags49_h2: Various cleanups" (1-13
of 13) and "staging: wlags49_h2: Improve WEXT support" (1-2 of 3)

Compile tested only.

David Kilroy (4):
  staging: wlags49_h2: Fixup WEXT capabilities
  staging: wlags49_h2: Stop playing with length in GIWESSID handler
  staging: wlags49_h2: Declare support for WEXT 21
  staging: wlags49_h2: Use IW_HANDLER macro

 drivers/staging/wlags49_h2/wl_version.h |    3 +-
 drivers/staging/wlags49_h2/wl_wext.c    |  116 +++++++++++--------------------
 2 files changed, 43 insertions(+), 76 deletions(-)

-- 
1.7.4.1


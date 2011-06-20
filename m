Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528Ab1FTFpo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 01:45:44 -0400
Received: from qmta02.westchester.pa.mail.comcast.net ([76.96.62.24]:34845
	"EHLO qmta02.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752413Ab1FTFpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 01:45:42 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 22/22] staging: usbip: userspace: configure.ac: change package data
Date: Sun, 19 Jun 2011 22:44:52 -0700
Message-Id: <55814ea1c62b0b5ce0f93d303920bf9094b7da92.1308547654.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <cover.1308547654.git.mfm@muteddisk.com>
References: <cover.1308547654.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change package name to usbip-utils, email address to linux-usb, and
bump minor version number.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/userspace/configure.ac |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/usbip/userspace/configure.ac b/drivers/staging/usbip/userspace/configure.ac
index 39e4a47..89fefd5 100644
--- a/drivers/staging/usbip/userspace/configure.ac
+++ b/drivers/staging/usbip/userspace/configure.ac
@@ -1,7 +1,7 @@
 dnl Process this file with autoconf to produce a configure script.
 
 AC_PREREQ(2.59)
-AC_INIT([usbip], [1.0.0], [usbip-devel@lists.sourceforge.net])
+AC_INIT([usbip-utils], [1.1.0], [linux-usb@vger.kernel.org])
 AC_DEFINE([USBIP_VERSION], [0x00000100], [binary-coded decimal version number])
 
 CURRENT=0
-- 
1.7.5.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab1GGHlr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 03:41:47 -0400
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:43072
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751284Ab1GGHlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 03:41:45 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] staging: usbip: userspace: usbip-utils 1.1.1
Date: Thu,  7 Jul 2011 00:31:56 -0700
Message-Id: <662ccd4e5dc50b2a09ede5680c46dab6336a9639.1310023068.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1310023068.git.mfm@muteddisk.com>
References: <cover.1310023068.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bump package revision number!

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/userspace/configure.ac |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/usbip/userspace/configure.ac b/drivers/staging/usbip/userspace/configure.ac
index 89fefd5..bf5cf49 100644
--- a/drivers/staging/usbip/userspace/configure.ac
+++ b/drivers/staging/usbip/userspace/configure.ac
@@ -1,8 +1,8 @@
 dnl Process this file with autoconf to produce a configure script.
 
 AC_PREREQ(2.59)
-AC_INIT([usbip-utils], [1.1.0], [linux-usb@vger.kernel.org])
-AC_DEFINE([USBIP_VERSION], [0x00000100], [binary-coded decimal version number])
+AC_INIT([usbip-utils], [1.1.1], [linux-usb@vger.kernel.org])
+AC_DEFINE([USBIP_VERSION], [0x00000111], [binary-coded decimal version number])
 
 CURRENT=0
 REVISION=1
-- 
1.7.6


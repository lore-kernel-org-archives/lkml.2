Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365Ab1FTFpk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 01:45:40 -0400
Received: from qmta08.westchester.pa.mail.comcast.net ([76.96.62.80]:41183
	"EHLO qmta08.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752027Ab1FTFpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 01:45:30 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 01/22] staging: usbip: userspace: update cleanup.sh
Date: Sun, 19 Jun 2011 22:44:31 -0700
Message-Id: <3791d91c716b283672ac147fb5b618609a153bb1.1308547654.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <cover.1308547654.git.mfm@muteddisk.com>
References: <cover.1308547654.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify $FILES to account for the new directory layout. Also, sort the
list of files within the variable to make it human-readable.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/userspace/cleanup.sh |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/usbip/userspace/cleanup.sh b/drivers/staging/usbip/userspace/cleanup.sh
index da2f89b..955c3cc 100755
--- a/drivers/staging/usbip/userspace/cleanup.sh
+++ b/drivers/staging/usbip/userspace/cleanup.sh
@@ -1,10 +1,12 @@
-#!/bin/sh -x
-
+#!/bin/sh
 
 if [ -r Makefile ]; then
 	make distclean
 fi
 
-FILES="configure cscope.out Makefile.in depcomp compile config.guess config.sub config.h.in~ config.log config.status ltmain.sh libtool config.h.in autom4te.cache missing aclocal.m4 install-sh cmd/Makefile.in lib/Makefile.in Makefile lib/Makefile cmd/Makefile"
+FILES="aclocal.m4 autom4te.cache compile config.guess config.h.in config.log \
+       config.status config.sub configure cscope.out depcomp install-sh      \
+       libsrc/Makefile libsrc/Makefile.in libtool ltmain.sh Makefile         \
+       Makefile.in missing src/Makefile src/Makefile.in"
 
-rm -Rf $FILES
+rm -vRf $FILES
-- 
1.7.5.2


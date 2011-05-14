Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab1ENK5V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 06:57:21 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:39301 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263Ab1ENK42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 06:56:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=GN64fxImIAnsiUrIWC4WrdUzi9Ya6B0AFT4+XAsICLE42OREhJs9l1RcHDjEHfF3fs
         O7Rkr8VttK/q7+fynGvK/90WkbloZALDSG8EfmY3aJFTT45j9NrnbO0WbgUEn4pqbsLS
         Bk4E42w/i1W/lJCvVD7U2CKLjXujEp8QjnHuM=
From: matt mooney <mfmooney@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 13/14] staging: usbip: userspace: modify project gcc flags
Date: Sat, 14 May 2011 03:55:19 -0700
Message-Id: <9a672836a15b7f58a3efb7234aa8e88b3d0b7df4.1305369176.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1305369175.git.mfm@muteddisk.com>
References: <cover.1305369175.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: matt mooney <mfm@muteddisk.com>

Add -Werror, remove -Wstrict-prototypes, and change -W to -Wextra.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/userspace/configure.ac |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/usbip/userspace/configure.ac b/drivers/staging/usbip/userspace/configure.ac
index d5f6d8e..e3afa15 100644
--- a/drivers/staging/usbip/userspace/configure.ac
+++ b/drivers/staging/usbip/userspace/configure.ac
@@ -18,7 +18,7 @@ LT_INIT
 # Silent build for automake >= 1.11
 m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
 
-AC_SUBST([EXTRA_CFLAGS], ["-Wall -W -Wstrict-prototypes -std=gnu99"])
+AC_SUBST([EXTRA_CFLAGS], ["-Wall -Werror -Wextra -std=gnu99"])
 
 # Checks for programs.
 AC_PROG_CC
-- 
1.7.5.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934166Ab2DLDRf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 23:17:35 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:65462 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932654Ab2DLDRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 23:17:34 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: rdunlap@xenotime.net
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH] Documentation/initrd.txt: Change the location of util-linux
Date: Thu, 12 Apr 2012 00:14:34 -0300
Message-Id: <1334200474-28574-1-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The address of util-linux seems deprecated. The new util-linux location is 
in the kernel.org. So, change this for the correct address.

Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 Documentation/initrd.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/initrd.txt b/Documentation/initrd.txt
index 1ba84f3..3d8bc62 100644
--- a/Documentation/initrd.txt
+++ b/Documentation/initrd.txt
@@ -362,5 +362,5 @@ Resources
     http://www.almesberger.net/cv/papers/ols2k-9.ps.gz
 [2] newlib package (experimental), with initrd example
     http://sources.redhat.com/newlib/
-[3] Brouwer, Andries; "util-linux: Miscellaneous utilities for Linux"
-    ftp://ftp.win.tue.nl/pub/linux-local/utils/util-linux/
+[3] util-linux: Miscellaneous utilities for Linux
+    http://www.kernel.org/pub/linux/utils/util-linux/
-- 
1.7.7.6


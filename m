Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762722Ab0GUG72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 02:59:28 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36185 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762703Ab0GUG70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 02:59:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=gHU8uNwEqGVVj5yHG9hmmYWKoDeiFQ30aTeQOmGVM7Kv+UWQMd39CDKjoSEZqy2lU4
         gmxMTCdL3Yp+U5kTqRzuJc3v7z0vK+vdZDUZVjS6z0C9eEfmOinwmm7Cqmm1DNTjshlW
         n9wojpdj1TCrEpSx5N9+c1bvwWWmld6T6SnA0=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Michael Neuling <mikey@neuling.org>
Subject: [PATCH 92/92 v2]Documentation/powerpc/booting-without-of.txt update web address.
Date: Tue, 20 Jul 2010 23:59:37 -0700
Message-Id: <1279695577-698-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
Signed-off-by: Michael Neuling <mikey@neuling.org>
---
 Documentation/powerpc/booting-without-of.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/powerpc/booting-without-of.txt b/Documentation/powerpc/booting-without-of.txt
index 46d2210..568fa08 100644
--- a/Documentation/powerpc/booting-without-of.txt
+++ b/Documentation/powerpc/booting-without-of.txt
@@ -1048,7 +1048,7 @@ IV - "dtc", the device tree compiler
 
 
 dtc source code can be found at
-<http://ozlabs.org/~dgibson/dtc/dtc.tar.gz>
+<http://git.jdl.com/gitweb/?p=dtc.git>
 
 WARNING: This version is still in early development stage; the
 resulting device-tree "blobs" have not yet been validated with the
-- 
1.7.1.rc1.21.gf3bd6


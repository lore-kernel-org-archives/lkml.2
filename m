Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab2LLWNH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 17:13:07 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:52630 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815Ab2LLWNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 17:13:05 -0500
From: Tycho van der Ouderaa <tychovdo@gmail.com>
To: rob@landley.net
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tycho van der Ouderaa <tychovdo@gmail.com>
Subject: [PATCH] Fixed a coding style issue.
Date: Wed, 12 Dec 2012 23:12:38 +0100
Message-Id: <1355350358-25961-1-git-send-email-tychovdo@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tycho van der Ouderaa <tychovdo@gmail.com>
---
 Documentation/mono.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/mono.txt b/Documentation/mono.txt
index d01ac60..c3b76a5 100644
--- a/Documentation/mono.txt
+++ b/Documentation/mono.txt
@@ -1,5 +1,5 @@
                Mono(tm) Binary Kernel Support for Linux
-               -----------------------------------------
+               ----------------------------------------
 
 To configure Linux to automatically execute Mono-based .NET binaries
 (in the form of .exe files) without the need to use the mono CLR
-- 
1.7.10.4


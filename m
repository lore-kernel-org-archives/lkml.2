Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762576Ab0GUFTB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:19:01 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:36648 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab0GUEwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:52:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=vycxF9UdzvUaB0VKO8AGSyV6CB8xErGhomeOxmZmgIfKOdI0M2Si6NoU6S2KEJW/gf
         DJuYnGxF4uv6JLydnvM3war46pyAUAVr5kyXlV0ys3h+8yFaUyu8ZwNKEB63F7R0zgf3
         PqWcRss0nEIM+PtH8o6E9onOtPv5PpnV2YZxI=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 31/31]Documentation/filesystems/proc.txt update web address.
Date: Tue, 20 Jul 2010 21:52:48 -0700
Message-Id: <1279687982-29413-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address to the best
possible fit, and also fixes a typo.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/filesystems/proc.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index 9fb6cbe..8fe8895 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -73,9 +73,9 @@ contact Bodo  Bauer  at  bb@ricochet.net.  We'll  be happy to add them to this
 document.
 
 The   latest   version    of   this   document   is    available   online   at
-http://skaro.nightcrawler.com/~bb/Docs/Proc as HTML version.
+http://tldp.org/LDP/Linux-Filesystem-Hierarchy/html/proc.html
 
-If  the above  direction does  not works  for you,  ypu could  try the  kernel
+If  the above  direction does  not works  for you,  you could  try the  kernel
 mailing  list  at  linux-kernel@vger.kernel.org  and/or try  to  reach  me  at
 comandante@zaralinux.com.
 
-- 
1.7.1.rc1.21.gf3bd6


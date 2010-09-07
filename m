Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751366Ab0IGEYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 00:24:05 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:57922 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab0IGEYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 00:24:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=mYg9Nh3ihAql95A6o4VUY9vOhePmGOcEXOkqzD4+V77Ck9sroKb/kjfCFL3Ks9jGY1
         do22dXtQnm53Te+RQ/4b185voM5fKOlBmpGEgTt/8D+IEX/hYVakt/m18jywjMy4MpkX
         EAWRXxsoRXD4frHZpbs0zwTNQUHctNFuY/73c=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 1/2]Documentation/uml/UserModeLinux-HOWTO.txt Fix web address to one line instead of two.
Date: Mon,  6 Sep 2010 21:24:20 -0700
Message-Id: <1283833461-26449-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As mentioned in other posts, it's better to just have the web address
as one long line instead of broken into two lines.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/uml/UserModeLinux-HOWTO.txt |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/Documentation/uml/UserModeLinux-HOWTO.txt b/Documentation/uml/UserModeLinux-HOWTO.txt
index 9b7e190..a4b1ea4 100644
--- a/Documentation/uml/UserModeLinux-HOWTO.txt
+++ b/Documentation/uml/UserModeLinux-HOWTO.txt
@@ -1178,9 +1178,8 @@
 
 
 
-  Harald's original README is here <http://user-mode-linux.source-
-  forge.net/>  and explains these in detail, as well as
-  some other issues.
+  Harald's original README is here <http://user-mode-linux.source-forge.net/>
+  and explains these in detail, as well as some other issues.
 
 
 
@@ -1254,8 +1253,7 @@
   kernel.
 
   These were pointed out by Tim Robinson <timro at trkr dot net> in
-  <http://www.geocrawler.com/> name="this uml-
-  user post"> .
+  <http://www.geocrawler.com/> name="this uml-user post"> .
 
 
 
-- 
1.7.2.1


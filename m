Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933557Ab0GUFFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:05:31 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39306 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756494Ab0GUE6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:58:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=wkTGS6Slkdh53Rvzngq0S/RJ5wLJJLN2zPoQqcnkc1Yabq9h6ADf2KDmwTa1axt1bi
         WxSTDbnhwgE6P8Nw1YxOqH5L5IB7ZSx18ozw5f47FqgABH01gSb/GqAifDrXJJ9Tyk+x
         cOaWsd56lX0uEONxBMYuIxBVGcv0RPdNlXfP8=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 117/117]Documentation/uml/UserModeLinux-HOWTO.txt update web address and cleanup whitespace
Date: Tue, 20 Jul 2010 21:57:56 -0700
Message-Id: <1279688279-29683-12-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688279-29683-1-git-send-email-justinmattock@gmail.com>
References: <1279688279-29683-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Th epatch below updates the web address that seem to 
be broken, and also cleans up some white space at the begining.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/uml/UserModeLinux-HOWTO.txt |   89 +++++-----------------------
 1 files changed, 16 insertions(+), 73 deletions(-)

diff --git a/Documentation/uml/UserModeLinux-HOWTO.txt b/Documentation/uml/UserModeLinux-HOWTO.txt
index 628013f..7bde005 100644
--- a/Documentation/uml/UserModeLinux-HOWTO.txt
+++ b/Documentation/uml/UserModeLinux-HOWTO.txt
@@ -8,62 +8,6 @@
 
   Table of Contents
 
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
   1. Introduction
 
      1.1 How is User Mode Linux Different?
@@ -277,8 +221,7 @@
 
   1. Download the latest UML patch from
 
-     the download page <http://user-mode-linux.sourceforge.net/dl-
-     sf.html>
+     the download page <http://user-mode-linux.sourceforge.net/
 
      In this example, the file is uml-patch-2.4.0-prerelease.bz2.
 
@@ -438,7 +381,7 @@
   as modules, especially filesystems and network protocols and filters,
   so most symbols which need to be exported probably already are.
   However, if you do find symbols that need exporting, let  us
-  <http://user-mode-linux.sourceforge.net/contacts.html>  know, and
+  <http://user-mode-linux.sourceforge.net/>  know, and
   they'll be "taken care of".
 
 
@@ -498,8 +441,8 @@
 
   You will need a filesystem to boot UML from.  There are a number
   available for download from  here  <http://user-mode-
-  linux.sourceforge.net/dl-sf.html> .  There are also  several tools
-  <http://user-mode-linux.sourceforge.net/fs_making.html>  which can be
+  linux.sourceforge.net/> .  There are also  several tools
+  <http://user-mode-linux.sourceforge.net/>  which can be
   used to generate UML-compatible filesystem images from media.
   The kernel will boot up and present you with a login prompt.
 
@@ -575,9 +518,9 @@
 
   Here are some examples of UML in action:
 
-  +o  A login session <http://user-mode-linux.sourceforge.net/login.html>
+  +o  A login session <http://user-mode-linux.sourceforge.net/>
 
-  +o  A virtual network <http://user-mode-linux.sourceforge.net/net.html>
+  +o  A virtual network <http://user-mode-linux.sourceforge.net/>
 
 
 
@@ -1236,7 +1179,7 @@
 
 
   Harald's original README is here <http://user-mode-linux.source-
-  forge.net/text/mcast.txt>  and explains these in detail, as well as
+  forge.net/>  and explains these in detail, as well as
   some other issues.
 
 
@@ -1311,7 +1254,7 @@
   kernel.
 
   These were pointed out by Tim Robinson <timro at trkr dot net> in
-  <http://www.geocrawler.com/lists/3/SourceForge/597/0/> name="this uml-
+  <http://www.geocrawler.com/> name="this uml-
   user post"> .
 
 
@@ -2038,7 +1981,7 @@
 
   uml_moo is installed with the UML deb and RPM.  If you didn't install
   UML from one of those packages, you can also get it from the UML
-  utilities <http://user-mode-linux.sourceforge.net/dl-sf.html#UML
+  utilities <http://user-mode-linux.sourceforge.net/
   utilities>  tar file in tools/moo.
 
 
@@ -3939,16 +3882,16 @@
 
   This is a syslogd bug.  There's a race between a parent process
   installing a signal handler and its child sending the signal.  See
-  this uml-devel post <http://www.geocrawler.com/lists/3/Source-
-  Forge/709/0/6612801>  for the details.
+  this uml-devel post <http://www.geocrawler.com/>
+  for the details.
 
 
 
   1133..88..  TTUUNN//TTAAPP nneettwwoorrkkiinngg ddooeessnn''tt wwoorrkk oonn aa 22..44 hhoosstt
 
   There are a couple of problems which were
-  <http://www.geocrawler.com/lists/3/SourceForge/597/0/> name="pointed
-  out">  by Tim Robinson <timro at trkr dot net>
+  <http://www.geocrawler.com>
+  by Tim Robinson <timro at trkr dot net>
 
   +o  It doesn't work on hosts running 2.4.7 (or thereabouts) or earlier.
      The fix is to upgrade to something more recent and then read the
@@ -4326,13 +4269,13 @@
   Rusty Russell <rusty at linuxcare.com.au>  -
 
   +o  wrote the  HOWTO <http://user-mode-
-     linux.sourceforge.net/UserModeLinux-HOWTO.html>
+     linux.sourceforge.net/>
 
   +o  prodded me into making this project official and putting it on
      SourceForge
 
   +o  came up with the way cool UML logo <http://user-mode-
-     linux.sourceforge.net/uml-small.png>
+     linux.sourceforge.net/>
 
   +o  redid the config process
 
@@ -4599,7 +4542,7 @@
 
   Michael Jennings <mikejen at hevanet.com>  sent in some material which
   is now gracing the top of the  index  page <http://user-mode-
-  linux.sourceforge.net/index.html>  of this site.
+  linux.sourceforge.net/>  of this site.
 
   SGI <http://www.sgi.com>  (and more specifically Ralf Baechle <ralf at
   uni-koblenz.de> ) gave me an account on oss.sgi.com
-- 
1.7.1.rc1.21.gf3bd6


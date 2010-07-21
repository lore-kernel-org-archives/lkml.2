Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762241Ab0GUE5q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:57:46 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:37757 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933341Ab0GUE4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:56:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=GqsJhWUZ/IGA+gB8uEjuMCp98VBmQjLWLBjxeLM/Rql5S/+vmYWIYBe61NqKCfkn+p
         Pg8VljzzkQNAwzllLjgs7Agdm4UVfJCxsScNLwGeM03/dE8eR/Mf+LLM2xGk1FtAvlNv
         OK7UhxZRT9JaKAH5/Iju5P0h8N5ARMo9Ns8Q4=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 90/90]Documentation/power/video.txt update web address.
Date: Tue, 20 Jul 2010 21:55:53 -0700
Message-Id: <1279688153-29571-15-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688153-29571-1-git-send-email-justinmattock@gmail.com>
References: <1279688153-29571-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch updates a web address and removes a web address
in of which I have no idea where its at.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/power/video.txt |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/power/video.txt b/Documentation/power/video.txt
index 2b35849..3e6272b 100644
--- a/Documentation/power/video.txt
+++ b/Documentation/power/video.txt
@@ -67,11 +67,11 @@ There are a few types of systems where video works after S3 resume:
   POSTing bios works. Ole Rohne has patch to do just that at
   http://dev.gentoo.org/~marineam/patch-radeonfb-2.6.11-rc2-mm2.
 
-(8) on some systems, you can use the video_post utility mentioned here:
-  http://bugzilla.kernel.org/show_bug.cgi?id=3670. Do echo 3 > /sys/power/state
-  && /usr/sbin/video_post - which will initialize the display in console mode.
-  If  you are in X, you can switch to a virtual terminal and back to X using
-  CTRL+ALT+F1 - CTRL+ALT+F7 to get the display working in graphical mode again.
+(8) on some systems, you can use the video_post utility and or 
+  do echo 3 > /sys/power/state  && /usr/sbin/video_post - which will 
+  initialize the display in console mode. If you are in X, you can switch
+  to a virtual terminal and back to X using  CTRL+ALT+F1 - CTRL+ALT+F7 to get
+  the display working in graphical mode again.
 
 Now, if you pass acpi_sleep=something, and it does not work with your
 bios, you'll get a hard crash during resume. Be careful. Also it is
@@ -177,7 +177,7 @@ Mainboard	    Graphics card                 hack (or "how to do it")
 Asus A7V8X	    nVidia RIVA TNT2 model 64	  s3_bios,s3_mode (4)
 
 
-(*) from http://www.ubuntulinux.org/wiki/HoaryPMResults, not sure
+(*) from https://wiki.ubuntu.com/HoaryPMResults, not sure
     which options to use. If you know, please tell me.
 
 (***) To be tested with a newer kernel.
-- 
1.7.1.rc1.21.gf3bd6


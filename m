Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127Ab1JIKo2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 06:44:28 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36593 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab1JIKo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 06:44:26 -0400
From: Renzo Dani <arons7@gmail.com>
To: mchehab@infradead.org
Cc: arons7@gmail.com, rdunlap@xenotime.net, linux-media@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] update az6027 firmware URL
Date: Sun,  9 Oct 2011 12:43:50 +0200
Message-Id: <1318157030-3901-1-git-send-email-arons7@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Renzo Dani <arons7@gmail.com>


Signed-off-by: Renzo Dani <arons7@gmail.com>
---
 Documentation/dvb/get_dvb_firmware |   13 ++-----------
 1 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/Documentation/dvb/get_dvb_firmware b/Documentation/dvb/get_dvb_firmware
index c466f58..06456d0 100755
--- a/Documentation/dvb/get_dvb_firmware
+++ b/Documentation/dvb/get_dvb_firmware
@@ -575,19 +575,10 @@ sub ngene {
 }
 
 sub az6027{
-    my $file = "AZ6027_Linux_Driver.tar.gz";
-    my $url = "http://linux.terratec.de/files/$file";
     my $firmware = "dvb-usb-az6027-03.fw";
+    my $url = "http://linux.terratec.de/files/TERRATEC_S7/$firmware";
 
-    wgetfile($file, $url);
-
-    #untar
-    if( system("tar xzvf $file $firmware")){
-        die "failed to untar firmware";
-    }
-    if( system("rm $file")){
-        die ("unable to remove unnecessary files");
-    }
+    wgetfile($firmware, $url);
 
     $firmware;
 }
-- 
1.7.3.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933585Ab0GUE7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:59:31 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:47762 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933521Ab0GUE6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:58:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=X5F9rmv1ao2+L+kTXffWZoZyqRwOz/Zy7WtVYi1VqvFQS6Nm0u8UjsI7d7+y1fP4Y5
         1H9vn84qjlbxBKoUO8LIOvh5vJ3Jd/eu0oqmhNMtu9NzPiU3QQIRoKBX5vpvTC+miEBU
         ygRZgrBNvdZ8RgZXg32E7SqIXQcZCmJ0evoEs=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 123/123]Documentation/video4linux/Zoran update web address.
Date: Tue, 20 Jul 2010 21:58:40 -0700
Message-Id: <1279688336-29735-3-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688336-29735-1-git-send-email-justinmattock@gmail.com>
References: <1279688336-29735-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/video4linux/Zoran |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/video4linux/Zoran b/Documentation/video4linux/Zoran
index 0e89e76..00e3f92 100644
--- a/Documentation/video4linux/Zoran
+++ b/Documentation/video4linux/Zoran
@@ -174,7 +174,7 @@ and is used in Argentinia, Uruguay, an a few others
 We do not talk about how the audio is broadcast !
 
 A rather good sites about the TV standards are:
-http://www.sony.jp/ServiceArea/Voltage_map/
+http://www.sony.jp/support/
 http://info.electronicwerkstatt.de/bereiche/fernsehtechnik/frequenzen_und_normen/Fernsehnormen/
 and http://www.cabl.com/restaurant/channel.html
 
@@ -330,7 +330,7 @@ These extensions are known as the v4l/mjpeg extensions. See zoran.h for
 details (structs/ioctls).
 
 Information - video4linux:
-http://roadrunner.swansea.linux.org.uk/v4lapi.shtml
+http://linux.bytesex.org/v4l2/API.html
 Documentation/video4linux/API.html
 /usr/include/linux/videodev.h
 
@@ -390,7 +390,7 @@ BUZIOC_G_STATUS
 Get the status of the input lines (video source connected/norm).
 
 For programming example, please, look at lavrec.c and lavplay.c code in
-lavtools-1.2p2 package (URL: http://www.cicese.mx/~mirsev/DC10plus/)
+lavtools-1.2p2 package (URL: http://www.cicese.mx/)
 and the 'examples' directory in the original Buz driver distribution.
 
 Additional notes for software developers:
-- 
1.7.1.rc1.21.gf3bd6


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933456Ab0GUE5W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:57:22 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:37757 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762152Ab0GUE4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:56:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=gtnk5wPkRApJXn7qfGWqnB5yarpSrBEojxb90RFuVLuWxp4MYl9W/7OtDDdvbZXWxx
         xE21atTJVaPunk09gLsNL/U50byFdkQZcISSo3kMdLyzpIuYJJ0NjQC04GzBvX2PWLwA
         cgl7igS8DsvItQqoAK5bweYgHbAsYDAMeUFBE=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 83/83]Documentation/networking/packet_mmap.txt update web address.
Date: Tue, 20 Jul 2010 21:55:46 -0700
Message-Id: <1279688153-29571-8-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688153-29571-1-git-send-email-justinmattock@gmail.com>
References: <1279688153-29571-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Th epatch below updates abroken web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/networking/packet_mmap.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/packet_mmap.txt b/Documentation/networking/packet_mmap.txt
index 98f71a5..2a72262 100644
--- a/Documentation/networking/packet_mmap.txt
+++ b/Documentation/networking/packet_mmap.txt
@@ -8,7 +8,7 @@ capture network traffic with utilities like tcpdump or any other that needs
 raw access to network interface.
 
 You can find the latest version of this document at:
-    http://pusa.uv.es/~ulisses/packet_mmap/
+    http://wiki.ipxwarzone.com/index.php5?title=Linux_packet_mmap
 
 Howto can be found at:
     http://wiki.gnu-log.net (packet_mmap)
@@ -56,7 +56,7 @@ support for PACKET_MMAP, and also probably the libpcap included in your distribu
 
 I'm aware of two implementations of PACKET_MMAP in libpcap:
 
-    http://pusa.uv.es/~ulisses/packet_mmap/  (by Simon Patarin, based on libpcap 0.6.2)
+    http://wiki.ipxwarzone.com/		     (by Simon Patarin, based on libpcap 0.6.2)
     http://public.lanl.gov/cpw/              (by Phil Wood, based on lastest libpcap)
 
 The rest of this document is intended for people who want to understand
-- 
1.7.1.rc1.21.gf3bd6


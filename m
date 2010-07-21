Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762571Ab0GUFVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:21:40 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:36648 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678Ab0GUEwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:52:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=misUggiDJUsFS6FJQG76gr6QapMoMWeMiyk4LHT19Q4Y+i4xTWGzcydWW4kj/6Z9HD
         FEI6Dr2hvbt8zJidkOl8ksAING0tJRUsI5Ck4oWldLvy1We6dmaZaqLGIMAO7Js4k03F
         FrEr4ibfkqIy1/DnVoJOwglmiov/p59QxWeEs=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 18/18]Documentation/cdrom/packet-writing.txt update web address.
Date: Tue, 20 Jul 2010 21:51:54 -0700
Message-Id: <1279687926-29360-3-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279687926-29360-1-git-send-email-justinmattock@gmail.com>
References: <1279687926-29360-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes info about an old program in of which
I could not find for the life of me, and just points to a
an updated address. If anybody knows let me know and I'll resend. 

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/cdrom/packet-writing.txt |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/Documentation/cdrom/packet-writing.txt b/Documentation/cdrom/packet-writing.txt
index 1c40777..a9433b4 100644
--- a/Documentation/cdrom/packet-writing.txt
+++ b/Documentation/cdrom/packet-writing.txt
@@ -94,17 +94,7 @@ Using the pktcdvd sysfs interface
 ---------------------------------
 
 Since Linux 2.6.20, the pktcdvd module has a sysfs interface
-and can be controlled by it. For example the "pktcdvd" tool uses
-this interface. (see http://people.freenet.de/BalaGi#pktcdvd )
-
-"pktcdvd" works similar to "pktsetup", e.g.:
-
-	# pktcdvd -a dev_name /dev/hdc
-	# mkudffs /dev/pktcdvd/dev_name
-	# mount -t udf -o rw,noatime /dev/pktcdvd/dev_name /dvdram
-	# cp files /dvdram
-	# umount /dvdram
-	# pktcdvd -r dev_name
+and can be controlled by it. see: http://packet-cd.sourceforge.net/ 
 
 
 For a description of the sysfs interface look into the file:
-- 
1.7.1.rc1.21.gf3bd6


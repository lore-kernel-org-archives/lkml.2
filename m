Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933489Ab0GUE6j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:58:39 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:37757 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933453Ab0GUE5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:57:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=nP9DPObmEIwV9JZPKL1t44t4phYocI4ElYz3DjzKVWig8mI6FMu4JhAgCGHfXVqpJZ
         rcA9dOxqgZ4RFccHNpDPXN7996wrOfoUrNzznsLO9DHfcvniOrfA86CLaHvQHtofkLus
         bIyccFHh4WyuZwMQ4u/TsPCOFQ0OL5aNHAC24=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 103/103]Documentation/scsi/ppa.txt update web address.
Date: Tue, 20 Jul 2010 21:56:53 -0700
Message-Id: <1279688215-29628-13-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688215-29628-1-git-send-email-justinmattock@gmail.com>
References: <1279688215-29628-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes a web address that is broken,
and nowhere to be found. and also updates a web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/scsi/ppa.txt |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/Documentation/scsi/ppa.txt b/Documentation/scsi/ppa.txt
index 067ac39..7dbe535 100644
--- a/Documentation/scsi/ppa.txt
+++ b/Documentation/scsi/ppa.txt
@@ -1,13 +1,10 @@
 -------- Terse where to get ZIP Drive help info --------
 
 General Iomega ZIP drive page for Linux:
-http://www.torque.net/~campbell/
-
-Driver archive for old drivers:
-http://www.torque.net/~campbell/ppa/
+http://www.faqs.org/docs/Linux-mini/ZIP-Drive.html
 
 Linux Parport page (parallel port)
-http://www.torque.net/parport/
+http://people.redhat.com/twaugh/parport/html/parportguide.html
 
 Email list for Linux Parport
 linux-parport@torque.net
-- 
1.7.1.rc1.21.gf3bd6


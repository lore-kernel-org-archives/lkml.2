Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab1C3PMA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 11:12:00 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58555 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab1C3PL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 11:11:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=pqR4i2Tdaq1t56fW2YiHjIMNqEQTV/DTG0eh0rNafPi3Q5vp54Oo/1VubgSt21kKib
         zqkYOP7S8yfBfCsxhwPQlHCM8+iihbdwTX4PekGUlUE1aXoR6JBGEk2u7/qdjoHlySyZ
         bHNT+/tTnCMttIq3j+RDbQYn7MLjcpoK6QpRY=
From: Geunsik Lim <leemgs1@gmail.com>
To: Paul Menage <menage@google.com>
Cc: Jiri Kosina <trivial@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2] cgroup-doc: suitable words to explain cgroups.
Date: Thu, 31 Mar 2011 00:11:39 +0900
Message-Id: <1301497899-15322-1-git-send-email-leemgs1@gmail.com>
X-Mailer: git-send-email 1.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update suitable words to explain / understand cgroups contents.

Signed-off-by: Geunsik Lim <geunsik.lim@samsung.com>
Cc: Paul Menage <menage@google.com>
---
 Documentation/cgroups/cgroups.txt |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
index cbdfb7d..aedf1bd 100644
--- a/Documentation/cgroups/cgroups.txt
+++ b/Documentation/cgroups/cgroups.txt
@@ -110,22 +110,22 @@ university server with various users - students, professors, system
 tasks etc. The resource planning for this server could be along the
 following lines:
 
-       CPU :           Top cpuset
+       CPU :          "Top cpuset"
                        /       \
                CPUSet1         CPUSet2
-                  |              |
-               (Profs)         (Students)
+                  |               |
+               (Professors)    (Students)
 
                In addition (system tasks) are attached to topcpuset (so
                that they can run anywhere) with a limit of 20%
 
-       Memory : Professors (50%), students (30%), system (20%)
+       Memory : Professors (50%), Students (30%), system (20%)
 
-       Disk : Prof (50%), students (30%), system (20%)
+       Disk : Professors (50%), Students (30%), system (20%)
 
        Network : WWW browsing (20%), Network File System (60%), others (20%)
                                / \
-                       Prof (15%) students (5%)
+               Professors (15%)  students (5%)
 
 Browsers like Firefox/Lynx go into the WWW network class, while (k)nfsd go
 into NFS network class.
-- 
1.7.3


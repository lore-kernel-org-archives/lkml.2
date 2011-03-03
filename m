Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355Ab1CCBTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 20:19:20 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53609 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab1CCBTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 20:19:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:organization:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=fH1/Ds7QPZ84FkGpQbICpQJmAQQG2wL9fOvEzgNmhfLOdqj1xR+6qQ7VgSHOeiOFl3
         LDd9lfGnrjWHD2yhdlimhR1LnrIO5W17G3cyU8WIywSimspqEHhp44TGY2BoqUCdCLVR
         KDqIHhlEL/IwmI82njazGlb2gIL8E7UBKUU8A=
Subject: [PATCH 2/2] [TRIVIAL] Update suitable words to explain cgroups.
From: GeunSik Lim <leemgs1@gmail.com>
Reply-To: leemgs1@gmail.com
To: Jiri Kosina <trivial@kernel.org>
Cc: vatsa@in.ibm.com, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: Private
Date: Thu, 03 Mar 2011 10:19:12 +0900
Message-Id: <1299115152.10998.22.camel@centos55>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From c9d5de47e369a63164bb04d0c39eaee39d87e8b5 Mon Sep 17 00:00:00 2001
From: Geunsik Lim <geunsik.lim@samsung.com>
Date: Thu, 3 Mar 2011 09:54:42 +0900
Subject: [PATCH 2/2] Update suitable words to explain cgroups.

Signed-off-by: Geunsik Lim <geunsik.lim@samsung.com>
---
 Documentation/cgroups/cgroups.txt |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
index 44b8b7a..7252cbd 100644
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
1.6.2.5

 
-----------------------------------------------
To unsubscribe from this list: send the line "unsubscribe linux-***" 
in the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

GeunSik Lim ( Samsung Electronics )
e-Mail  :1) geunsik.lim@samsung.com
         2) leemgs@gmail.com , leemgs1@gmail.com
HomePage: http://blog.naver.com/invain/
-----------------------------------------------


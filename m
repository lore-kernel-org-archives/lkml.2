Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab1LIWMH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 17:12:07 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:43663 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751752Ab1LIWME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 17:12:04 -0500
Message-ID: <1323468720.27746.42.camel@joe2Laptop>
Subject: [PATCH] Documentation: Update stable address
From: Joe Perches <joe@perches.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Greg Kroah-Hartman <greg@kroah.com>, stable@vger.kernel.org,
        Harry Wei <harryxiyou@gmail.com>,
        xiyoulinuxkernelgroup@googlegroups.com,
        Tsugikazu Shibata <tshibata@ab.jp.nec.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 09 Dec 2011 14:12:00 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Japanese/Korean/Chinese versions still need updating.

Also, the stable kernel 2.6.x.y descriptions are out of date
and should be updated as well.

Signed-off-by: Joe Perches <joe@perches.com>
---
 Documentation/HOWTO                         |    4 ++--
 Documentation/development-process/5.Posting |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/HOWTO b/Documentation/HOWTO
index 81bc1a9..f7ade3b 100644
--- a/Documentation/HOWTO
+++ b/Documentation/HOWTO
@@ -275,8 +275,8 @@ versions.
 If no 2.6.x.y kernel is available, then the highest numbered 2.6.x
 kernel is the current stable kernel.
 
-2.6.x.y are maintained by the "stable" team <stable@kernel.org>, and are
-released as needs dictate.  The normal release period is approximately 
+2.6.x.y are maintained by the "stable" team <stable@vger.kernel.org>, and
+are released as needs dictate.  The normal release period is approximately
 two weeks, but it can be longer if there are no pressing problems.  A
 security-related problem, instead, can cause a release to happen almost
 instantly.
diff --git a/Documentation/development-process/5.Posting b/Documentation/development-process/5.Posting
index 903a254..8a48c9b 100644
--- a/Documentation/development-process/5.Posting
+++ b/Documentation/development-process/5.Posting
@@ -271,10 +271,10 @@ copies should go to:
    the linux-kernel list.
 
  - If you are fixing a bug, think about whether the fix should go into the
-   next stable update.  If so, stable@kernel.org should get a copy of the
-   patch.  Also add a "Cc: stable@kernel.org" to the tags within the patch
-   itself; that will cause the stable team to get a notification when your
-   fix goes into the mainline.
+   next stable update.  If so, stable@vger.kernel.org should get a copy of
+   the patch.  Also add a "Cc: stable@vger.kernel.org" to the tags within
+   the patch itself; that will cause the stable team to get a notification
+   when your fix goes into the mainline.
 
 When selecting recipients for a patch, it is good to have an idea of who
 you think will eventually accept the patch and get it merged.  While it




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab2AJW5J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 17:57:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51995 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647Ab2AJW5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 17:57:07 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan 10 13:46:18 2012
Message-Id: <20120110214618.428828159@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 10 Jan 2012 13:45:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Joe Perches <joe@perches.com>
Subject: [02/40] Documentation: Update stable address
In-Reply-To: <20120110214630.GA14384@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Perches <joe@perches.com>

commit 2eb7f204db51969ea558802a6601d79c2fb273b9 upstream.

The Japanese/Korean/Chinese versions still need updating.

Also, the stable kernel 2.6.x.y descriptions are out of date
and should be updated as well.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Documentation/HOWTO                         |    4 ++--
 Documentation/development-process/5.Posting |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

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



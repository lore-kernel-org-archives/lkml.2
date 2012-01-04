Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675Ab2ADSFS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 13:05:18 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:61361 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756436Ab2ADSFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 13:05:14 -0500
MIME-Version: 1.0
Date: Wed, 4 Jan 2012 19:05:13 +0100
Message-ID: <CALbm-EbAoDGyMpu7JOjk8t=2=Sn9PKS9EEuo8Gut8rwXpDQHmw@mail.gmail.com>
Subject: [PATCH] Include the git way into Documentation/SubmittingPatches
From: Stefan Beller <stefanbeller@googlemail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was quite confused when doing my first patch for linux
and the documentation told me to use "diff -up" instead of
git add/commit.

Signed-off-by: Stefan Beller <stefanbeller@googlemail.com>
---
 Documentation/SubmittingPatches |   26 ++++++++++++++++++++++----
 1 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
index 4468ce2..43acf99 100644
--- a/Documentation/SubmittingPatches
+++ b/Documentation/SubmittingPatches
@@ -20,9 +20,14 @@ Documentation/SubmittingDrivers.
 SECTION 1 - CREATING AND SENDING YOUR CHANGE
 --------------------------------------------

+The steps 1) - 3) can be either performed using the diff utility or
+using git, the distributed revision control used by the kernel developers.
+Using git is easier, but you need it installed of course.
+So either follow steps 1a), 2a) and 3a) utilising the diff method
+or just 3b) using git.


-1) "diff -up"
+1a) "diff -up"
 ------------

 Use "diff -up" or "diff -uprN" to create patches.
@@ -82,8 +87,7 @@ Instead of these scripts, quilt is the recommended
patch management
 tool (see above).


-
-2) Describe your changes.
+2a) Describe your changes.

 Describe the technical detail of the change(s) your patch includes.

@@ -111,7 +115,7 @@ If the patch fixes a logged bug entry, refer to
that bug entry by
 number and URL.


-3) Separate your changes.
+3a) Separate your changes.

 Separate _logical changes_ into a single patch file.

@@ -131,6 +135,20 @@ in your patch description.
 If you cannot condense your patch set into a smaller set of patches,
 then only post say 15 or so at a time and wait for review and integration.

+3b) Using git
+
+If you have followed 1a) 2a) and 3a), skip this step.
+
+Use "git add -i" to add all separate _logical_ changes (as described in 3a)
+to the index of git.
+
+Use "git commit" to commit all added changes into the revision control.
+A texteditor (vi, nano or graphical) will appear, which should be used to
+describe the changes. Describe the technical detail of the change(s)
+your patch includes. (see 2a for explanation of "technical changes")
+
+Use "git format-patch HEAD~1" to put your changes and your description
+into a single textfile.


 4) Style check your changes.
-- 
1.7.5.4

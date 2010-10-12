Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868Ab0JLWOJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 18:14:09 -0400
Received: from mail.perches.com ([173.55.12.10]:2820 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681Ab0JLWOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 18:14:08 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] scripts/get_maintainer.pl: Make --rolestats the default
Date: Tue, 12 Oct 2010 15:14:07 -0700
Message-Id: <74352a858e9e82ca186505aabdcc8ea2e8a7c0c8.1286921484.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This script now requires a user to add --norolestats
to the command line so it's harder to feed the output
of this script to programs that send mass emails.

Update --help to correct command line defaults.

Change version to 0.26.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/get_maintainer.pl |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index d21ec3a..43bace2 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -13,7 +13,7 @@
 use strict;
 
 my $P = $0;
-my $V = '0.26-beta6';
+my $V = '0.26';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -40,7 +40,7 @@ my $email_use_mailmap = 1;
 my $output_multiline = 1;
 my $output_separator = ", ";
 my $output_roles = 0;
-my $output_rolestats = 0;
+my $output_rolestats = 1;
 my $scm = 0;
 my $web = 0;
 my $subsystem = 0;
@@ -720,7 +720,8 @@ Other options:
   --help => show this help information
 
 Default options:
-  [--email --git --m --n --l --multiline --pattern-depth=0 --remove-duplicates]
+  [--email --nogit --git-fallback --m --n --l --multiline -pattern-depth=0
+   --remove-duplicates --rolestats]
 
 Notes:
   Using "-f directory" may give unexpected results:
-- 
1.7.3.1.g432b3.dirty


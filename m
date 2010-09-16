Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab0IPMLP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 08:11:15 -0400
Received: from mail.perches.com ([173.55.12.10]:2083 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754452Ab0IPMLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 08:11:13 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] scripts/get_maintainer.pl: Use correct indentation
Date: Thu, 16 Sep 2010 05:11:09 -0700
Message-Id: <7c14d1dcae7c87fce04b90f17c247604a709d471.1284636516.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.rc1
In-Reply-To: <cover.1284636516.git.joe@perches.com>
References: <cover.1284636516.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed an overly indented block.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/get_maintainer.pl |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index a91ae63..65c6acf 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -420,23 +420,23 @@ foreach my $file (@files) {
 
     foreach my $line (sort {$hash{$b} <=> $hash{$a}} keys %hash) {
 	add_categories($line);
-	    if ($sections) {
-		my $i;
-		my $start = find_starting_index($line);
-		my $end = find_ending_index($line);
-		for ($i = $start; $i < $end; $i++) {
-		    my $line = $typevalue[$i];
-		    if ($line =~ /^[FX]:/) {		##Restore file patterns
-			$line =~ s/([^\\])\.([^\*])/$1\?$2/g;
-			$line =~ s/([^\\])\.$/$1\?/g;	##Convert . back to ?
-			$line =~ s/\\\./\./g;       	##Convert \. to .
-			$line =~ s/\.\*/\*/g;       	##Convert .* to *
-		    }
-		    $line =~ s/^([A-Z]):/$1:\t/g;
-		    print("$line\n");
+	if ($sections) {
+	    my $i;
+	    my $start = find_starting_index($line);
+	    my $end = find_ending_index($line);
+	    for ($i = $start; $i < $end; $i++) {
+		my $line = $typevalue[$i];
+		if ($line =~ /^[FX]:/) {		##Restore file patterns
+		    $line =~ s/([^\\])\.([^\*])/$1\?$2/g;
+		    $line =~ s/([^\\])\.$/$1\?/g;	##Convert . back to ?
+		    $line =~ s/\\\./\./g;       	##Convert \. to .
+		    $line =~ s/\.\*/\*/g;       	##Convert .* to *
 		}
-		print("\n");
+		$line =~ s/^([A-Z]):/$1:\t/g;
+		print("$line\n");
 	    }
+	    print("\n");
+	}
     }
 
     if ($email && $email_git) {
-- 
1.7.3.rc1


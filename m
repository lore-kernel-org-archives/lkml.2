Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab0IWDSU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 23:18:20 -0400
Received: from mail.perches.com ([173.55.12.10]:2265 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798Ab0IWDRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 23:17:15 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] scripts/get_maintainer.pl: Correct indentation in a few places
Date: Wed, 22 Sep 2010 20:17:12 -0700
Message-Id: <252e897216c16a7d531c5907948349f188df2ca4.1285209493.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1285209493.git.joe@perches.com>
References: <cover.1285209493.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And a miscellaneous conversion of You to you in a help message

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/get_maintainer.pl |  156 ++++++++++++++++++++++----------------------
 1 files changed, 78 insertions(+), 78 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index faeace4..0abfdbc 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -306,7 +306,7 @@ sub read_mailmap {
     my $mailmap = {
 	names => {},
 	addresses => {}
-   };
+    };
 
     if (!$email_remove_duplicates) {
 	return $mailmap;
@@ -327,39 +327,39 @@ sub read_mailmap {
 	# name1 <mail1> name2 <mail2>
 	# (see man git-shortlog)
 	if (/^(.+)<(.+)>$/) {
-		my $real_name = $1;
-		my $address = $2;
+	    my $real_name = $1;
+	    my $address = $2;
 
-		$real_name =~ s/\s+$//;
-		$mailmap->{names}->{$address} = $real_name;
+	    $real_name =~ s/\s+$//;
+	    $mailmap->{names}->{$address} = $real_name;
 
 	} elsif (/^<([^\s]+)>\s*<([^\s]+)>$/) {
-		my $real_address = $1;
-		my $wrong_address = $2;
+	    my $real_address = $1;
+	    my $wrong_address = $2;
 
-		$mailmap->{addresses}->{$wrong_address} = $real_address;
+	    $mailmap->{addresses}->{$wrong_address} = $real_address;
 
 	} elsif (/^(.+)<([^\s]+)>\s*<([^\s]+)>$/) {
-		my $real_name= $1;
-		my $real_address = $2;
-		my $wrong_address = $3;
+	    my $real_name= $1;
+	    my $real_address = $2;
+	    my $wrong_address = $3;
 
-		$real_name =~ s/\s+$//;
+	    $real_name =~ s/\s+$//;
 
-		$mailmap->{names}->{$wrong_address} = $real_name;
-		$mailmap->{addresses}->{$wrong_address} = $real_address;
+	    $mailmap->{names}->{$wrong_address} = $real_name;
+	    $mailmap->{addresses}->{$wrong_address} = $real_address;
 
 	} elsif (/^(.+)<([^\s]+)>\s*([^\s].*)<([^\s]+)>$/) {
-		my $real_name = $1;
-		my $real_address = $2;
-		my $wrong_name = $3;
-		my $wrong_address = $4;
+	    my $real_name = $1;
+	    my $real_address = $2;
+	    my $wrong_name = $3;
+	    my $wrong_address = $4;
 
-		$real_name =~ s/\s+$//;
-		$wrong_name =~ s/\s+$//;
+	    $real_name =~ s/\s+$//;
+	    $wrong_name =~ s/\s+$//;
 
-		$mailmap->{names}->{format_email($wrong_name,$wrong_address,1)} = $real_name;
-		$mailmap->{addresses}->{format_email($wrong_name,$wrong_address,1)} = $real_address;
+	    $mailmap->{names}->{format_email($wrong_name,$wrong_address,1)} = $real_name;
+	    $mailmap->{addresses}->{format_email($wrong_name,$wrong_address,1)} = $real_address;
 	}
     }
     close($mailmap_file);
@@ -743,30 +743,30 @@ EOT
 }
 
 sub top_of_kernel_tree {
-	my ($lk_path) = @_;
+    my ($lk_path) = @_;
 
-	if ($lk_path ne "" && substr($lk_path,length($lk_path)-1,1) ne "/") {
-	    $lk_path .= "/";
-	}
-	if (   (-f "${lk_path}COPYING")
-	    && (-f "${lk_path}CREDITS")
-	    && (-f "${lk_path}Kbuild")
-	    && (-f "${lk_path}MAINTAINERS")
-	    && (-f "${lk_path}Makefile")
-	    && (-f "${lk_path}README")
-	    && (-d "${lk_path}Documentation")
-	    && (-d "${lk_path}arch")
-	    && (-d "${lk_path}include")
-	    && (-d "${lk_path}drivers")
-	    && (-d "${lk_path}fs")
-	    && (-d "${lk_path}init")
-	    && (-d "${lk_path}ipc")
-	    && (-d "${lk_path}kernel")
-	    && (-d "${lk_path}lib")
-	    && (-d "${lk_path}scripts")) {
-		return 1;
-	}
-	return 0;
+    if ($lk_path ne "" && substr($lk_path,length($lk_path)-1,1) ne "/") {
+	$lk_path .= "/";
+    }
+    if (   (-f "${lk_path}COPYING")
+	&& (-f "${lk_path}CREDITS")
+	&& (-f "${lk_path}Kbuild")
+	&& (-f "${lk_path}MAINTAINERS")
+	&& (-f "${lk_path}Makefile")
+	&& (-f "${lk_path}README")
+	&& (-d "${lk_path}Documentation")
+	&& (-d "${lk_path}arch")
+	&& (-d "${lk_path}include")
+	&& (-d "${lk_path}drivers")
+	&& (-d "${lk_path}fs")
+	&& (-d "${lk_path}init")
+	&& (-d "${lk_path}ipc")
+	&& (-d "${lk_path}kernel")
+	&& (-d "${lk_path}lib")
+	&& (-d "${lk_path}scripts")) {
+	return 1;
+    }
+    return 0;
 }
 
 sub parse_email {
@@ -1107,29 +1107,30 @@ sub which_conf {
 }
 
 sub mailmap_email {
-	my $line = shift;
+    my $line = shift;
 
-	my ($name, $address) = parse_email($line);
-	my $email = format_email($name, $address, 1);
-	my $real_name = $name;
-	my $real_address = $address;
-
-	if (exists $mailmap->{names}->{$email} || exists $mailmap->{addresses}->{$email}) {
-		if (exists $mailmap->{names}->{$email}) {
-			$real_name = $mailmap->{names}->{$email};
-		}
-		if (exists $mailmap->{addresses}->{$email}) {
-			$real_address = $mailmap->{addresses}->{$email};
-		}
-	} else {
-		if (exists $mailmap->{names}->{$address}) {
-			$real_name = $mailmap->{names}->{$address};
-		}
-		if (exists $mailmap->{addresses}->{$address}) {
-			$real_address = $mailmap->{addresses}->{$address};
-		}
+    my ($name, $address) = parse_email($line);
+    my $email = format_email($name, $address, 1);
+    my $real_name = $name;
+    my $real_address = $address;
+
+    if (exists $mailmap->{names}->{$email} ||
+	exists $mailmap->{addresses}->{$email}) {
+	if (exists $mailmap->{names}->{$email}) {
+	    $real_name = $mailmap->{names}->{$email};
+	}
+	if (exists $mailmap->{addresses}->{$email}) {
+	    $real_address = $mailmap->{addresses}->{$email};
+	}
+    } else {
+	if (exists $mailmap->{names}->{$address}) {
+	    $real_name = $mailmap->{names}->{$address};
+	}
+	if (exists $mailmap->{addresses}->{$address}) {
+	    $real_address = $mailmap->{addresses}->{$address};
 	}
-	return format_email($real_name, $real_address, 1);
+    }
+    return format_email($real_name, $real_address, 1);
 }
 
 sub mailmap {
@@ -1146,18 +1147,17 @@ sub mailmap {
 }
 
 sub merge_by_realname {
-	my %address_map;
-	my (@emails) = @_;
-	foreach my $email (@emails) {
-		my ($name, $address) = parse_email($email);
-		if (!exists $address_map{$name}) {
-			$address_map{$name} = $address;
-		} else {
-			$address = $address_map{$name};
-			$email = format_email($name,$address,1);
-		}
+    my %address_map;
+    my (@emails) = @_;
+    foreach my $email (@emails) {
+	my ($name, $address) = parse_email($email);
+	if (!exists $address_map{$name}) {
+	    $address_map{$name} = $address;
+	} else {
+	    $address = $address_map{$name};
+	    $email = format_email($name,$address,1);
 	}
-
+    }
 }
 
 sub git_execute_cmd {
@@ -1555,7 +1555,7 @@ commit signers and mailing lists that could be CC'd on a patch.
 
 Any *'d entry is selected.
 
-If you have git or hg installed, You can choose to summarize the commit
+If you have git or hg installed, you can choose to summarize the commit
 history of files in the patch.  Also, each line of the current file can
 be matched to its commit author and that commits signers with blame.
 
-- 
1.7.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030253Ab2B1TJh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 14:09:37 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:34747 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966016Ab2B1TJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 14:09:36 -0500
Message-ID: <1330456174.21481.6.camel@joe2Laptop>
Subject: [PATCH] get_maintainer: Use a default "unknown" S: status/role
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Tue, 28 Feb 2012 11:09:34 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When an "S:" status line is unavailable, use a default "unknown" role.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/get_maintainer.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index f32a04c..f5b1f3a 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -931,7 +931,7 @@ sub get_maintainer_role {
     my $start = find_starting_index($index);
     my $end = find_ending_index($index);
 
-    my $role;
+    my $role = "unknown";
     my $subsystem = $typevalue[$start];
     if (length($subsystem) > 20) {
 	$subsystem = substr($subsystem, 0, 17);



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056Ab1GHVmO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 17:42:14 -0400
Received: from c60.cesmail.net ([216.154.195.49]:18152 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753763Ab1GHVmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 17:42:13 -0400
Subject: [PATCH] checkpatch: suggest spaces around binary operators in
 strict mode
To: Andy Whitcroft <apw@canonical.com>
From: Pavel Roskin <proski@gnu.org>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 08 Jul 2011 17:41:59 -0400
Message-ID: <20110708214159.7559.25740.stgit@mj.roinet.com>
User-Agent: StGit/0.15-111-g507b
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 scripts/checkpatch.pl |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index b0aa2c6..9431ada 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2167,6 +2167,8 @@ sub process {
 					if ($ctx =~ /Wx[^WCE]|[^WCE]xW/) {
 						ERROR("need consistent spacing around '$op' $at\n" .
 							$hereptr);
+					} elsif ($ctx =~ /[^WCE]x[^WCE]/) {
+						CHK("spaces suggested around '$op' $at\n" . $hereptr);
 					}
 
 				# A colon needs no spaces before when it is

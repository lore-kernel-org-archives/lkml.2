Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902Ab2FTLwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 07:52:23 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:59936 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828Ab2FTLwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 07:52:21 -0400
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Cc: Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Ian Campbell <Ian.Campbell@citrix.com>,
        Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org
Subject: [PATCH] scripts/get_maintainer.pl: Add tested-by signature
Date: Wed, 20 Jun 2012 08:51:44 -0300
Message-Id: <1340193105-10734-1-git-send-email-aletes.xgr@gmail.com>
X-Mailer: git-send-email 1.7.10
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tester of the patch should also be listed to receive patch
notifications.

Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
---
 scripts/get_maintainer.pl |    1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 0948c6b..5715773 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -81,6 +81,7 @@ my $penguin_chiefs = "\(" . join("|", @penguin_chief_names) . "\)";
 my @signature_tags = ();
 push(@signature_tags, "Signed-off-by:");
 push(@signature_tags, "Reviewed-by:");
+push(@signature_tags, "Tested-by:");
 push(@signature_tags, "Acked-by:");
 
 # rfc822 email address - preloaded methods go here.
-- 
1.7.10


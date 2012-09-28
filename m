Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964960Ab2I1XoX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 19:44:23 -0400
Received: from smtp.outflux.net ([198.145.64.163]:37789 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964845Ab2I1XoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 19:44:21 -0400
Date: Fri, 28 Sep 2012 16:44:17 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Andy Whitcroft <apw@canonical.com>
Subject: [PATCH] checkpatch: fix name of "MODULE_PARM_DESC"
Message-ID: <20120928234417.GA14408@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix macro name in checkpatch: s/PARAM/PARM/.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index ca05ba2..df5e229 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2947,7 +2947,7 @@ sub process {
 			my $exceptions = qr{
 				$Declare|
 				module_param_named|
-				MODULE_PARAM_DESC|
+				MODULE_PARM_DESC|
 				DECLARE_PER_CPU|
 				DEFINE_PER_CPU|
 				__typeof__\(|
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security

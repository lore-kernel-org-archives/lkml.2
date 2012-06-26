Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074Ab2FZBeT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 21:34:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757862Ab2FZBeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 21:34:13 -0400
Date: Mon, 25 Jun 2012 21:34:03 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Rob Landley <rob@landley.net>
Cc: Miklos Szeredi <mszeredi@suse.cz>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation: kernel-parameters.txt remove
 capability.disable
Message-ID: <20120626013402.GC9997@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the documentation for capability.disable.  The code supporting this
parameter was removed with:

	commit 5915eb53861c5776cfec33ca4fcc1fd20d66dd27
	Author: Miklos Szeredi <mszeredi@suse.cz>
	Date:   Thu Jul 3 20:56:05 2008 +0200

    	security: remove dummy module

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
---
 Documentation/kernel-parameters.txt |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index a92c5eb..9415bcc 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -446,12 +446,6 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			possible to determine what the correct size should be.
 			This option provides an override for these situations.
 
-	capability.disable=
-			[SECURITY] Disable capabilities.  This would normally
-			be used only if an alternative security model is to be
-			configured.  Potentially dangerous and should only be
-			used if you are entirely sure of the consequences.
-
 	ccw_timeout_log [S390]
 			See Documentation/s390/CommonIO for details.
 
-- 
1.7.10.2


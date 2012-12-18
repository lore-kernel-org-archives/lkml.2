Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab2LRRZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 12:25:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977Ab2LRRZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 12:25:57 -0500
Date: Tue, 18 Dec 2012 12:25:01 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: Rob Landley <rob@landley.net>, Miklos Szeredi <mszeredi@suse.cz>,
        akpm@linux-foundation.org
Cc: Serge Hallyn <serge.hallyn@canonical.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] Documentation: kernel-parameters.txt remove
 capability.disable
Message-ID: <20121218172500.GC19265@hansolo.jdub.homelinux.org>
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

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Josh Boyer <jwboyer@redhat.com>
---

 Resend: I sent this back in June.  It didn't stick: https://lkml.org/lkml/2012/6/25/538

 Documentation/kernel-parameters.txt | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index ddd84d6..363e348 100644
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
1.8.0.1


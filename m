Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933630Ab0GUFAc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:00:32 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:47762 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933582Ab0GUE7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:59:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YqLcVXE/dngePPEC5f7Sq2EJhkoKyJYcsWErzqMxQU3WWJQMC/7okh9fUC8ine136Y
         lBATbh5PTAiH4xY0CI1XULr1/Ap2q32dK+jzeR4bVWq8ys6HhHK6tbSwl/Au/fRjsqP5
         I3GW2wL+MUF3SPAahg9WuXEHOFHfSyWEzymns=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 135/135]Documentation/w1/masters/ds2482 update web address.
Date: Tue, 20 Jul 2010 21:58:52 -0700
Message-Id: <1279688336-29735-15-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688336-29735-1-git-send-email-justinmattock@gmail.com>
References: <1279688336-29735-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes unused web addresses.
if aybody knows of the where abouts of these let
me know and I'll resend.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/w1/masters/ds2482 |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/Documentation/w1/masters/ds2482 b/Documentation/w1/masters/ds2482
index 299b91c..f561ed6 100644
--- a/Documentation/w1/masters/ds2482
+++ b/Documentation/w1/masters/ds2482
@@ -6,8 +6,7 @@ Supported chips:
     Prefix: 'ds2482'
     Addresses scanned: None
     Datasheets:
-        http://pdfserv.maxim-ic.com/en/ds/DS2482-100-DS2482S-100.pdf
-        http://pdfserv.maxim-ic.com/en/ds/DS2482-800-DS2482S-800.pdf
+        http://pdfserv.maxim-ic.com/
 
 Author: Ben Gardner <bgardner@wabtec.com>
 
-- 
1.7.1.rc1.21.gf3bd6


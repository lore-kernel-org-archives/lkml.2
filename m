Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441Ab0GUEw6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:52:58 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53621 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580Ab0GUEwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:52:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=XOHgMFLPNPz+sMGSeXLRBn/qGTurvoPvuioZSz4TX02TxOf2OsFFaW2TRaE10dulZL
         nxXttNqHWzZSYN82wpvtW5+QfoV0PYrTSyZr+VRARgoUN6NJ8HMF4W2BfgWPAXdJfNIG
         W52MVALWMMSlMa4CJxGS7NQn0NFYK2DWqTHro=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 25/25]Documentation/DocBook/scsi.tmpl update web address.
Date: Tue, 20 Jul 2010 21:52:01 -0700
Message-Id: <1279687926-29360-10-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279687926-29360-1-git-send-email-justinmattock@gmail.com>
References: <1279687926-29360-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/DocBook/scsi.tmpl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/DocBook/scsi.tmpl b/Documentation/DocBook/scsi.tmpl
index d87f456..324b534 100644
--- a/Documentation/DocBook/scsi.tmpl
+++ b/Documentation/DocBook/scsi.tmpl
@@ -393,7 +393,7 @@
         </para>
         <para>
           For documentation see
-          <ulink url='http://www.torque.net/sg/sdebug26.html'>http://www.torque.net/sg/sdebug26.html</ulink>
+          <ulink url='http://sg.danny.cz/sg/sdebug26.html'>http://sg.danny.cz/sg/sdebug26.html</ulink>
         </para>
 <!-- !Edrivers/scsi/scsi_debug.c -->
       </sect2>
-- 
1.7.1.rc1.21.gf3bd6


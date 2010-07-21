Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762215Ab0GUGUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 02:20:37 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:65474 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab0GUGUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 02:20:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=sQWQnI2TEUYYWP7Hcsh+3TzvwUZJBMIEKwJZdw+V7VViWVhEqmGj3DkdUa8P0siNpD
         CrI+p9fp7zXuSKf4vMeAL51428ftcnqdlnesRusuAcmv9YdaPup26FJVaL376dBA8n2v
         Su+JBeMCbk5k0OrOvOxNmHT2tzuXscFutFJe4=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Thomas Weber <thomas.weber.linux@googlemail.com>
Subject: [PATCH 135/135 v2]Documentation/w1/masters/ds2482 update web address.
Date: Tue, 20 Jul 2010 23:20:44 -0700
Message-Id: <1279693244-31942-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates some web addresses that are broken.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
Signed-off-by: Thomas Weber <thomas.weber.linux@googlemail.com>

---
 Documentation/w1/masters/ds2482 |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/w1/masters/ds2482 b/Documentation/w1/masters/ds2482
index 299b91c..56f8eda 100644
--- a/Documentation/w1/masters/ds2482
+++ b/Documentation/w1/masters/ds2482
@@ -6,8 +6,8 @@ Supported chips:
     Prefix: 'ds2482'
     Addresses scanned: None
     Datasheets:
-        http://pdfserv.maxim-ic.com/en/ds/DS2482-100-DS2482S-100.pdf
-        http://pdfserv.maxim-ic.com/en/ds/DS2482-800-DS2482S-800.pdf
+        http://datasheets.maxim-ic.com/en/ds/DS2482-100.pdf
+        http://datasheets.maxim-ic.com/en/ds/DS2482-800.pdf
 
 Author: Ben Gardner <bgardner@wabtec.com>
 
-- 
1.7.1.rc1.21.gf3bd6


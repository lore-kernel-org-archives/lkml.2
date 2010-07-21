Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762132Ab0GUEyV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:54:21 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35862 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756475Ab0GUExa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:53:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=icsp3lvKD05z7Z2Kjn7LHXcqct/XRuDvjAlMzgg+6hjvNh6A4gb1WkA+w6HfCAkwhm
         Z1Mpa4X4vJC46VRh5kyrCv/cqh9JAewK5H+4Y5HJGmRf1p7difb4fu3UzlxZ+3f/CJD6
         MqVVgfnnt4BHjeLjQeWCwosKFnLICLR+bGmrs=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 45/45]Documentation/hwmon/k8temp update web address.
Date: Tue, 20 Jul 2010 21:53:02 -0700
Message-Id: <1279687982-29413-15-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279687982-29413-1-git-send-email-justinmattock@gmail.com>
References: <1279687982-29413-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates the broken web address to the company site
due to me being unable to locate the original content.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/hwmon/k8temp |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/hwmon/k8temp b/Documentation/hwmon/k8temp
index 0005c71..7ced42e 100644
--- a/Documentation/hwmon/k8temp
+++ b/Documentation/hwmon/k8temp
@@ -5,7 +5,7 @@ Supported chips:
   * AMD Athlon64/FX or Opteron CPUs
     Prefix: 'k8temp'
     Addresses scanned: PCI space
-    Datasheet: http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/32559.pdf
+    Datasheet: http://www.amd.com/
 
 Author: Rudolf Marek
 Contact: Rudolf Marek <r.marek@assembler.cz>
-- 
1.7.1.rc1.21.gf3bd6


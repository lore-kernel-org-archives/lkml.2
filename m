Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762460Ab0GUFKS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:10:18 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:37757 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933336Ab0GUE4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:56:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qFcsF9aiecQ8rdK1msaCTjC7DKaRVJsuc3wZAM9OfFAYdI5+z1+jLEtTizyldQZqDM
         XCV8ENxy0KmOzXLsSwoR8VdO+ElngjhV7zpGf/chthD18MlQCZ1fQuA1OTyAAeYmYQWR
         s3k22RXT13DGx/fABfnFC1/TH2+DKGpG0d3c8=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 89/89]Documentation/power/basic-pm-debugging.txt update web address
Date: Tue, 20 Jul 2010 21:55:52 -0700
Message-Id: <1279688153-29571-14-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688153-29571-1-git-send-email-justinmattock@gmail.com>
References: <1279688153-29571-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/power/basic-pm-debugging.txt |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/Documentation/power/basic-pm-debugging.txt b/Documentation/power/basic-pm-debugging.txt
index 1555001..ddd7817 100644
--- a/Documentation/power/basic-pm-debugging.txt
+++ b/Documentation/power/basic-pm-debugging.txt
@@ -179,8 +179,7 @@ use the PM_TRACE mechanism documented in Documentation/s2ram.txt .
 
 To verify that the STR works, it is generally more convenient to use the s2ram
 tool available from http://suspend.sf.net and documented at
-http://en.opensuse.org/s2ram .  However, before doing that it is recommended to
-carry out STR testing using the facility described in section 1.
+http://en.opensuse.org/SDB:Suspend_to_RAM.
 
 Namely, after writing "freezer", "devices", "platform", "processors", or "core"
 into /sys/power/pm_test (available if the kernel is compiled with
-- 
1.7.1.rc1.21.gf3bd6


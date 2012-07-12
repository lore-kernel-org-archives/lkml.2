Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552Ab2GLAqL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 20:46:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62902 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756039Ab2GLApA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 20:45:00 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: Richard Fontana <fontana2012@gmail.com>
Cc: "Bradley M. Kuhn" <bkuhn@ebb.org>, linux-kernel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 3/4] copyleft-next: rename the file COPYLEFT.next to copyleft-next
Date: Wed, 11 Jul 2012 17:44:48 -0700
Message-Id: <1342053889-32066-4-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.7.10.rc1.22.gf5241
In-Reply-To: <1342053889-32066-1-git-send-email-mcgrof@do-not-panic.com>
References: <1342053889-32066-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

Also update the CONTRIBUTING to reflect the new file name
change.
---
 CONTRIBUTING                   |    2 +-
 COPYLEFT.next => copyleft-next |    0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename COPYLEFT.next => copyleft-next (100%)

diff --git a/CONTRIBUTING b/CONTRIBUTING
index d06f5da..8f214b1 100644
--- a/CONTRIBUTING
+++ b/CONTRIBUTING
@@ -1,7 +1,7 @@
 
 Contributions of any sort (text suggestions, ideas, feedback,
 criticism) from all interested individuals are welcome and encouraged.
-All original contributions to Copyleft.next are dedicated to the
+All original contributions to copyleft-next are dedicated to the
 public domain to the maximum extent permitted by applicable law,
 pursuant to CC0. See CC0 for further details.
 
diff --git a/COPYLEFT.next b/copyleft-next
similarity index 100%
rename from COPYLEFT.next
rename to copyleft-next
-- 
1.7.10.rc1.22.gf5241


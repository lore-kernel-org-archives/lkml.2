Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482Ab2GANrD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 09:47:03 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:2418 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932331Ab2GANrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 09:47:02 -0400
Message-ID: <1341150416.1911.121.camel@x61.thuisdomein>
Subject: [PATCH 6/6] [TRIVIAL] oss: remove maui_boot.h from .gitignore and
 dontdiff
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Sun, 01 Jul 2012 15:46:56 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 01 Jul 2012 13:46:56.0672 (UTC) FILETIME=[FB015200:01CD578F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d56b9b9c464a10ab1ee51a4c6190a2b57b8ef7a6 ("The scheduled removal
of some OSS drivers") removed all traces of maui_boot.h from the tree.
Remove its entries in dontdiff and oss's .gitignore file.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested with git grep only.

 Documentation/dontdiff |    1 -
 sound/oss/.gitignore   |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/Documentation/dontdiff b/Documentation/dontdiff
index 381f3f9..b89a739 100644
--- a/Documentation/dontdiff
+++ b/Documentation/dontdiff
@@ -162,7 +162,6 @@ mach-types.h
 machtypes.h
 map
 map_hugetlb
-maui_boot.h
 media
 mconf
 miboot*
diff --git a/sound/oss/.gitignore b/sound/oss/.gitignore
index 7efb12b..12a3920 100644
--- a/sound/oss/.gitignore
+++ b/sound/oss/.gitignore
@@ -1,4 +1,3 @@
 #Ignore generated files
-maui_boot.h
 pss_boot.h
 trix_boot.h
-- 
1.7.7.6


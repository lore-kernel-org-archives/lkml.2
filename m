Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760753Ab0HESb1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 14:31:27 -0400
Received: from xenotime.net ([72.52.115.56]:53846 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758591Ab0HESbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 14:31:07 -0400
Date: Thu, 05 Aug 2010 11:23:11 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7/7] docbook: use IDs as filenames to support multiple books
Message-ID: <1281032591712@xenotime.net>
In-Reply-To: <12810325911230@xenotime.net>
X-Mailer: gregkh_patchbomb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

I'm trying to generate a <set> of <book>s in
docbook for wireless to link together all the
cfg80211 and mac80211 documentation.

However, docbook will generate "re01.html"
anew for each book for the first <refentry>,
presumably due to a bug in the stylesheets.

An effective workaround is to use IDs for the
filenames, which makes them more descriptive
as well, e.g. API-enum-ieee80211-band.html.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/DocBook/stylesheet.xsl |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.35-rc3-git4.orig/Documentation/DocBook/stylesheet.xsl
+++ linux-2.6.35-rc3-git4/Documentation/DocBook/stylesheet.xsl
@@ -6,4 +6,5 @@
 <param name="callout.graphics">0</param>
 <!-- <param name="paper.type">A4</param> -->
 <param name="generate.section.toc.level">2</param>
+<param name="use.id.as.filename">1</param>
 </stylesheet>


-- 


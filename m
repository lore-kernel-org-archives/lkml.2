Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213Ab0F3SA7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 14:00:59 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:57911 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221Ab0F3SA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 14:00:58 -0400
Subject: [PATCH] docbook: use ID as filename
From: Johannes Berg <johannes@sipsolutions.net>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Jun 2010 20:00:55 +0200
Message-ID: <1277920855.7823.12.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
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

Cc: Randy Dunlap <rdunlap@xenotime.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 Documentation/DocBook/stylesheet.xsl |    1 +
 1 file changed, 1 insertion(+)

--- wireless-testing.orig/Documentation/DocBook/stylesheet.xsl	2010-06-30 19:57:19.000000000 +0200
+++ wireless-testing/Documentation/DocBook/stylesheet.xsl	2010-06-30 19:57:23.000000000 +0200
@@ -6,4 +6,5 @@
 <param name="callout.graphics">0</param>
 <!-- <param name="paper.type">A4</param> -->
 <param name="generate.section.toc.level">2</param>
+<param name="use.id.as.filename">1</param>
 </stylesheet>



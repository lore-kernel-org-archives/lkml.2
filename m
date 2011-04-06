Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136Ab1DFUeg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 16:34:36 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:50639 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805Ab1DFUef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 16:34:35 -0400
Subject: [PATCH] [TRIVIAL] openezx-devel is moderated for non-subscribers
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Apr 2011 22:34:00 +0200
Message-ID: <1302122040.22852.26.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6b4b9cd..eb33d95 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -729,7 +729,7 @@ ARM/EZX SMARTPHONES (A780, A910, A1200, E680, ROKR E2 and ROKR E6)
 M:	Daniel Ribeiro <drwyrm@gmail.com>
 M:	Stefan Schmidt <stefan@openezx.org>
 M:	Harald Welte <laforge@openezx.org>
-L:	openezx-devel@lists.openezx.org (subscribers-only)
+L:	openezx-devel@lists.openezx.org (moderated for non-subscribers)
 W:	http://www.openezx.org/
 S:	Maintained
 T:	topgit git://git.openezx.org/openezx.git
-- 
1.7.4




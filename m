Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316Ab2ATUg5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 15:36:57 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:36005 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756263Ab2ATUgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 15:36:53 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 3/5] MAINTAINERS: Remove staging sections
Date: Fri, 20 Jan 2012 12:36:19 -0800
Message-Id: <5304b69bedd953fd3ddedac22d79c088468b4b18.1327091633.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1327091633.git.joe@perches.com>
References: <cover.1327091633.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two commits moved files from staging to drivers/media/

commit d6ce55de3abcc ("[media] move cx25821 out of staging")
commit be30497085080 ("[media] move tm6000 to drivers/media/video")

Remove the sections.

cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 39d9e78..3b99e4a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6312,11 +6312,6 @@ M:	Mori Hess <fmhess@users.sourceforge.net>
 S:	Odd Fixes
 F:	drivers/staging/comedi/
 
-STAGING - CONEXANT CX25821 PCIE BRIDGE
-L:	linux-media@vger.kernel.org
-S:	Odd Fixes
-F:	drivers/staging/cx25821/
-
 STAGING - CRYSTAL HD VIDEO DECODER
 M:	Naren Sankar <nsankar@broadcom.com>
 M:	Jarod Wilson <jarod@wilsonet.com>
@@ -6409,11 +6404,6 @@ M:	Omar Ramirez Luna <omar.ramirez@ti.com>
 S:	Odd Fixes
 F:	drivers/staging/tidspbridge/
 
-STAGING - TRIDENT TVMASTER TMxxxx USB VIDEO CAPTURE DRIVERS
-L:	linux-media@vger.kernel.org
-S:	Odd Fixes
-F:	drivers/staging/tm6000/
-
 STAGING - USB ENE SM/MS CARD READER DRIVER
 M:	Al Cho <acho@novell.com>
 S:	Odd Fixes
-- 
1.7.8.111.gad25c.dirty


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178Ab1LIINk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 03:13:40 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:36352 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751313Ab1LIINi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 03:13:38 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: David Cross <odc@cypress.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 4/8] MAINTAINERS: staging: westbridge: Delete section
Date: Fri,  9 Dec 2011 00:12:50 -0800
Message-Id: <1a51e2ea56c1f2ffb06a75bb0876dd019458cac7.1323418149.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1323418149.git.joe@perches.com>
References: <cover.1323418149.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 78f23926dff9 ("Staging: delete westbridge code")
deleted the files, delete the section.

CC: David Cross <odc@cypress.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8a889b7..e397c1f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6255,11 +6255,6 @@ M:	Manu Abraham <abraham.manu@gmail.com>
 S:	Odd Fixes
 F:	drivers/staging/crystalhd/
 
-STAGING - CYPRESS WESTBRIDGE SUPPORT
-M:	David Cross <david.cross@cypress.com>
-S:	Odd Fixes
-F:	drivers/staging/westbridge/
-
 STAGING - ECHO CANCELLER
 M:	Steve Underwood <steveu@coppice.org>
 M:	David Rowe <david@rowetel.com>
-- 
1.7.8.111.gad25c.dirty


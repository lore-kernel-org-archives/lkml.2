Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443Ab2FKJSo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 05:18:44 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40634 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225Ab2FKJSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 05:18:40 -0400
From: kosaki.motohiro@gmail.com
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Andrew Morton <akpm@google.com>,
        Dave Jones <davej@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Christoph Lameter <cl@linux.com>, stable@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 6/6] MAINTAINERS: Added MEMPOLICY entry
Date: Mon, 11 Jun 2012 05:17:30 -0400
Message-Id: <1339406250-10169-7-git-send-email-kosaki.motohiro@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1339406250-10169-1-git-send-email-kosaki.motohiro@gmail.com>
References: <1339406250-10169-1-git-send-email-kosaki.motohiro@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Christoph Lameter <cl@linux.com>
---
 MAINTAINERS |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a246490..6f4a8e2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4467,6 +4467,13 @@ F:	drivers/mtd/
 F:	include/linux/mtd/
 F:	include/mtd/
 
+MEMPOLICY
+M:	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	include/linux/mempolicy.h
+F:	mm/mempolicy.c
+
 MICROBLAZE ARCHITECTURE
 M:	Michal Simek <monstr@monstr.eu>
 L:	microblaze-uclinux@itee.uq.edu.au (moderated for non-subscribers)
-- 
1.7.1


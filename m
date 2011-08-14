Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab1HNTIG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 15:08:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16877 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754696Ab1HNTIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 15:08:01 -0400
From: Jes.Sorensen@redhat.com
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Remove name and email address as maintainer for SN2
Date: Sun, 14 Aug 2011 21:05:06 +0200
Message-Id: <1313348706-16093-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@gmail.com>
---
 MAINTAINERS |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1d445f5..79080e0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5921,7 +5921,6 @@ S:	Supported
 F:	drivers/net/smsc9420.*
 
 SN-IA64 (Itanium) SUB-PLATFORM
-M:	Jes Sorensen <jes@sgi.com>
 L:	linux-altix@sgi.com
 L:	linux-ia64@vger.kernel.org
 W:	http://www.sgi.com/altix
-- 
1.7.4.4


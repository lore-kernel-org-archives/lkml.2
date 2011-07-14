Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122Ab1GNQJn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 12:09:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932090Ab1GNQJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 12:09:40 -0400
Date: Thu, 14 Jul 2011 12:09:35 -0400
From: Jason Baron <jbaron@redhat.com>
To: gregkh@suse.de
Cc: joe@perches.com, jim.cromie@gmail.com, bvanassche@acm.org,
        linux-kernel@vger.kernel.org
Message-Id: <fb390d961aee325254f9f3747d835568e2d8e4e6.1310657068.git.jbaron@redhat.com>
In-Reply-To: <cover.1310657068.git.jbaron@redhat.com>
References: <cover.1310657068.git.jbaron@redhat.com>
Subject: [PATCH 06/11] dynamic_debug: add Jason Baron as maintainer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

Add a maintainers entry for dynamic debug. Hopefully nobody
will object to me as maintainer...

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 187282d..84133a0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2274,6 +2274,12 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/wan/dscc4.c
 
+DYNAMIC DEBUG
+M:	Jason Baron <jbaron@redhat.com>
+S:	Maintained
+F:	lib/dynamic_debug.c
+F:	include/linux/dynamic_debug.h
+
 DZ DECSTATION DZ11 SERIAL DRIVER
 M:	"Maciej W. Rozycki" <macro@linux-mips.org>
 S:	Maintained
-- 
1.7.5.4


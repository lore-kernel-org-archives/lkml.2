Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160Ab1GEQmb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 12:42:31 -0400
Received: from mail.perches.com ([173.55.12.10]:3562 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755988Ab1GEQma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 12:42:30 -0400
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org
Subject: [PATCH 12/14] MAINTAINERS: Add STAGING - AGERE HERMES II and II.5 WIRELESS DRIVERS
Date: Tue,  5 Jul 2011 09:42:12 -0700
Message-Id: <311f19132eafdfd0c3843a5ee79419c53dda90ae.1309883752.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.131.g99019
In-Reply-To: <cover.1309883752.git.joe@perches.com>
References: <20110704153435.GA17475@suse.de> <cover.1309883752.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index cfb22e2..9ab3703 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6069,6 +6069,12 @@ L:	devel@driverdev.osuosl.org
 S:	Maintained
 F:	drivers/staging/
 
+STAGING - AGERE HERMES II and II.5 WIRELESS DRIVERS
+M:	Henk de Groot <pe1dnn@amsat.org>
+S:	Odd Fixes
+F:	drivers/staging/wlags49_h2/
+F:	drivers/staging/wlags49_h25/
+
 STAGING - ASUS OLED
 M:	Jakub Schmidtke <sjakub@gmail.com>
 S:	Odd Fixes
-- 
1.7.6.131.g99019


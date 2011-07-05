Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184Ab1GEQqE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 12:46:04 -0400
Received: from mail.perches.com ([173.55.12.10]:3530 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755895Ab1GEQmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 12:42:18 -0400
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org
Subject: [PATCH 01/14] MAINTAINERS: Add STAGING - ASUS OLED
Date: Tue,  5 Jul 2011 09:42:01 -0700
Message-Id: <90fc4de7cb8280d3f11c92bbe696bd1cdffd1699.1309883752.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.131.g99019
In-Reply-To: <cover.1309883752.git.joe@perches.com>
References: <20110704153435.GA17475@suse.de> <cover.1309883752.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7fe708d..6f0d683 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6069,6 +6069,11 @@ L:	devel@driverdev.osuosl.org
 S:	Maintained
 F:	drivers/staging/
 
+STAGING - ASUS OLED
+M:	Jakub Schmidtke <sjakub@gmail.com>
+S:	Odd Fixes
+F:	drivers/staging/asus_oled/
+
 STARFIRE/DURALAN NETWORK DRIVER
 M:	Ion Badulescu <ionut@badula.org>
 S:	Odd Fixes
-- 
1.7.6.131.g99019


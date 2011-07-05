Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244Ab1GEQnQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 12:43:16 -0400
Received: from mail.perches.com ([173.55.12.10]:3560 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756101Ab1GEQm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 12:42:29 -0400
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org
Subject: [PATCH 11/14] MAINTAINERS: Add STAGING - WINBOND IS89C35 WLAN USB DRIVER
Date: Tue,  5 Jul 2011 09:42:11 -0700
Message-Id: <ddb5d73fc1fa8374d3b10000d705d85cce671fdc.1309883752.git.joe@perches.com>
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
index ac25e66..cfb22e2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6125,6 +6125,11 @@ M:	Forest Bond <forest@alittletooquiet.net>
 S:	Odd Fixes
 F:	drivers/staging/vt665?/
 
+STAGING - WINBOND IS89C35 WLAN USB DRIVER
+M:	Pavel Machek <pavel@ucw.cz>
+S:	Odd Fixes
+F:	drivers/staging/winbond/
+
 STARFIRE/DURALAN NETWORK DRIVER
 M:	Ion Badulescu <ionut@badula.org>
 S:	Odd Fixes
-- 
1.7.6.131.g99019


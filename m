Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab1GEQm3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 12:42:29 -0400
Received: from mail.perches.com ([173.55.12.10]:3557 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755988Ab1GEQm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 12:42:27 -0400
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org
Subject: [PATCH 10/14] MAINTAINERS: Add STAGING - VIA VT665X DRIVERS
Date: Tue,  5 Jul 2011 09:42:10 -0700
Message-Id: <c5d540ba15124222434fff0317f0c0d7d8d653bd.1309883752.git.joe@perches.com>
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
index b0ce557..ac25e66 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6120,6 +6120,11 @@ M:	Teddy Wang <teddy.wang@siliconmotion.com.cn>
 S:	Odd Fixes
 F:	drivers/staging/sm7xx/
 
+STAGING - VIA VT665X DRIVERS
+M:	Forest Bond <forest@alittletooquiet.net>
+S:	Odd Fixes
+F:	drivers/staging/vt665?/
+
 STARFIRE/DURALAN NETWORK DRIVER
 M:	Ion Badulescu <ionut@badula.org>
 S:	Odd Fixes
-- 
1.7.6.131.g99019


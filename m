Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab1GEQmy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 12:42:54 -0400
Received: from mail.perches.com ([173.55.12.10]:3565 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756136Ab1GEQmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 12:42:31 -0400
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org
Subject: [PATCH 13/14] MAINTAINERS: Add STAGING - XGI Z7,Z9,Z11 PCI DISPLAY DRIVER
Date: Tue,  5 Jul 2011 09:42:13 -0700
Message-Id: <0986a61108b6b514017d7d829e51fd5f7c37d4e9.1309883752.git.joe@perches.com>
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
index 9ab3703..bd46c4f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6136,6 +6136,11 @@ M:	Pavel Machek <pavel@ucw.cz>
 S:	Odd Fixes
 F:	drivers/staging/winbond/
 
+STAGING - XGI Z7,Z9,Z11 PCI DISPLAY DRIVER
+M:	Arnaud Patard <apatard@mandriva.com>
+S:	Odd Fixes
+F:	drivers/staging/xgifb/
+
 STARFIRE/DURALAN NETWORK DRIVER
 M:	Ion Badulescu <ionut@badula.org>
 S:	Odd Fixes
-- 
1.7.6.131.g99019


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab1GEQmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 12:42:23 -0400
Received: from mail.perches.com ([173.55.12.10]:3538 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755873Ab1GEQmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 12:42:21 -0400
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org
Subject: [PATCH 04/14] MAINTAINERS: Add STAGING - ECHO CANCELLER
Date: Tue,  5 Jul 2011 09:42:04 -0700
Message-Id: <45d39d3a57ad79b15007dfbf66a43f5fb9438c20.1309883752.git.joe@perches.com>
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
index e42923b..320fd7c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6088,6 +6088,12 @@ M:	Manu Abraham <abraham.manu@gmail.com>
 S:	Odd Fixes
 F:	drivers/staging/crystalhd/
 
+STAGING - ECHO CANCELLER
+M:	Steve Underwood <steveu@coppice.org>
+M:	David Rowe <david@rowetel.com>
+S:	Odd Fixes
+F:	drivers/staging/echo/
+
 STARFIRE/DURALAN NETWORK DRIVER
 M:	Ion Badulescu <ionut@badula.org>
 S:	Odd Fixes
-- 
1.7.6.131.g99019


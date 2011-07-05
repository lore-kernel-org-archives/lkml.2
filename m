Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab1GEQm0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 12:42:26 -0400
Received: from mail.perches.com ([173.55.12.10]:3548 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756050Ab1GEQmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 12:42:24 -0400
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org
Subject: [PATCH 07/14] MAINTAINERS: Add STAGING - INDUSTRIAL IO
Date: Tue,  5 Jul 2011 09:42:07 -0700
Message-Id: <903b980cd3b10492159055a1445402ceb3e124de.1309883752.git.joe@perches.com>
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
index 70ccf25..9968b10 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6105,6 +6105,11 @@ M:	Haiyang Zhang <haiyangz@microsoft.com>
 S:	Odd Fixes
 F:	drivers/staging/hv/
 
+STAGING - INDUSTRIAL IO
+M:	Jonathan Cameron <jic23@cam.ac.uk>
+S:	Odd Fixes
+F:	drivers/staging/iio/
+
 STARFIRE/DURALAN NETWORK DRIVER
 M:	Ion Badulescu <ionut@badula.org>
 S:	Odd Fixes
-- 
1.7.6.131.g99019


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab1GEQnj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 12:43:39 -0400
Received: from mail.perches.com ([173.55.12.10]:3552 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756050Ab1GEQm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 12:42:26 -0400
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org
Subject: [PATCH 09/14] MAINTAINERS: Add STAGING - SILICON MOTION SM7XX FRAME BUFFER DRIVER
Date: Tue,  5 Jul 2011 09:42:09 -0700
Message-Id: <f9bf025d2cf08d8bb7e1d2aa9963f9e30bb3c6fa.1309883752.git.joe@perches.com>
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
index 9cd7ea9..b0ce557 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6115,6 +6115,11 @@ M:	Willy Tarreau <willy@meta-x.org>
 S:	Odd Fixes
 F:	drivers/staging/panel/
 
+STAGING - SILICON MOTION SM7XX FRAME BUFFER DRIVER
+M:	Teddy Wang <teddy.wang@siliconmotion.com.cn>
+S:	Odd Fixes
+F:	drivers/staging/sm7xx/
+
 STARFIRE/DURALAN NETWORK DRIVER
 M:	Ion Badulescu <ionut@badula.org>
 S:	Odd Fixes
-- 
1.7.6.131.g99019


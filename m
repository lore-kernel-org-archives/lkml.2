Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab1GEQm1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 12:42:27 -0400
Received: from mail.perches.com ([173.55.12.10]:3551 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755988Ab1GEQmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 12:42:25 -0400
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org
Subject: [PATCH 08/14] MAINTAINERS: Add STAGING - PARALLEL LCD/KEYPAD PANEL DRIVER
Date: Tue,  5 Jul 2011 09:42:08 -0700
Message-Id: <64c23d1172a82a48d8c7b362224e1d7f9e08dd1e.1309883752.git.joe@perches.com>
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
index 9968b10..9cd7ea9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6110,6 +6110,11 @@ M:	Jonathan Cameron <jic23@cam.ac.uk>
 S:	Odd Fixes
 F:	drivers/staging/iio/
 
+STAGING -  PARALLEL LCD/KEYPAD PANEL DRIVER
+M:	Willy Tarreau <willy@meta-x.org>
+S:	Odd Fixes
+F:	drivers/staging/panel/
+
 STARFIRE/DURALAN NETWORK DRIVER
 M:	Ion Badulescu <ionut@badula.org>
 S:	Odd Fixes
-- 
1.7.6.131.g99019


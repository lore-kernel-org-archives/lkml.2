Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758659Ab0FLBIb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 21:08:31 -0400
Received: from mail.perches.com ([173.55.12.10]:1073 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823Ab0FLBG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 21:06:59 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: [PATCH 2/7] MAINTAINERS: Add patterns to DELL WMI EXTRAS
Date: Fri, 11 Jun 2010 18:06:51 -0700
Message-Id: <1aedd17bdc6eee1c7b384b354434bf9f1e80d1c7.1276304638.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.244.gbdc4
In-Reply-To: <cover.1276304638.git.joe@perches.com>
References: <cover.1276304638.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
---
 MAINTAINERS |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index aa236b5..f322c72 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1875,6 +1875,7 @@ F:	drivers/firmware/dcdbas.*
 DELL WMI EXTRAS DRIVER
 M:	Matthew Garrett <mjg59@srcf.ucam.org>
 S:	Maintained
+F:	drivers/platform/x86/dell-wmi.c
 
 DEVICE NUMBER REGISTRY
 M:	Torben Mathiasen <device@lanana.org>
-- 
1.7.1.244.gbdc4


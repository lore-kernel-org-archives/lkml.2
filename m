Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932999Ab2GYDth (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 23:49:37 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:46154 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932925Ab2GYDmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 23:42:54 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: [PATCH 28/52] ACPI: remove acpi_pad MAINTAINERS entry
Date: Tue, 24 Jul 2012 23:41:24 -0400
Message-Id: <442f24ace6c5991df2a9ab49fe0273b79b145d19.1343187617.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.12.rc0
In-Reply-To: <1343187708-19532-1-git-send-email-lenb@kernel.org>
References: <1343187708-19532-1-git-send-email-lenb@kernel.org>
In-Reply-To: <6af1c4fc5227af65092ebc848989693562bfa3e8.1343187617.git.len.brown@intel.com>
References: <6af1c4fc5227af65092ebc848989693562bfa3e8.1343187617.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

As Shaohua is no longer in this neck of the woods,
and thus treat the acpi_pad driver as just another
part of drivers/acpi/

Signed-off-by: Len Brown <len.brown@intel.com>
---
 MAINTAINERS | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 14bc707..508a935 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -242,13 +242,6 @@ W:	http://www.lesswatts.org/projects/acpi/
 S:	Supported
 F:	drivers/acpi/fan.c
 
-ACPI PROCESSOR AGGREGATOR DRIVER
-M:	Shaohua Li <shaohua.li@intel.com>
-L:	linux-acpi@vger.kernel.org
-W:	http://www.lesswatts.org/projects/acpi/
-S:	Supported
-F:	drivers/acpi/acpi_pad.c
-
 ACPI THERMAL DRIVER
 M:	Zhang Rui <rui.zhang@intel.com>
 L:	linux-acpi@vger.kernel.org
-- 
1.7.12.rc0


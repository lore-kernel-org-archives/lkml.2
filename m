Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab2JIGEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:04:45 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:58217 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab2JIGD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:03:59 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 30/30] tools/power/acpi/acpidump: remove duplicated include from acpidump.c
Date: Tue,  9 Oct 2012 01:54:20 -0400
Message-Id: <4084a9b99ccd05bf5e13dcd248e3b56a682fa4d6.1349761836.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.0.rc1
In-Reply-To: <1349762060-25334-1-git-send-email-lenb@kernel.org>
References: <1349762060-25334-1-git-send-email-lenb@kernel.org>
In-Reply-To: <e3f25e6e5836c4790fbe395ff42e241f372d859d.1349761836.git.len.brown@intel.com>
References: <e3f25e6e5836c4790fbe395ff42e241f372d859d.1349761836.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 tools/power/acpi/acpidump.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/power/acpi/acpidump.c b/tools/power/acpi/acpidump.c
index 0777987..a84553a 100644
--- a/tools/power/acpi/acpidump.c
+++ b/tools/power/acpi/acpidump.c
@@ -62,7 +62,6 @@ typedef long long			s64;
 #include <unistd.h>
 #include <getopt.h>
 
-#include <sys/types.h>
 #include <dirent.h>
 
 #include <acpi/acconfig.h>
-- 
1.8.0.rc1


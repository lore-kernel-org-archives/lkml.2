Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab2JHMbO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 08:31:14 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:64952 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab2JHMbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 08:31:09 -0400
MIME-Version: 1.0
Date: Mon, 8 Oct 2012 20:31:08 +0800
Message-ID: <CAPgLHd92c7V6gAKYB1+9Hp8O6HEDycGPJYi_G0Q5uiY62XtAVQ@mail.gmail.com>
Subject: [PATCH] tools/power/acpi/acpidump: remove duplicated include from acpidump.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: len.brown@intel.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
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


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab0ERKWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 06:22:51 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:22828 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab0ERKWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 06:22:50 -0400
From: Wenji Huang <wenji.huang@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Wenji Huang <wenji.huang@oracle.com>
Subject: [PATCH 1/1] module: remove duplicate declaration of __ksymtab_gpl_future
Date: Tue, 18 May 2010 17:06:45 +0800
Message-Id: <1274173605-20162-1-git-send-email-wenji.huang@oracle.com>
X-Mailer: git-send-email 1.5.6
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090201.4BF26A78.006F:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor cleanup on duplicate __{start/stop}__ksymtab_gpl_future.

Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
---
 kernel/module.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 1016b75..cfb621c 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -178,8 +178,6 @@ extern const struct kernel_symbol __start___ksymtab_gpl[];
 extern const struct kernel_symbol __stop___ksymtab_gpl[];
 extern const struct kernel_symbol __start___ksymtab_gpl_future[];
 extern const struct kernel_symbol __stop___ksymtab_gpl_future[];
-extern const struct kernel_symbol __start___ksymtab_gpl_future[];
-extern const struct kernel_symbol __stop___ksymtab_gpl_future[];
 extern const unsigned long __start___kcrctab[];
 extern const unsigned long __start___kcrctab_gpl[];
 extern const unsigned long __start___kcrctab_gpl_future[];
-- 
1.5.6


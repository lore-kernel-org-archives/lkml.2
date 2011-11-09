Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620Ab1KIIQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 03:16:20 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:19566 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab1KIIQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 03:16:19 -0500
From: annie.li@oracle.com
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, jeremy@goop.org
Cc: kurt.hackel@oracle.com, paul.durrant@citrix.com, annie.li@oracle.com
Subject: [PATCH 3/3] code clean up
Date: Wed,  9 Nov 2011 16:16:14 +0800
Message-Id: <1320826574-29427-1-git-send-email-annie.li@oracle.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <4EBA35D3.3020506@oracle.com>
References: <4EBA35D3.3020506@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090208.4EBA36CE.006B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Annie Li <annie.li@oracle.com>

Signed-off-by: Annie Li <annie.li@oracle.com>
---
 drivers/xen/grant-table.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index a3294a26..458c00d 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -708,7 +708,8 @@ static void gnttab_request_version(void)
 {
 	int rc;
 	struct gnttab_set_version gsv;
-	const char *str = "we need grant tables version 2, but only version 1 is available\n";
+	const char *str = "we need grant tables version 2, "
+					"but only version 1 is available\n";
 
 	gsv.version = 2;
 	rc = HYPERVISOR_grant_table_op(GNTTABOP_set_version, &gsv, 1);
-- 
1.7.6


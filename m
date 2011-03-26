Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab1CZBk2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 21:40:28 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:33560 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932402Ab1CZBkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 21:40:22 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/M/3Bvsy7Mb39VUpaxZgdWU2zBgUCUIiqL4f96yQ
	nKxGgZQRzPLMHN
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: Greg KH <gregkh@suse.de>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, Harry Wei <jiaweiwei.xiyou@gmail.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 13/27] staging/octeon: Fix common spelling mistakes
Date: Sat, 26 Mar 2011 02:39:22 +0100
Message-Id: <1301103576-16109-13-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1301103576-16109-8-git-send-email-peterhuewe@gmx.de>
References: <1301103576-16109-8-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a very common spelling mistake in
drivers/staging/octeon.

WRONG -> RIGHT
occured     -> occurred

Kernel Version: staging/staging-next 20110325 (4bbba111)

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/octeon/cvmx-helper.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/octeon/cvmx-helper.c b/drivers/staging/octeon/cvmx-helper.c
index 5915066..e9c5c83 100644
--- a/drivers/staging/octeon/cvmx-helper.c
+++ b/drivers/staging/octeon/cvmx-helper.c
@@ -691,7 +691,7 @@ int __cvmx_helper_errata_fix_ipd_ptr_alignment(void)
 
 		if (!retry_cnt)
 			cvmx_dprintf("WARNING: FIX_IPD_PTR_ALIGNMENT "
-				     "get_work() timeout occured.\n");
+				     "get_work() timeout occurred.\n");
 
 		/* Free packet */
 		if (work)
-- 
1.7.3.4


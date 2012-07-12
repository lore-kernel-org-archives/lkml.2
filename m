Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261Ab2GLI3q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 04:29:46 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:62935 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab2GLI3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 04:29:44 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-fd-4ffe8af614d1
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] MAINTAINERS: Update EXYNOS DP DRIVER F: patterns
Date: Thu, 12 Jul 2012 17:29:42 +0900
Message-id: <000e01cd6008$7c57dbf0$750793d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1gCHxCy5jEz5wmSdyvywe/3fM/Dg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t9jQd1vXf/8Dc6+N7K4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZJ78/ZC5Yx1IxbccrtgbGE8xdjJwcEgImEg9frmKBsMUkLtxb
	zwZiCwlMZ5R4dj+li5ELyJ7NJPFqwS6wBJuAmsSXL4fZQWwRgQiJ5hmzwAYxA8X/TG1hBLGF
	BRwldk6YA2azCKhKPH/2GKyGV8BW4unFySwQtqDEj8n3WCB6tSTW7zzOBGHLS2xe8xaongPo
	IHWJR391IVbpSUzd0ANVLiKx78U7xgmMArOQTJqFZNIsJJNmIWlZwMiyilE0tSC5oDgpPddI
	rzgxt7g0L10vOT93EyM4LJ9J72Bc1WBxiFGAg1GJhzei7Z+/EGtiWXFl7iFGCQ5mJRHe/lyg
	EG9KYmVValF+fFFpTmrxIUZpDhYlcV4T76/+QgLpiSWp2ampBalFMFkmDk6pBsaYev2W+Spx
	X5bmm3q9b49ZyWS4KoIjd/8agenrk1cs/3Hg1zqHZ2VbdnMHzOvuuv5c28X6T/mFwMuL2Gpr
	PX+dYdkRevv34xP73JiLBJ/uEtT84rZZY11iWJlR7la9TBcBpckeU2/b7Y+f1z2T2fvgmU3X
	O7dO0es8wOjeMkHv4dvgZ7ILNLcpsRRnJBpqMRcVJwIAscndAUcCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add patterns for Exynos DP header to MAINTAINERS file.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 MAINTAINERS |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3d7191b..3fbb995 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2724,6 +2724,7 @@ M:	Jingoo Han <jg1.han@samsung.com>
 L:	linux-fbdev@vger.kernel.org
 S:	Maintained
 F:	drivers/video/exynos/exynos_dp*
+F:	include/video/exynos_dp*
 
 EXYNOS MIPI DISPLAY DRIVERS
 M:	Inki Dae <inki.dae@samsung.com>
-- 
1.7.1



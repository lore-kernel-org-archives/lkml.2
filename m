Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751333Ab2LVFVc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 00:21:32 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:42046 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827Ab2LVFVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 00:21:19 -0500
From: Simon Marchi <simon.marchi@polymtl.ca>
To: cmetcalf@tilera.com
Cc: linux-kernel@vger.kernel.org, Simon Marchi <simon.marchi@polymtl.ca>
Subject: [PATCH 3/3] arch/tile: Enable HAVE_ARCH_TRACEHOOK
Date: Sat, 22 Dec 2012 00:21:12 -0500
Message-Id: <1356153672-17545-3-git-send-email-simon.marchi@polymtl.ca>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1356153672-17545-1-git-send-email-simon.marchi@polymtl.ca>
References: <1356153672-17545-1-git-send-email-simon.marchi@polymtl.ca>
X-Poly-FromMTA: ([132.207.72.18]) at Sat, 22 Dec 2012 05:21:12 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like we have everything needed for that.

Signed-off-by: Simon Marchi <simon.marchi@polymtl.ca>
---
 arch/tile/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 875d008..8cab409 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -21,6 +21,7 @@ config TILE
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_CLOCKEVENTS
 	select MODULES_USE_ELF_RELA
+	select HAVE_ARCH_TRACEHOOK
 
 # FIXME: investigate whether we need/want these options.
 #	select HAVE_IOREMAP_PROT
-- 
1.7.1


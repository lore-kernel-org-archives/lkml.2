Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab1LVQV4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 11:21:56 -0500
Received: from border.exmeritus.com ([70.167.241.26]:32826 "EHLO
	border.exmeritus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400Ab1LVQVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 11:21:52 -0500
From: Kyle Moffett <Kyle.D.Moffett@boeing.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: Kyle Moffett <Kyle.D.Moffett@boeing.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arch/powerpc/kvm/e500: Additional module.h => export.h fixup
Date: Thu, 22 Dec 2011 11:21:03 -0500
Message-Id: <1324570863-11447-1-git-send-email-Kyle.D.Moffett@boeing.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file, like many others, needs to include <linux/export.h>.

Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
---
 arch/powerpc/kvm/e500.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kvm/e500.c b/arch/powerpc/kvm/e500.c
index 26d2090..387c383 100644
--- a/arch/powerpc/kvm/e500.c
+++ b/arch/powerpc/kvm/e500.c
@@ -13,6 +13,7 @@
  */
 
 #include <linux/kvm_host.h>
+#include <linux/export.h>
 #include <linux/slab.h>
 #include <linux/err.h>
 
-- 
1.7.7.3


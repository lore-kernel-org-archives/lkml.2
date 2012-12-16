Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127Ab2LPRYz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 12:24:55 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:43759 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab2LPRYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 12:24:53 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: Hideki EIRAKU <hdk@igel.co.jp>
Cc: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Katsuya MATSUBARA <matsu@igel.co.jp>,
        Damian Hobson-Garcia <dhobsong@igel.co.jp>
Subject: [PATCH/WIP/RFC 01/14] ARM: sh-mobile: Protect ipmmu.h header with ifndef/define
Date: Sun, 16 Dec 2012 18:25:47 +0100
Message-Id: <1355678760-27357-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1355678760-27357-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1350290093-998-1-git-send-email-hdk@igel.co.jp>
 <1355678760-27357-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 arch/arm/mach-shmobile/include/mach/ipmmu.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-shmobile/include/mach/ipmmu.h b/arch/arm/mach-shmobile/include/mach/ipmmu.h
index ede2f0b..4b805b1f 100644
--- a/arch/arm/mach-shmobile/include/mach/ipmmu.h
+++ b/arch/arm/mach-shmobile/include/mach/ipmmu.h
@@ -1,3 +1,6 @@
+#ifndef __SHMOBILE_IPMMU_H__
+#define __SHMOBILE_IPMMU_H__
+
 #ifdef CONFIG_SHMOBILE_IPMMU_TLB
 void ipmmu_tlb_flush(struct device *ipmmu_dev);
 void ipmmu_tlb_set(struct device *ipmmu_dev, unsigned long phys, int size,
@@ -14,3 +17,5 @@ static int ipmmu_iommu_init(struct device *dev)
 	return -EINVAL;
 }
 #endif
+
+#endif /* __SHMOBILE_IPMMU_H__ */
-- 
1.7.8.6


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab2DIHVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 03:21:31 -0400
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:44013 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753835Ab2DIHV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 03:21:29 -0400
From: Tanmay Inamdar <tinamdar@apm.com>
To: benh@kernel.crashing.org, jwboyer@gmail.com, grant.likely@secretlab.ca,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: Tanmay Inamdar <tinamdar@apm.com>
Subject: [V2 2/5] powerpc: 40x: Add AHB, APB of_device_ids
Date: Mon,  9 Apr 2012 12:50:49 +0530
Message-Id: <1333956052-25319-2-git-send-email-tinamdar@apm.com>
X-Mailer: git-send-email 1.6.1.rc3
In-Reply-To: <1333956052-25319-1-git-send-email-tinamdar@apm.com>
References: <1333956052-25319-1-git-send-email-tinamdar@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding of_device_id's for AHB and APB buses used in klondike (APM8018X) in
platforms/40x/ppc40x_simple.c file

Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>
---
:100644 100644 9761206... 7b518ed... M	arch/powerpc/platforms/40x/ppc40x_simple.c
 arch/powerpc/platforms/40x/ppc40x_simple.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/platforms/40x/ppc40x_simple.c b/arch/powerpc/platforms/40x/ppc40x_simple.c
index 9761206..7b518ed 100644
--- a/arch/powerpc/platforms/40x/ppc40x_simple.c
+++ b/arch/powerpc/platforms/40x/ppc40x_simple.c
@@ -29,6 +29,8 @@ static __initdata struct of_device_id ppc40x_of_bus[] = {
 	{ .compatible = "ibm,plb4", },
 	{ .compatible = "ibm,opb", },
 	{ .compatible = "ibm,ebc", },
+	{ .compatible = "apm,ahb", },
+	{ .compatible = "apm,apb", },
 	{ .compatible = "simple-bus", },
 	{},
 };
-- 
1.6.1.rc3


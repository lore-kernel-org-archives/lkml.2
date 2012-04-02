Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548Ab2DBGue (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 02:50:34 -0400
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:46617 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751323Ab2DBGuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 02:50:18 -0400
X-Greylist: delayed 618 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Apr 2012 02:50:18 EDT
From: Tanmay Inamdar <tinamdar@apm.com>
To: benh@kernel.crashing.org, jwboyer@gmail.com, grant.likely@secretlab.ca,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: Tanmay Inamdar <tinamdar@apm.com>
Subject: [PATCH 2/5] powerpc: 40x: Add AHB, APB of_device_ids
Date: Mon,  2 Apr 2012 12:09:04 +0530
Message-Id: <1333348747-12713-2-git-send-email-tinamdar@apm.com>
X-Mailer: git-send-email 1.6.1.rc3
In-Reply-To: <1333348747-12713-1-git-send-email-tinamdar@apm.com>
References: <1333348747-12713-1-git-send-email-tinamdar@apm.com>
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


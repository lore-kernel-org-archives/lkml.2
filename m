Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934197Ab2EXV62 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 17:58:28 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:20576 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934133Ab2EXV61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 17:58:27 -0400
Message-ID: <1337896705.2718.103.camel@lorien2>
Subject: [PATCH] Documentation: kernel-parameters.txt Add amd_iommu_dump
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: rob@landley.net, joerg.roedel@amd.com
Cc: shuahkhan@gmail.com, linux-doc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 24 May 2012 15:58:25 -0600
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add amd_iommu_dump to kernel-parameters.txt

Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
---
 Documentation/kernel-parameters.txt |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 1dae7ce..cbfee13 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -335,6 +335,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 					  requirements as needed. This option
 					  does not override iommu=pt
 
+	amd_iommu_dump=	[HW,X86-64]
+			Enable AMD IOMMU driver option to dump the ACPI table
+			for AMD IOMMU. With this option enabled, AMD IOMMU
+			driver will print ACPI tables for AMD IOMMU during
+			IOMMU initialization.
+
 	amijoy.map=	[HW,JOY] Amiga joystick support
 			Map of devices attached to JOY0DAT and JOY1DAT
 			Format: <a>,<b>
-- 
1.7.9.5




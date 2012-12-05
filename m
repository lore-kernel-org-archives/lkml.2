Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab2LEQJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 11:09:31 -0500
Received: from multi.imgtec.com ([194.200.65.239]:55566 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813Ab2LEQJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 11:09:25 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, James Hogan <james.hogan@imgtec.com>,
        "Grant Likely" <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: [PATCH v2 06/44] of/vendor-prefixes: add Imagination Technologies
Date: Wed, 5 Dec 2012 16:08:24 +0000
Message-ID: <1354723742-6195-7-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2012_12_05_16_09_13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "powervr" prefix which is currently described as "Imagination
Technologies" isn't really appropriate for non-PowerVR hardware, so
deprecate it, changing the description of "powervr" to "PowerVR
(deprecated, use img)", and add a separate "img" prefix for "Imagination
Technologies Ltd.".

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: devicetree-discuss@lists.ozlabs.org
---
 .../devicetree/bindings/vendor-prefixes.txt        |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 9de2b9f..aab2993 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -25,6 +25,7 @@ gef	GE Fanuc Intelligent Platforms Embedded Systems, Inc.
 hp	Hewlett Packard
 ibm	International Business Machines (IBM)
 idt	Integrated Device Technologies, Inc.
+img	Imagination Technologies Ltd.
 intercontrol	Inter Control Group
 linux	Linux-specific binding
 marvell	Marvell Technology Group Ltd.
@@ -35,7 +36,7 @@ nintendo	Nintendo
 nvidia	NVIDIA
 nxp	NXP Semiconductors
 picochip	Picochip Ltd
-powervr	Imagination Technologies
+powervr	PowerVR (deprecated, use img)
 qcom	Qualcomm, Inc.
 ramtron	Ramtron International
 realtek Realtek Semiconductor Corp.
-- 
1.7.7.6



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab2KINHJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 08:07:09 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:57441 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab2KINHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 08:07:07 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Rob Herring <rob.herring@calxeda.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] of: Add vendor prefix for ON Semiconductor Corp.
Date: Fri,  9 Nov 2012 14:07:01 +0100
Message-Id: <1352466421-27480-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.0
X-Provags-ID: V02:K0:+TXe/umAinF5SP+DqMd98rXmt3RBu/1l76a97/hW9xa
 8IbnYppWt+01rr5FAPt88UlkQPV5UPynZ0Hj3o/vjENiYRbOrD
 Ou975qF0DJY41xD6LlK34PLevd7DouzcgIsQZ++nXKMV3wq6+v
 +yW0mD43qFhIIqf+Z08rXkIr0uKSA6KzRIiUOdPFroM1xX3hxN
 9ucBCZRNWvK89lTtDSJrs3mwksrLQx13+7bNVxzhGTHBRmss6m
 c7oUWfHFlP3KnbmG/GRHX+cWej0SJAI2G9Hn6r67dnKpCH1Rjt
 ObLcTNs3qJ4oxt6xu4d/lf3hGZzFvNlA8aC6pcJEPUMxuz6b+T
 yO3M8orME9tq9WL1crgkHBxm3uBBgdFjIEMuKg2Mo06UA5pD/X
 xbxN47mRypzcAfE8mU8tgRi4uiK7/e5qJitnuGCpQ5D/9rVfgX
 M44Cl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The used vendor prefix corresponds to the stock symbol (ONNN) for ON
Semiconductor Corp.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index ac2c2c4..deba8d0 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -34,6 +34,7 @@ national	National Semiconductor
 nintendo	Nintendo
 nvidia	NVIDIA
 nxp	NXP Semiconductors
+onnn	ON Semiconductor Corp.
 picochip	Picochip Ltd
 powervr	Imagination Technologies
 qcom	Qualcomm, Inc.
-- 
1.8.0


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab2DWMNT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 08:13:19 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15343 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300Ab2DWMNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 08:13:15 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 23 Apr 2012 05:12:57 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, jic23@cam.ac.uk, gregkh@linuxfoundation.org,
        swarren@nvidia.com, olof@lixom.net,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-tegra@vger.kernel.org
Cc: Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 1/4] devicetree: Document Intersil Corporation vendor prefix
Date: Mon, 23 Apr 2012 17:41:33 +0530
Message-Id: <1335183097-21104-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1335183097-21104-1-git-send-email-ldewangan@nvidia.com>
References: <1335183097-21104-1-git-send-email-ldewangan@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1:
- Change the vendor prefix for Intersil Corporation to "isil".

 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 107d8ad..5c78eb2 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -23,6 +23,7 @@ hp	Hewlett Packard
 ibm	International Business Machines (IBM)
 idt	Integrated Device Technologies, Inc.
 intercontrol	Inter Control Group
+isil	Intersil Corporation
 linux	Linux-specific binding
 marvell	Marvell Technology Group Ltd.
 maxim	Maxim Integrated Products
-- 
1.7.1.1


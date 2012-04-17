Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab2DQGq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 02:46:28 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4768 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab2DQGq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 02:46:26 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 16 Apr 2012 23:46:25 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: grant.likely@secretlab.ca, rob.herring@calxeda.com, rdunlap@xenotime.net,
        linux@arm.linux.org.uk, jic23@cam.ac.uk, gregkh@linuxfoundation.org,
        broonie@opensource.wolfsonmicro.com, swarren@nvidia.com,
        cbouatmailru@gmail.com, olof@lixom.net, linus.walleij@linaro.org,
        lars@metafoo.de, bfreed@chromium.org, grundler@chromium.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org
Cc: Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 1/3] devicetree: Document Intersil Corporation vendor prefix
Date: Tue, 17 Apr 2012 12:15:53 +0530
Message-Id: <1334645155-13799-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1334645155-13799-1-git-send-email-ldewangan@nvidia.com>
References: <1334645155-13799-1-git-send-email-ldewangan@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 82ac057..89650da 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -22,6 +22,7 @@ hp	Hewlett Packard
 ibm	International Business Machines (IBM)
 idt	Integrated Device Technologies, Inc.
 intercontrol	Inter Control Group
+isl	Intersil Corporation
 linux	Linux-specific binding
 marvell	Marvell Technology Group Ltd.
 maxim	Maxim Integrated Products
-- 
1.7.1.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab1KHBeM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 20:34:12 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:13742 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab1KHBeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 20:34:10 -0500
From: David Daney <david.daney@cavium.com>
To: devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org
Cc: David Daney <david.daney@cavium.com>
Subject: [PATCH] OF/device-tree: Add some entries to vendor-prefixes.txt
Date: Mon,  7 Nov 2011 17:34:07 -0800
Message-Id: <1320716047-4122-1-git-send-email-david.daney@cavium.com>
X-Mailer: git-send-email 1.7.2.3
X-OriginalArrivalTime: 08 Nov 2011 01:34:10.0233 (UTC) FILETIME=[837A2290:01CC9DB6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are currently using 'cavium', 'cortina' and 'st', add them to the
list of known prefixes.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 .../devicetree/bindings/vendor-prefixes.txt        |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index e855278..d05772c 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -8,7 +8,9 @@ amcc	Applied Micro Circuits Corporation (APM, formally AMCC)
 apm	Applied Micro Circuits Corporation (APM)
 arm	ARM Ltd.
 atmel	Atmel Corporation
+cavium	Cavium, Inc.
 chrp	Common Hardware Reference Platform
+cortina	Cortina Systems, Inc.
 dallas	Maxim Integrated Products (formerly Dallas Semiconductor)
 denx	Denx Software Engineering
 epson	Seiko Epson Corp.
@@ -35,6 +37,7 @@ samsung	Samsung Semiconductor
 schindler	Schindler
 simtek
 sirf	SiRF Technology, Inc.
+st	STMicroelectronics
 stericsson	ST-Ericsson
 ti	Texas Instruments
 xlnx	Xilinx
-- 
1.7.2.3

